import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:farumasi_patient_app/presentation/screens/health_tips_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/medicine_store_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/user_consultation_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/orders_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/auth_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/prescription_upload_screen.dart';
import 'package:farumasi_patient_app/data/datasources/state_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _hideBottomBarController;
  bool _isBottomBarVisible = true;

  final List<Widget> _pages = [
    const MedicineStoreScreen(),
    const HealthTipsScreen(),
    const PrescriptionUploadScreen(), // Upload Rx tab
    const UserConsultationScreen(),
    const OrdersScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _hideBottomBarController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
    );
    Future.delayed(Duration.zero, () {
      _autoPickLocation();
    });
  }

  @override
  void dispose() {
    _hideBottomBarController.dispose();
    super.dispose();
  }

  Future<void> _autoPickLocation() async {
    try {
      await StateService().fetchRealLocation();
      debugPrint(
        "Location fetched successfully: ${StateService().userCoordinates}",
      );
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final isLoggedIn = authState.status == AuthStatus.authenticated;

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        setState(() {
          _currentIndex = 0;
        });
      },
      child: Scaffold(
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.reverse) {
              if (_isBottomBarVisible) {
                _hideBottomBarController.reverse();
                setState(() => _isBottomBarVisible = false);
              }
            } else if (notification.direction == ScrollDirection.forward) {
              if (!_isBottomBarVisible) {
                _hideBottomBarController.forward();
                setState(() => _isBottomBarVisible = true);
              }
            }
            return false;
          },
          child: _pages[_currentIndex],
        ),
                bottomNavigationBar: SizeTransition(
          sizeFactor: _hideBottomBarController,
          axisAlignment: -1.0,
          child: ListenableBuilder(
            listenable: StateService(),
            builder: (context, _) {
              final isLoggedIn = StateService().isLoggedIn;
              return CurvedNavigationBar(
                index: _currentIndex,
                height: 60.0,
                color: Colors.green,
                buttonBackgroundColor: Colors.white,
                backgroundColor: Colors.transparent, // Figma styling: curved bar over content
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
                items: <Widget>[
                  Icon(Icons.home, size: 30, color: _currentIndex == 0 ? Colors.green : Colors.white),
                  Icon(Icons.health_and_safety, size: 30, color: _currentIndex == 1 ? Colors.green : Colors.white),
                  Icon(Icons.document_scanner_outlined, size: 30, color: _currentIndex == 2 ? Colors.green : Colors.white), // Upload Rx
                  Icon(Icons.chat_bubble_outline, size: 30, color: _currentIndex == 3 ? Colors.green : Colors.white),
                  Icon(Icons.history, size: 30, color: _currentIndex == 4 ? Colors.green : Colors.white),
                ],
                onTap: (index) {
                  // Index 2 is Upload Rx, 3 is Consult/Chat, 4 is Orders
                  bool restricted = (index == 2 || index == 3 || index == 4) && !isLoggedIn;
                  if (restricted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Please log in to access this feature."),
                        action: SnackBarAction(
                          label: "Login",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AuthScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                    setState(() {
                      _currentIndex = 0;
                    });
                    return;
                  }
                  setState(() {
                    _currentIndex = index;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
