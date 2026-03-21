import 'package:flutter/material.dart';
import 'package:farumasi_patient_app/data/datasources/state_service.dart';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/add_edit_medicine_screen.dart';

class ManageMedicinesScreen extends StatefulWidget {
  const ManageMedicinesScreen({super.key});

  @override
  State<ManageMedicinesScreen> createState() => _ManageMedicinesScreenState();
}

class _ManageMedicinesScreenState extends State<ManageMedicinesScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StateService(),
      builder: (context, child) {
        final medicines = StateService().medicines;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Manage Medicines'),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          body: medicines.isEmpty
              ? const Center(child: Text('No medicines found'))
              : ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = medicines[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(medicine.imageUrl),
                        onBackgroundImageError: (_, __) => const Icon(Icons.error),
                      ),
                      title: Text(medicine.name),
                      subtitle: Text('${medicine.price} RWF'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddEditMedicineScreen(medicine: medicine),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(context, medicine);
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
                MaterialPageRoute(builder: (context) => const AddEditMedicineScreen()),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text('Are you sure you want to delete ${medicine.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              StateService().deleteMedicine(medicine.id);
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
