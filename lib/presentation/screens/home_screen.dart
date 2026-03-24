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
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_state.dart';
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
        child: ListenableBuilder(
          listenable: StateService(),
          builder: (context, _) {
            return BottomAppBar(
              color: Colors.green,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.store, 'Home', 0),
                    _buildNavItem(Icons.health_and_safety, 'Health', 1),
                    const SizedBox(width: 48), // Gap for FAB
                    _buildNavItem(Icons.chat_bubble_outline, 'Consult', 2),
                    _buildNavItem(Icons.history, 'Orders', 3),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    bool isCart = false,
  }) {
    final isLoggedIn = StateService().isLoggedIn;
    // Index 2 is Consult/Chat, Index 3 is Orders
    final isRestricted = (index == 2 || index == 3) && !isLoggedIn;

    final isSelected = _currentIndex == index;
    // If restricted, show as semi-transparent/greyed out
    final color = isRestricted
        ? Colors.green.shade800
        : (isSelected ? Colors.white : Colors.green.shade100);

    Widget iconWidget = Icon(icon, color: color, size: 28);

    if (isCart) {
      iconWidget = BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          int itemCount = 0;
          if (state is CartLoaded) {
            itemCount = state.cartItems.length;
          }
          if (itemCount > 0) {
            return Badge(
              label: Text(itemCount.toString()),
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(icon, color: color, size: 28),
            );
          }
          return Icon(icon, color: color, size: 28);
        },
      );
    }

    return GestureDetector(
      onTap: () {
        if (isRestricted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Please log in to access \.'),
               action: SnackBarAction(
                 label: 'Login',
                 onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                 },
               ),
             ),
           );
           return;
        }
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}