import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:farumasi_patient_app/domain/repositories/order_repository.dart';
import 'package:farumasi_patient_app/data/models/prescription_order.dart';
import 'package:farumasi_patient_app/domain/repositories/health_repository.dart';
import 'package:farumasi_patient_app/domain/entities/health_article.dart';
import 'package:farumasi_patient_app/data/datasources/notification_service.dart';

class GlobalNotificationWrapper extends StatefulWidget {
  final Widget child;

  const GlobalNotificationWrapper({super.key, required this.child});

  @override
  State<GlobalNotificationWrapper> createState() => _GlobalNotificationWrapperState();
}

class _GlobalNotificationWrapperState extends State<GlobalNotificationWrapper> {
  StreamSubscription<List<PrescriptionOrder>>? _orderSubscription;
  StreamSubscription<List<HealthArticle>>? _healthSubscription;
  
  final Map<String, PrescriptionOrder> _knownOrders = {};
  final Set<String> _knownArticles = {};
  
  bool _isFirstLoadOrders = true;
  bool _isFirstLoadArticles = true;

  @override
  void initState() {
    super.initState();
    _listenToHealthArticles();
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    _healthSubscription?.cancel();
    super.dispose();
  }

  void _listenToHealthArticles() async {
    _healthSubscription?.cancel();
    final prefs = await SharedPreferences.getInstance();
    List<String> cachedArticles = prefs.getStringList('known_articles_cache') ?? [];

    _knownArticles.addAll(cachedArticles);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final healthRepo = context.read<HealthRepository>();

      _healthSubscription = healthRepo.getArticlesStream().listen((articles) {
        bool hasChanges = false;

        if (_isFirstLoadArticles) {
          if (cachedArticles.isEmpty) {
            for (var a in articles) {
              _knownArticles.add(a.id);
            }
            hasChanges = true;
          } else {
            for (var a in articles) {
              if (!_knownArticles.contains(a.id)) {
                _knownArticles.add(a.id);
                hasChanges = true;
                _showArticleNotification(a);
              }
            }
          }
          _isFirstLoadArticles = false;
        } else {
          for (var a in articles) {
            if (!_knownArticles.contains(a.id)) {
              _knownArticles.add(a.id);
              hasChanges = true;
              _showArticleNotification(a);
            }
          }
        }

        if (hasChanges) {
          prefs.setStringList('known_articles_cache', _knownArticles.toList());
        }
      });
    });
  }

  void _showArticleNotification(HealthArticle a) {
    String notificationTitle = 'New Health Update ??';
    switch (a.type) {
      case HealthArticleType.tip:
        notificationTitle = 'New Health Tip ??';
        break;
      case HealthArticleType.remedy:
        notificationTitle = 'New Health Remedy ??';
        break;
      case HealthArticleType.didYouKnow:
        notificationTitle = 'Did you know? ??';
        break;
    }

    NotificationService().showNotification(
      id: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + a.id.hashCode,
      title: notificationTitle,
      body: '\
\n\',
      category: 'health_tip',
      payload: a.id,
    );
  }

  void _listenToOrders(String userId) async {
    _orderSubscription?.cancel();
    final orderRepo = context.read<OrderRepository>();
    final prefs = await SharedPreferences.getInstance();
    
    final cacheKey = 'known_orders_$userId';
    final String? cachedStr = prefs.getString(cacheKey);
    Map<String, String> cachedStatuses = {};
    if (cachedStr != null) {
      try {
        final decoded = jsonDecode(cachedStr) as Map<String, dynamic>;
        cachedStatuses = decoded.map((k, v) => MapEntry(k, v.toString()));
      } catch(e) {}
    }

    _orderSubscription = orderRepo.getOrdersStream(userId).listen((orders) {    
      if (_isFirstLoadOrders) {
        for (var o in orders) {
          _knownOrders[o.id] = o;
          
          if (cachedStatuses.containsKey(o.id) && cachedStatuses[o.id] != o.status.toString()) {
            NotificationService().showNotification(
              id: DateTime.now().millisecondsSinceEpoch ~/ 1000 + o.id.hashCode,
              title: 'Missed Update: Order 📦',
              body: 'While you were away, order #${o.id.substring(0, 8)} became ${_formatStatus(o.status)}.',
              isOrder: true,
              orderId: o.id,
              category: 'order',
              payload: o.id,
            );
          }
        }
        
        cachedStatuses = { for (var o in orders) o.id: o.status.toString() };
        prefs.setString(cacheKey, jsonEncode(cachedStatuses));
        
        _isFirstLoadOrders = false;
        return;
      }

      bool hasChanges = false;
      for (var o in orders) {
        if (!_knownOrders.containsKey(o.id)) {
          _knownOrders[o.id] = o;
          hasChanges = true;
        } else {
          final oldOrder = _knownOrders[o.id]!;
          if (oldOrder.status != o.status) {
            _knownOrders[o.id] = o;
            hasChanges = true;

            NotificationService().showNotification(
              id: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + o.id.hashCode,
              title: 'Order Status Updated 📦',
              body: 'Your order #${o.id.substring(0, 8)} is now ${_formatStatus(o.status)}.',
              isOrder: true,
              orderId: o.id,
              category: 'order',
              payload: o.id,
            );
          }
        }
      }

      if (hasChanges) {
        cachedStatuses = { for (var o in _knownOrders.values) o.id: o.status.toString() };
        prefs.setString(cacheKey, jsonEncode(cachedStatuses));
      }
    });
  }

  String _formatStatus(var status) {
    final str = status.toString().split('.').last;
    return str[0].toUpperCase() + str.substring(1).replaceAllMapped(RegExp(r'[A-Z]'), (Match m) => ' ${m[0]}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated && state.user.id.isNotEmpty) {
          if (_orderSubscription == null) {
            _isFirstLoadOrders = true;
            _knownOrders.clear();
            _listenToOrders(state.user.id);
          }
        } else {
          _orderSubscription?.cancel();
          _orderSubscription = null;
          _knownOrders.clear();
        }
      },
      child: widget.child,
    );
  }
}
