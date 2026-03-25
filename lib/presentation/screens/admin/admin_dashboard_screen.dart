import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_event.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_state.dart';

import 'package:farumasi_patient_app/data/datasources/state_service.dart';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/manage_medicines_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/manage_pharmacies_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/admin_consultations_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/manage_health_tips_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/auth_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Determine the title based on the selected index
    String currentTitle = 'Admin Dashboard';
    if (_selectedIndex == 1) currentTitle = 'Manage Orders';
    if (_selectedIndex == 2) currentTitle = 'Manage Users';
    if (_selectedIndex == 3) currentTitle = 'Consultations';
    if (_selectedIndex == 4) currentTitle = 'Manage Health Tips';

    return AnimatedBuilder(
      animation: StateService(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(currentTitle),
            backgroundColor: Colors.green, // Brand Color
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              if (_selectedIndex == 0)
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                      child: const Text("ADMIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                  ),
                ),
            ],
          ),
          drawer: _buildDrawer(context),
          body: _buildBody(),
          backgroundColor: Colors.grey[50], // Lighter background
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Farumasi Admin", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text("admin@farumasi.rw"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.shield, size: 40, color: Colors.green),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green, Colors.teal]),
            ),
          ),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
          _buildDrawerItem(Icons.shopping_bag, 'Orders', 1),
          _buildDrawerItem(Icons.people, 'Users', 2),
          _buildDrawerItem(Icons.chat_bubble, 'Consultations', 3),
          _buildDrawerItem(Icons.lightbulb_outline, 'Health Tips', 4),
          const Divider(),
          _buildDrawerLink(Icons.medication, 'Medicines', () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageMedicinesScreen()));
          }),
          _buildDrawerLink(Icons.local_pharmacy, 'Pharmacies', () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const ManagePharmaciesScreen()));
          }),
          const Divider(),
          _buildDrawerLink(Icons.storefront, 'View as User', () {
             Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? Colors.green : Colors.grey[600]),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.green : Colors.grey[800],
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: _selectedIndex == index,
      selectedTileColor: Colors.green.withOpacity(0.1),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
  
  Widget _buildDrawerLink(IconData icon, String title, VoidCallback onTap) {
      return ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(title, style: TextStyle(color: Colors.grey[800])),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardOverview();
      case 1:
        return const ManageAppOrdersScreen();
      case 2:
        return const ManageAppUsersScreen();
      case 3:
        return const AdminConsultationsScreen();
      case 4:
        return const ManageHealthTipsScreen();
      default:
        return const DashboardOverview();
    }
  }
}


class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders').snapshots(),
      builder: (context, ordersSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, usersSnap) {
            final orders = ordersSnap.hasData ? ordersSnap.data!.docs : [];
            final users = usersSnap.hasData ? usersSnap.data!.docs : [];
            
            double totalRevenue = 0.0;
            int pendingOrders = 0;
            for (var doc in orders) {
              if (doc.data() is Map) {
                final d = doc.data() as Map<String, dynamic>;
                if (d['status'] == 'pendingReview') pendingOrders++;
                
                // Calculate revenue
                if (d['totalPrice'] != null) {
                   final price = d['totalPrice'];
                   if (price is num) {
                     totalRevenue += price;
                   } else if (price is String) {
                     totalRevenue += double.tryParse(price) ?? 0.0;
                   }
                }
              }
            }
            
            final totalMedicines = StateService().medicines.length; // placeholder
            final totalPharmacies = StateService().pharmacies.length;
            final totalUsers = users.length;
            final totalOrders = orders.length;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    childAspectRatio: 1.3,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStatCard("Total Revenue", "RWF ${totalRevenue.toStringAsFixed(0)}", Icons.attach_money, Colors.green),
                      _buildStatCard("Total Orders", "$totalOrders", Icons.shopping_cart, Colors.orange),
                      _buildStatCard("Total Users", "$totalUsers", Icons.people, Colors.blue),
                      _buildStatCard("Pharmacies", "$totalPharmacies", Icons.local_pharmacy, Colors.purple),
                      _buildStatCard("Medicines", "$totalMedicines", Icons.medication, Colors.teal),
                      _buildStatCard("Pending", "$pendingOrders", Icons.pending_actions, Colors.red),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("Recent Activity", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3, // Show last 3 activities mock
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: Icon(Icons.history, color: Colors.blue.shade800, size: 20),
                          ),
                          title: Text(index == 0 ? "New user registered" : index == 1 ? "Order #1234 completed" : "System backup successful"),
                          subtitle: Text("${DateTime.now().subtract(Duration(hours: index * 2)).toString().substring(0, 16)}"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Manage Users Screen ---
class ManageAppUsersScreen extends StatefulWidget {
  const ManageAppUsersScreen({super.key});

  @override
  State<ManageAppUsersScreen> createState() => _ManageAppUsersScreenState();
}

class _ManageAppUsersScreenState extends State<ManageAppUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Inherit from parent
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[900],
        onPressed: () {
          _showAddUserDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final users = snapshot.data!.docs;
                if (users.isEmpty) return const Center(child: Text("No users found."));
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final data = users[index].data() as Map<String, dynamic>;
                    final id = users[index].id;
                    final name = data['displayName'] ?? data['name'] ?? 'User';
                    final email = data['email'] ?? '';
                    final role = data['role'] ?? 'User';
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey[100],
                          child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold)
                          ),
                        ),
                        title: Text(name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(email, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getRoleColor(role).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(role, style: TextStyle(
                                fontSize: 10, 
                                fontWeight: FontWeight.bold,
                                color: _getRoleColor(role)
                              )),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text("Edit")])),
                            const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))])),
                          ],
                          onSelected: (value) {
                             if (value == 'delete') {
                                if (role == 'Admin') {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot delete Admin user.")));
                                  return;
                                }
                               FirebaseFirestore.instance.collection('users').doc(id).delete();
                             }
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin': return Colors.red;
      case 'Pharmacist': return Colors.green;
      case 'Rider': return Colors.orange;
      default: return Colors.blue;
    }
  }

  void _showAddUserDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String role = 'User';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: role,
              items: ['User', 'Pharmacist', 'Rider', 'Admin'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (val) => role = val!,
              decoration: const InputDecoration(labelText: "Role", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                FirebaseFirestore.instance.collection('users').add({
                  'uid': DateTime.now().millisecondsSinceEpoch.toString(),
                  'displayName': nameController.text,
                  'name': nameController.text,
                  'email': emailController.text,
                  'role': role,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              }
            }, 
            child: const Text("Add User"),
          ),
        ],
      ),
    );
  }
}

// --- Manage Orders Screen ---
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
        if (state is OrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        List<PrescriptionOrder> orders = [];
        if (state is OrdersLoaded) {
          orders = List<PrescriptionOrder>.from(state.orders);
        }

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text("No orders placed yet", style: TextStyle(color: Colors.grey[600], fontSize: 18)),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
             final order = orders[index];
             return Card(
               margin: const EdgeInsets.only(bottom: 12),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               elevation: 2,
               child: InkWell(
                 onTap: () {
                   _showOrderDetails(context, order);
                 },
                 borderRadius: BorderRadius.circular(12),
                 child: Padding(
                   padding: const EdgeInsets.all(12.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Order #${order.id.substring(0, 8)}...", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                           Container(
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                             decoration: BoxDecoration(
                               color: _getStatusColor(order.status).withOpacity(0.1),
                               borderRadius: BorderRadius.circular(12),
                               border: Border.all(color: _getStatusColor(order.status).withOpacity(0.5)),
                             ),
                             child: Text(
                               order.status.toString().split('.').last.toUpperCase(),
                               style: TextStyle(color: _getStatusColor(order.status), fontSize: 10, fontWeight: FontWeight.bold)
                             ),
                           ),
                         ],
                       ),
                       const Divider(),
                       Row(
                         children: [
                           const Icon(Icons.person, size: 16, color: Colors.grey),
                           const SizedBox(width: 4),
                           Text(order.patientName, style: TextStyle(color: Colors.grey[800])),
                           const Spacer(),
                           const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                           const SizedBox(width: 4),
                           Text(order.date.toString().substring(0, 10), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                         ],
                       ),
                       const SizedBox(height: 8),
                       Row(
                         children: [
                           const Icon(Icons.medication, size: 16, color: Colors.grey),
                           const SizedBox(width: 4),
                           Text("${order.items.length} Items", style: TextStyle(color: Colors.grey[800])),
                           const Spacer(),
                           Text("RWF ${order.totalPrice.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                         ],
                       ),
                     ],
                   ),
                 ),
               ),
             );
          },
        );
      }
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingReview: return Colors.orange;
      case OrderStatus.delivered: return Colors.green;
      case OrderStatus.cancelled: return Colors.red;
      case OrderStatus.pharmacyAccepted: return Colors.blue;
      default: return Colors.indigo;
    }
  }

  void _showOrderDetails(BuildContext context, PrescriptionOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Order Details #${order.id.substring(0,5)}"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow("Patient:", order.patientName),
              _detailRow("Location:", order.patientLocationName),
              _detailRow("Items:", "${order.items.length} medicines"),
              const Divider(),
              const Text("Update Status:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _statusChip(context, order, "Pending", OrderStatus.pendingReview),
                  _statusChip(context, order, "Processing", OrderStatus.findingPharmacy),
                  _statusChip(context, order, "In Transit", OrderStatus.outForDelivery),
                  _statusChip(context, order, "Delivered", OrderStatus.delivered, color: Colors.green),
                  _statusChip(context, order, "Cancel", OrderStatus.cancelled, color: Colors.red),
                ],
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 70, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context, PrescriptionOrder order, String label, OrderStatus status, {Color? color}) {
    return ChoiceChip(
      label: Text(label), 
      selected: order.status == status,
      onSelected: (selected) {
        if (selected) {
          context.read<OrderBloc>().add(UpdateOrderStatusEvent(order.id, status.name));
          Navigator.pop(context);
        }
      },
      selectedColor: color ?? Colors.blue,
      labelStyle: TextStyle(color: order.status == status ? Colors.white : Colors.black),
    );
  }
}