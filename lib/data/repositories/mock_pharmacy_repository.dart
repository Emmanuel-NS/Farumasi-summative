import 'package:farumasi_patient_app/data/dummy_data.dart';
import 'package:farumasi_patient_app/data/models/pharmacy.dart';
import 'package:farumasi_patient_app/data/repositories/pharmacy_repository_impl.dart';

class MockPharmacyRepository implements PharmacyRepository {
  List<Pharmacy> _pharmacies = List.from(dummyPharmacies);

  @override
  Future<List<Pharmacy>> getPharmacies() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _pharmacies;
  }

  @override
  Stream<List<Pharmacy>> getPharmaciesStream() {
    return Stream.value(_pharmacies);
  }

  @override
  Future<void> addPharmacy(Pharmacy pharmacy) async {
    _pharmacies.add(pharmacy);
  }

  @override
  Future<void> updatePharmacy(Pharmacy pharmacy) async {
    final index = _pharmacies.indexWhere((p) => p.id == pharmacy.id);
    if (index != -1) {
      _pharmacies[index] = pharmacy;
    }
  }

  @override
  Future<void> deletePharmacy(String id) async {
    _pharmacies.removeWhere((p) => p.id == id);
  }
}
