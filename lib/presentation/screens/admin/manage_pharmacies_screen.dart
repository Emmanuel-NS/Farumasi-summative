import 'package:flutter/material.dart';
import 'package:farumasi_patient_app/data/datasources/state_service.dart';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/add_edit_pharmacy_screen.dart';

class ManagePharmaciesScreen extends StatefulWidget {
  const ManagePharmaciesScreen({super.key});

  @override
  State<ManagePharmaciesScreen> createState() => _ManagePharmaciesScreenState();
}

class _ManagePharmaciesScreenState extends State<ManagePharmaciesScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService(),
      builder: (context, child) {
        final pharmacies = StateService().pharmacies;
        return Scaffold(
          appBar: AppBar(
             title: const Text('Manage Pharmacies'),
             backgroundColor: Colors.green,
             foregroundColor: Colors.white,
          ),
          body: pharmacies.isEmpty
              ? const Center(child: Text('No pharmacies found'))
              : ListView.builder(
                  itemCount: pharmacies.length,
                  itemBuilder: (context, index) {
                    final pharmacy = pharmacies[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(pharmacy.imageUrl),
                        onBackgroundImageError: (_, __) => const Icon(Icons.error),
                      ),
                      title: Text(pharmacy.name),
                      subtitle: Text(pharmacy.locationName),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddEditPharmacyScreen(pharmacy: pharmacy),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(context, pharmacy);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddEditPharmacyScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Pharmacy pharmacy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pharmacy'),
        content: Text('Are you sure you want to delete ${pharmacy.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              StateService().deletePharmacy(pharmacy.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
