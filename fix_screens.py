import os

with open('lib/presentation/screens/orders_screen.dart', 'w', encoding='utf-8') as f:
    f.write(r'''import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_event.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_state.dart';
import 'package:farumasi_patient_app/data/models/prescription_order.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_state.dart';

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
    if (authState is AuthAuthenticated) {
       context.read<OrderBloc>().add(LoadUserOrders(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
           return const Center(child: Text('Please log in to view orders.'));
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is OrderError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              
              if (state is OrdersLoaded) {
                 final orders = state.orders;
                 
                 if (orders.isEmpty) {
                   return Center(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.history, size: 80, color: Colors.grey[400]),
                         const SizedBox(height: 16),
                         const Text('No orders yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                       ],
                     ),
                   );
                 }

                 return ListView.builder(
                   padding: const EdgeInsets.all(16.0),
                   itemCount: orders.length,
                   itemBuilder: (context, index) {
                     final order = orders[index];
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
                                 Text('Order #${order.id.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                 Text(DateFormat('MMM dd, yyyy').format(order.date), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                               ],
                             ),
                             const SizedBox(height: 8),
                             Text('Status: ${order.status.toString().split(".").last.toUpperCase()}', 
                               style: TextStyle(color: order.status == OrderStatus.delivered ? Colors.green : Colors.orange, fontWeight: FontWeight.bold)),
                             const SizedBox(height: 8),
                             Text('Total: KSH ${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                             const SizedBox(height: 12),
                             const Divider(),
                             Text('Delivery Address: ${order.deliveryAddress}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                           ],
                         ),
                       ),
                     );
                   },
                 );
              }
              
              return const Center(child: Text('Initialize orders...'));
            },
          ),
        );
      }
    );
  }
}
''')

with open('lib/presentation/screens/profile_screen.dart', 'w', encoding='utf-8') as f:
    f.write(r'''import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_event.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_state.dart';
import 'package:farumasi_patient_app/domain/repositories/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      final profile = await context.read<AuthRepository>().getUserProfile(user.id);
      if (profile != null && mounted) {
        setState(() {
          _nameController.text = profile['displayName'] ?? '';
          _emailController.text = profile['email'] ?? '';
          _phoneController.text = profile['phoneNumber'] ?? '';
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated) {
          final userId = authState.user.id;
          await context.read<AuthRepository>().updateProfile(userId, {
            'displayName': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phoneNumber': _phoneController.text.trim(),
          });
          
          if (mounted) {
            setState(() => _isEditing = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Center(child: Text('Please log in.'));
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.close : Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                    if (!_isEditing) _loadUserProfile(); // Reset changes
                  });
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Icon(Icons.person, size: 60, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField('Full Name', _nameController, Icons.person, _isEditing),
                  const SizedBox(height: 16),
                  _buildTextField('Email Address', _emailController, Icons.email, _isEditing, isEmail: true),
                  const SizedBox(height: 16),
                  _buildTextField('Phone Number', _phoneController, Icons.phone, _isEditing),
                  
                  const SizedBox(height: 32),
                  if (_isEditing)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isLoading ? null : _updateProfile,
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save Changes', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  
                  if (!_isEditing)
                    TextButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text('Sign Out', style: TextStyle(color: Colors.red, fontSize: 16)),
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool enabled, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: enabled ? Colors.blueAccent : Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: enabled ? Colors.white : Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${label.toLowerCase()}';
        }
        return null;
      },
    );
  }
}
''')
