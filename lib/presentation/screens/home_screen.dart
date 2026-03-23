import 'package:flutter/material.dart';
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
      debugPrint("Location fetched successfully: ${StateService().userCoordinates}");
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
      floatingActionButton: ScaleTransition(
            scale: _hideBottomBarController,
            child: SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                backgroundColor: isLoggedIn ? Colors.white : Colors.grey[300],
                elevation: 4,
                shape: const CircleBorder(), 
                onPressed: () {
                  if (!isLoggedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Please log in to upload a prescription."),
                        action: SnackBarAction(
                          label: "Login",
                          onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
                          },
                        ),
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrescriptionUploadScreen(),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.document_scanner_outlined,
                      color: isLoggedIn ? Colors.green : Colors.grey,
                      size: 28,
                    ),
                    Text(
                      "Upload Rx",
                      style: TextStyle(
                        color: isLoggedIn ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizeTransition(
        sizeFactor: _hideBottomBarController,
        axisAlignment: -1.0,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
            BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Tips'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Consult'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Orders'),
          ],
        ),
      ),
    ),
    );
  }
}
