import os

content = """import 'package:flutter/material.dart';
import 'package:farumasi_patient_app/data/datasources/state_service.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/manage_medicines_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/manage_pharmacies_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/admin_consultations_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/manage_health_tips_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/manage_app_users_screen.dart'; 
import 'package:farumasi_patient_app/presentation/screens/admin/manage_orders_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/home_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/auth_screen.dart';
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
    String currentTitle = 'Admin Dashboard';
    Widget bodyContent = _buildOverview();

    if (_selectedIndex == 1) {
      currentTitle = 'Manage Orders';
      bodyContent = const ManageOrdersScreen();
    }
    if (_selectedIndex == 2) {
      currentTitle = 'Manage Users';
      bodyContent = const ManageAppUsersScreen();
    }
    if (_selectedIndex == 3) {
      currentTitle = 'Consultations';
      // TODO: Implement Consultation Integration
      bodyContent = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_camera_front_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("Consultation Management Module"),
            Text("Coming Soon", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    if (_selectedIndex == 4) {
      currentTitle = 'Manage Health Tips';
      // TODO: Implement Health Tips Integration
      bodyContent = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.health_and_safety_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("Health Tips Management Module"),
            Text("Coming Soon", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: StateService(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(currentTitle),
            backgroundColor: Colors.green,
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
          body: bodyContent,
          backgroundColor: Colors.grey[50],
        );
      },
    );
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard Overview",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Stats Cards
          Row(
            children: [
              _buildStatCard("Total Orders", "1,245", Colors.blue, Icons.shopping_cart),
              _buildStatCard("Active Users", "8,320", Colors.purple, Icons.people),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard("Revenue", "UGX 45M", Colors.green, Icons.attach_money),
              _buildStatCard("Pending", "45", Colors.orange, Icons.pending_actions),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Recent Activity",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (c, i) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: const Icon(Icons.notifications_outlined, color: Colors.blue),
                  ),
                  title: Text("Order #${12340 + index} placed"),
                  subtitle: const Text("2 mins ago"),
                  trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: const Text(
              "Admin User",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: const Text("admin@farumasi.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.shield, color: Colors.green, size: 36),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(0, Icons.dashboard_outlined, "Overview"),
                _buildDrawerItem(1, Icons.shopping_basket_outlined, "Manage Orders"),
                _buildDrawerItem(2, Icons.people_outline, "Manage Users"),
                _buildDrawerItem(3, Icons.video_camera_front_outlined, "Consultations"),
                _buildDrawerItem(4, Icons.health_and_safety_outlined, "Health Tips"),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings_outlined, color: Colors.grey),
                  title: const Text("Admin Settings"),
                  onTap: () {
                    // Navigate to settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text("Logout"),
                  onTap: () {
                    context.read<AuthBloc>().add(UnAuthenticateEvent());
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Farumasi Admin v1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    bool isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.green : Colors.grey[700]),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}
"""

with open('lib/presentation/screens/admin/admin_dashboard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated admin_dashboard_screen.dart with Orders Integration")
