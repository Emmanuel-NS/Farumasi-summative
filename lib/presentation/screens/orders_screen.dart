import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_event.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_state.dart';
import 'package:farumasi_patient_app/data/models/prescription_order.dart';
import 'package:farumasi_patient_app/data/models/order_status.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:farumasi_patient_app/presentation/screens/order_tracking_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/home_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState.status == AuthStatus.authenticated) {
       context.read<OrderBloc>().add(LoadUserOrders(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState.status != AuthStatus.authenticated) {
           return const Center(child: Text('Please log in to view orders.'));
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                tabs: [
                  Tab(text: 'Active Orders'),
                  Tab(text: 'Past Orders'),
                ],
              ),
            ),
            body: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
              if (state is OrderFailure) {
                return Center(child: Text('Error: ${state.message}'));
              }
              
              if (state is OrdersLoaded) {
                 final orders = state.orders.cast<PrescriptionOrder>();
                 
                 final activeOrders = orders.where((o) => 
                      o.status != OrderStatus.delivered && 
                      o.status != OrderStatus.cancelled).toList();

                   final pastOrders = orders.where((o) => 
                      o.status == OrderStatus.delivered || 
                      o.status == OrderStatus.cancelled).toList();

                   return TabBarView(
                     children: [
                       _buildOrderList(activeOrders, isActive: true),
                       _buildOrderList(pastOrders, isActive: false),
                     ],
                   );
                }
                
                return const Center(child: Text('Initialize orders...'));
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        );
      }
    );
  }

  Widget _buildOrderList(List<PrescriptionOrder> orders, {required bool isActive}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? Icons.local_shipping_outlined : Icons.history, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(isActive ? 'No active orders' : 'No past orders', style: const TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final isTrackable = order.status == OrderStatus.driverAssigned || order.status == OrderStatus.outForDelivery;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order #${order.id.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(DateFormat('MMM dd, yyyy').format(order.date), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      order.status == OrderStatus.delivered ? Icons.check_circle : Icons.schedule,
                      size: 16,
                      color: order.status == OrderStatus.delivered ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatStatus(order.status),
                      style: TextStyle(
                        color: order.status == OrderStatus.delivered ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Total: KSH ${order.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                const Divider(),
                Text('Delivery to: ${order.patientLocationName}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                
                if (isActive && isTrackable) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderTrackingScreen(orderId: order.id),
                          ),
                        );
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text('Track Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingReview: return 'Pending Review';
      case OrderStatus.findingPharmacy: return 'Finding Pharmacy';
      case OrderStatus.pharmacyAccepted: return 'Pharmacy Accepted';
      case OrderStatus.paymentPending: return 'Payment Pending';
      case OrderStatus.readyForPickup: return 'Ready for Pickup';
      case OrderStatus.driverAssigned: return 'Driver Assigned';
      case OrderStatus.outForDelivery: return 'Out for Delivery';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }
}
