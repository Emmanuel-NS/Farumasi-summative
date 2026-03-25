import os

content = """import 'package:flutter/material.dart';
import 'package:farumasi_patient_app/data/datasources/state_service.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/manage_medicines_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/manage_pharmacies_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/admin_consultations_screen.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/manage_health_tips_screen.dart';
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
          body: Center(child: Text("Content for $currentTitle")),
          backgroundColor: Colors.grey[50],
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
      return const Drawer(); 
  }
}
"""

with open('lib/presentation/screens/admin/admin_dashboard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated admin_dashboard_screen.dart")
