import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/add_edit_medicine_screen.dart';

class ManageMedicinesScreen extends StatefulWidget {
  const ManageMedicinesScreen({super.key});

  @override
  State<ManageMedicinesScreen> createState() => _ManageMedicinesScreenState();
}

class _ManageMedicinesScreenState extends State<ManageMedicinesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MedicineBloc>().add(const LoadMedicines());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineBloc, MedicineState>(
      builder: (context, state) {
        List<Medicine> medicines = [];
        if (state is MedicineLoaded) {
          medicines = state.medicines;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Manage Medicines'),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          body: state is MedicineLoading
              ? const Center(child: CircularProgressIndicator())
              : (medicines.isEmpty
                    ? const Center(child: Text('No medicines found'))
                    : ListView.builder(
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          final medicine = medicines[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(medicine.imageUrl),
                              onBackgroundImageError: (_, __) =>
                                  const Icon(Icons.error),
                            ),
                            title: Text(medicine.name),
                            subtitle: Text('${medicine.price} RWF'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddEditMedicineScreen(
                                              medicine: medicine,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _confirmDelete(context, medicine);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddEditMedicineScreen(),
                ),
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
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text('Are you sure you want to delete ${medicine.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<MedicineBloc>().add(DeleteMedicine(medicine.id));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
