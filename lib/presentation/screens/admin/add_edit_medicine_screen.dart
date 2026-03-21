import 'package:flutter/material.dart';
import 'package:farumasi_patient_app/data/datasources/state_service.dart';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/presentation/widgets/farumasi_logo_widget.dart';
import 'package:uuid/uuid.dart';

class AddEditMedicineScreen extends StatefulWidget {
  final Medicine? medicine;

  const AddEditMedicineScreen({super.key, this.medicine});

  @override
  State<AddEditMedicineScreen> createState() => _AddEditMedicineScreenState();
}

class _AddEditMedicineScreenState extends State<AddEditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _manufacturerController;
  late TextEditingController _dosageController;
  late TextEditingController _sideEffectsController;
  late List<String> _selectedPharmacyIds; // Track selected pharmacies
  
  // Multi-Category Support
  final List<String> _allCategories = [
    'Pain Relief',
    'Antibiotics',
    'Vitamins',
    'Cold & Flu',
    'Skincare',
    'Sexual Health',
    'Mobility Aids',
    'Mother & Baby',
    'Devices',
    'First Aid',
    'Chronic Care',
    'Nutrition',
    'Herbal Medicines'
  ];
  
  List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    final m = widget.medicine;
    _nameController = TextEditingController(text: m?.name ?? '');
    _descriptionController = TextEditingController(text: m?.description ?? '');
    _priceController = TextEditingController(text: m?.price.toString() ?? '');
    _imageUrlController = TextEditingController(text: m?.imageUrl ?? 'https://placehold.co/600x400/png');
    _manufacturerController = TextEditingController(text: m?.manufacturer ?? '');
    _dosageController = TextEditingController(text: m?.dosage ?? '');
    _sideEffectsController = TextEditingController(text: m?.sideEffects ?? '');
    _selectedPharmacyIds = List.from(m?.availableAtPharmacyIds ?? []);
    
    // Initialize selected categories
    if (m != null) {
      if (m.category.isNotEmpty) _selectedCategories.add(m.category);
      _selectedCategories.addAll(m.additionalCategories);
      _selectedCategories = _selectedCategories.toSet().toList(); // Remove duplicates
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _manufacturerController.dispose();
    _dosageController.dispose();
    _sideEffectsController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategories.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one category')),
        );
        return;
      }

      final double? price = double.tryParse(_priceController.text);
      if (price == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid price')),
        );
        return;
      }

      // First category is primary, rest are additional
      final primaryCategory = _selectedCategories.first;
      final additionalCats = _selectedCategories.length > 1 
          ? _selectedCategories.sublist(1) 
          : <String>[];

      final newMedicine = Medicine(
        id: widget.medicine?.id ?? const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: price,
        category: primaryCategory,
        additionalCategories: additionalCats,
        imageUrl: _imageUrlController.text,
        manufacturer: _manufacturerController.text,
        dosage: _dosageController.text,
        sideEffects: _sideEffectsController.text,
        // Preserve other fields
        rating: widget.medicine?.rating ?? 4.5,
        isPopular: widget.medicine?.isPopular ?? false,
        requiresPrescription: widget.medicine?.requiresPrescription ?? false,
        expiryDate: widget.medicine?.expiryDate,
        subCategory: widget.medicine?.subCategory,
        additionalSubCategories: widget.medicine?.additionalSubCategories ?? [],
        doseMorning: widget.medicine?.doseMorning,
        doseAfternoon: widget.medicine?.doseAfternoon,
        doseEvening: widget.medicine?.doseEvening,
        doseTimeInterval: widget.medicine?.doseTimeInterval,
        availableAtPharmacyIds: _selectedPharmacyIds,
      );

      if (widget.medicine == null) {
        StateService().addMedicine(newMedicine);
      } else {
        StateService().updateMedicine(newMedicine);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicine == null ? 'Add Medicine' : 'Edit Medicine'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Brand
              Center(
                child: Column(
                  children: [
                    const FarumasiLogo(size: 80, color: Colors.green),
                    const SizedBox(height: 16),
                    Text(
                      widget.medicine == null ? "New Product" : "Edit Product",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    const Text("Fill in the details below", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle("Basic Info"),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Medicine Name',
                icon: Icons.medication,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: 'Price (RWF)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              
              const SizedBox(height: 32),
              _buildSectionTitle("Categories"),
              const SizedBox(height: 8),
              const Text("Select one or more categories:", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _allCategories.map((category) {
                    final isSelected = _selectedCategories.contains(category);
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: Colors.green.shade100,
                      checkmarkColor: Colors.green,
                      backgroundColor: Colors.grey.shade50,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.green.shade900 : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedCategories.add(category);
                          } else {
                            _selectedCategories.remove(category);
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.green : Colors.grey.shade300,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionTitle("Medical Info"),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _dosageController,
                label: 'Dosage / Instructions',
                icon: Icons.access_time,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _sideEffectsController,
                label: 'Side Effects',
                icon: Icons.warning_amber,
              ),
               const SizedBox(height: 16),
              _buildTextField(
                controller: _manufacturerController,
                label: 'Manufacturer',
                icon: Icons.factory,
              ),

              const SizedBox(height: 32),
              _buildSectionTitle("Display"),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageUrlController,
                label: 'Image URL',
                icon: Icons.image,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 32),
              _buildSectionTitle("Inventory & Location"),
              const SizedBox(height: 8),
              const Text("Select pharmacies where this product is available:", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              _buildPharmacySelector(),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: Text(
                  widget.medicine == null ? 'CREATE PRODUCT' : 'UPDATE PRODUCT',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 4, height: 24, color: Colors.green, margin: const EdgeInsets.only(right: 8)),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.green, width: 2)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildPharmacySelector() {
    final pharmacies = StateService().pharmacies;
    if (pharmacies.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
        child: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(child: Text("No pharmacies available. Add one via 'Manage Pharmacies' first.")),
          ],
        ),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: pharmacies.asMap().entries.map((entry) {
          final p = entry.value;
          final isSelected = _selectedPharmacyIds.contains(p.id);
          return Column(
            children: [
              CheckboxListTile(
                title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(p.locationName),
                value: isSelected,
                activeColor: Colors.green,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                secondary: CircleAvatar(
                  backgroundColor: Colors.green.shade50,
                  backgroundImage: p.imageUrl.isNotEmpty ? NetworkImage(p.imageUrl) : null,
                  onBackgroundImageError: (_,__) {},
                  child: p.imageUrl.isEmpty ? const Icon(Icons.store, color: Colors.green) : null,
                ),
                onChanged: (val) {
                   setState(() {
                     if (val == true) {
                       _selectedPharmacyIds.add(p.id);
                     } else {
                       _selectedPharmacyIds.remove(p.id);
                     }
                   });
                }
              ),
              if (entry.key != pharmacies.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
