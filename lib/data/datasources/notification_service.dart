import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:convert';
import 'dart:io';
import 'dart:math';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal(); 

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Africa/Kigali'));
    } catch(e){}

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {},
    );

    await _requestPermissions();
    _scheduleHourlyDidYouKnow();
    await _loadFromPrefs();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =     
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  void _scheduleHourlyDidYouKnow() async {
    final List<String> facts = [
      "Drinking water in the morning boosts your metabolism.",
      "Honey and lemon are a great natural remedy for a sore throat.",
      "Walking 30 minutes a day improves cardiovascular health.",
      "Eating an apple a day provides essential dietary fiber.",
      "Adequate sleep strengthens your immune system.",
      "Green tea contains antioxidants that may improve brain function.",
      "Stretching daily increases blood flow to your muscles."
    ];

    final now = tz.TZDateTime.now(tz.local);
    for (int i = 1; i <= 24; i++) {
        var nextHour = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour).add(Duration(hours: i));
        String randomFact = facts[Random().nextInt(facts.length)];
        
        await flutterLocalNotificationsPlugin.zonedSchedule(
            id: i * 1000, 
            title: 'Did you know? 💡', 
            body: randomFact, 
            scheduledDate: nextHour, 
            notificationDetails: const NotificationDetails(
                android: AndroidNotificationDetails(
                    'health_tips_channel', 'Health Tips',
                    channelDescription: 'Did you know daily health tips',
                    importance: Importance.max,
                    priority: Priority.high,
                ),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
    }
  }

  final List<Map<String, dynamic>> notifications = [];
  final List<Map<String, dynamic>> trash = [];

  final ValueNotifier<int> updates = ValueNotifier<int>(0);

  void _notifyListeners() {
    updates.value++;
    _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    final nList = notifications.map((n) {
      return {
        'id': n['id'],
        'title': n['title'],
        'body': n['body'],
        'time': n['time'] is DateTime ? (n['time'] as DateTime).toIso8601String() : DateTime.now().toIso8601String(),
        'isOrder': n['isOrder'],
        'orderId': n['orderId'],
        'isRead': n['isRead'],
        'category': n['category'],
        'payload': n['payload'],
      };
    }).toList();

    await prefs.setString('saved_notifications', jsonEncode(nList));
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('saved_notifications');
    if (saved != null) {
      try {
        final List<dynamic> decoded = jsonDecode(saved);
        notifications.clear();
        for (var item in decoded) {
          notifications.add({
            'id': item['id'],
            'title': item['title'],
            'body': item['body'],
            'time': DateTime.tryParse(item['time'].toString()) ?? DateTime.now(),
            'isOrder': item['isOrder'] ?? false,
            'orderId': item['orderId'],
            'isRead': item['isRead'] ?? false,
            'category': item['category'] ?? 'general',
            'payload': item['payload'],
          });
        }
        updates.value++;
      } catch (e) {
        debugPrint('Error loading notifications: $e');
      }
    }
  }

  void clearNotifications() {
     trash.addAll(notifications);
     notifications.clear();
     _notifyListeners();
  }

  void restoreNotification(int index) {
      if (index >= 0 && index < trash.length) {
          final restored = trash.removeAt(index);
          notifications.insert(0, restored);
          _notifyListeners();
      }
  }

  void permanentlyDeleteNotification(int index) {
      if (index >= 0 && index < trash.length) {
          trash.removeAt(index);
          _notifyListeners();
      }
  }

  void cancelOrderNotification(String orderId) {
      notifications.removeWhere((n) => n['isOrder'] == true && n['orderId'] == orderId);
      _notifyListeners();
  }

  void showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isOrder = false,
    String? orderId,
    String? category, // <== added category argument
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          styleInformation: BigTextStyleInformation(body),
        );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload,
    );

    notifications.insert(0, {
      'id': id,
      'title': title,
      'body': body,
      'time': DateTime.now(),
      'isOrder': isOrder,
      'orderId': orderId,
      'isRead': false,
      'category': category ?? (isOrder ? 'order' : 'general'),
      'payload': payload, // <== storing payload
    });
    _notifyListeners();
  }

  void markAsRead(int id) {
    for (var i = 0; i < notifications.length; i++) {
      if (notifications[i]['id'] == id) {
        notifications[i]['isRead'] = true;
        _notifyListeners();
        break;
      }
    }
  }

  void deleteNotification(int id) {
    int index = notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
        final removed = notifications.removeAt(index);
        trash.insert(0, removed);
        _notifyListeners();
    }
  }
}
