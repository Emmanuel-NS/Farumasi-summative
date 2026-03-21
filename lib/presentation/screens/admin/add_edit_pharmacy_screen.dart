import 'package:flutter/material.dart';
import 'package:farumasi_patient_app/data/datasources/state_service.dart';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/presentation/widgets/farumasi_logo_widget.dart';
import 'package:uuid/uuid.dart';

class AddEditPharmacyScreen extends StatefulWidget {
  final Pharmacy? pharmacy;

  const AddEditPharmacyScreen({super.key, this.pharmacy});

  @override
  State<AddEditPharmacyScreen> createState() => _AddEditPharmacyScreenState();
}

class _AddEditPharmacyScreenState extends State<AddEditPharmacyScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _locationNameController;
  late TextEditingController _provinceController;
  late TextEditingController _districtController;
  late TextEditingController _sectorController;
  late TextEditingController _cellController;
  late TextEditingController _imageUrlController;

  bool _isOpen = true;

  @override
  void initState() {
    super.initState();
    final p = widget.pharmacy;
    _nameController = TextEditingController(text: p?.name ?? '');
    _locationNameController = TextEditingController(text: p?.locationName ?? '');
    _provinceController = TextEditingController(text: p?.province ?? 'Kigali City');
    _districtController = TextEditingController(text: p?.district ?? '');
    _sectorController = TextEditingController(text: p?.sector ?? '');
    _cellController = TextEditingController(text: p?.cell ?? '');
    _imageUrlController = TextEditingController(text: p?.imageUrl ?? 'https://placehold.co/600x400/png');
    _isOpen = p?.isOpen ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationNameController.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _sectorController.dispose();
    _cellController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newPharmacy = Pharmacy(
        id: widget.pharmacy?.id ?? const Uuid().v4(),
        name: _nameController.text,
        locationName: _locationNameController.text,
        coordinates: widget.pharmacy?.coordinates ?? [-1.9706, 30.1044], // Default Kigali
        province: _provinceController.text,
        district: _districtController.text,
        sector: _sectorController.text,
        cell: _cellController.text,
        imageUrl: _imageUrlController.text,
        isOpen: _isOpen,
        supportedInsurances: widget.pharmacy?.supportedInsurances ?? ['RSSB', 'Radiant'],
      );

      if (widget.pharmacy == null) {
        StateService().addPharmacy(newPharmacy);
      } else {
        StateService().updatePharmacy(newPharmacy);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pharmacy == null ? 'Add Pharmacy' : 'Edit Pharmacy'),
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
              Center(
                child: Column(
                  children: [
                    const FarumasiLogo(size: 80, color: Colors.green),
                    const SizedBox(height: 16),
                    Text(
                      widget.pharmacy == null ? "New Pharmacy" : "Edit Pharmacy",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 4),
                    const Text("Fill in the branch details", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              _buildSectionTitle("General Info"),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Pharmacy Name',
                icon: Icons.local_pharmacy,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageUrlController,
                label: 'Image URL',
                icon: Icons.image,
              ),

              const SizedBox(height: 32),
              _buildSectionTitle("Location Details"),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _locationNameController,
                label: 'Location / Address',
                icon: Icons.location_on,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(
                     child: _buildTextField(
                       controller: _provinceController, 
                       label: 'Province',
                       icon: Icons.map
                      )
                    ),
                   const SizedBox(width: 12),
                   Expanded(
                     child: _buildTextField(
                       controller: _districtController, 
                       label: 'District',
                       icon: Icons.holiday_village
                      )
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(
                     child: _buildTextField(
                       controller: _sectorController, 
                       label: 'Sector',
                       icon: Icons.domain
                      )
                    ),
                   const SizedBox(width: 12),
                   Expanded(
                     child: _buildTextField(
                       controller: _cellController, 
                       label: 'Cell',
                       icon: Icons.house
                      )
                    ),
                ],
              ),

              const SizedBox(height: 32),
              _buildSectionTitle("Status"),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Is Open for Business?'),
                subtitle: Text(_isOpen ? "Pharmacy is listed as OPEN" : "Pharmacy is listed as CLOSED"),
                value: _isOpen,
                activeColor: Colors.green,
                onChanged: (val) => setState(() => _isOpen = val),
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),

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
                  widget.pharmacy == null ? 'CREATE PHARMACY' : 'UPDATE PHARMACY',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
              const SizedBox(height: 20),
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
}
