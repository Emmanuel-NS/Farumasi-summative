import os

from textwrap import dedent

with open('lib/presentation/screens/admin/admin_dashboard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(r'''import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/domain/repositories/auth_repository.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_state.dart';
import 'package:farumasi_patient_app/presentation/screens/login_screen.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_event.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_state.dart';
import 'package:farumasi_patient_app/data/models/prescription_order.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                },
              )
            ],
            bottom: const TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 4,
              tabs: [
                Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
                Tab(icon: Icon(Icons.people), text: 'Users'),
                Tab(icon: Icon(Icons.shopping_cart), text: 'Orders'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              OverviewTab(),
              ManageAppUsersScreen(),
              ManageAppOrdersScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});
  
  @override
  Widget build(BuildContext context) {
     return const Center(child: Text('Admin Overview', style: TextStyle(fontSize: 24, color: Colors.grey)));
  }
}

class ManageAppUsersScreen extends StatefulWidget {
  const ManageAppUsersScreen({super.key});

  @override
  State<ManageAppUsersScreen> createState() => _ManageAppUsersScreenState();
}

class _ManageAppUsersScreenState extends State<ManageAppUsersScreen> {
  late Future<List<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _usersFuture = context.read<AuthRepository>().getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
             return Center(child: Text('Error loading users: '));
          }

          final users = snapshot.data ?? [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search Users...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: users.isEmpty
                ? const Center(child: Text('No users found.'))
                : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final name = user['displayName'] ?? 'Unknown User';
                    final role = user['role'] ?? 'patient';
                    final email = user['email'] ?? 'No Email';
                    final phone = user['phoneNumber'] ?? 'No Phone';
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text(' • '),
                        trailing: role == 'Admin' ? const Icon(Icons.admin_panel_settings, color: Colors.blue) : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
    );
  }
}

class ManageAppOrdersScreen extends StatefulWidget {
  const ManageAppOrdersScreen({super.key});

  @override
  State<ManageAppOrdersScreen> createState() => _ManageAppOrdersScreenState();
}

class _ManageAppOrdersScreenState extends State<ManageAppOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadAllOrders());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrdersLoaded) {
          final orders = state.orders;

          return orders.isEmpty
            ? const Center(child: Text('No orders created yet.', style: TextStyle(color: Colors.grey, fontSize: 16)))
            : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Text('Order #', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Total: KSH '),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Customer Details:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('Name: '),
                            Text('Phone: '),
                            Text('Address: '),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              children: OrderStatus.values.map((status) {
                                final isCurrent = order.status == status;
                                return ChoiceChip(
                                  label: Text(status.toString().split('.').last),
                                  selected: isCurrent,
                                  onSelected: isCurrent ? null : (selected) {
                                    if(selected) {
                                      context.read<OrderBloc>().add(UpdateOrderStatusEvent(order.id, status));
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order marked as ')));
                                    }
                                  },
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
        } else if (state is OrderError) {
          return Center(child: Text('Error loading orders: '));
        }
        return const Center(child: Text('Initialize orders...'));
      },
    );
  }
}
''')
