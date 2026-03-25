import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/pharmacy/pharmacy_bloc.dart';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/presentation/screens/admin/add_edit_pharmacy_screen.dart';

class ManagePharmaciesScreen extends StatefulWidget {
  const ManagePharmaciesScreen({super.key});

  @override
  State<ManagePharmaciesScreen> createState() => _ManagePharmaciesScreenState();
}

class _ManagePharmaciesScreenState extends State<ManagePharmaciesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PharmacyBloc>().add(LoadPharmacies());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PharmacyBloc, PharmacyState>(
      builder: (context, state) {
        List<Pharmacy> pharmacies = [];
        if (state is PharmacyLoaded) {
          pharmacies = state.pharmacies;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Manage Pharmacies'),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          body: state is PharmacyLoading
              ? const Center(child: CircularProgressIndicator())
              : (pharmacies.isEmpty
                    ? const Center(child: Text('No pharmacies found'))
                    : ListView.builder(
                        itemCount: pharmacies.length,
                        itemBuilder: (context, index) {
                          final pharmacy = pharmacies[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(pharmacy.imageUrl),
                              onBackgroundImageError: (_, __) =>
                                  const Icon(Icons.error),
                            ),
                            title: Text(pharmacy.name),
                            subtitle: Text(pharmacy.locationName),
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
                                            AddEditPharmacyScreen(
                                              pharmacy: pharmacy,
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
                                    _confirmDelete(context, pharmacy);
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
                  builder: (context) => const AddEditPharmacyScreen(),
                ),
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
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Pharmacy'),
        content: Text('Are you sure you want to delete ${pharmacy.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<PharmacyBloc>().add(DeletePharmacy(pharmacy.id));
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
