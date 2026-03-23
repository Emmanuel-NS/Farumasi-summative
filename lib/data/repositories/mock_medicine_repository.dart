import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/domain/repositories/medicine_repository.dart';
import '../dummy_data.dart';

class MockMedicineRepository implements MedicineRepository {
  final Duration _delay = const Duration(milliseconds: 800);

  @override
  Future<List<Medicine>> getMedicines() async {
    await Future.delayed(_delay);
    return dummyMedicines;
  }

  @override
  Future<Medicine?> getMedicineById(String id) async {
    await Future.delayed(_delay);
    try {
      return dummyMedicines.firstWhere((medicine) => medicine.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Medicine>> searchMedicines(String query) async {
    await Future.delayed(_delay);
    if (query.isEmpty) return dummyMedicines;
    
    final lowerQuery = query.toLowerCase();
    return dummyMedicines.where((medicine) {
      final nameMatches = medicine.name.toLowerCase().contains(lowerQuery);
      final categoryMatches = medicine.category.toLowerCase().contains(lowerQuery);
      final keywordMatches = medicine.keywords.any((k) => k.toLowerCase().contains(lowerQuery));
      return nameMatches || categoryMatches || keywordMatches;
    }).toList();
  }

  @override
  Future<List<Medicine>> getMedicinesByCategory(String category) async {
    await Future.delayed(_delay);
    if (category == 'All' || category.isEmpty) return dummyMedicines;
    return dummyMedicines.where((m) => m.category == category).toList();
  }

  @override
  Future<List<Medicine>> getPopularMedicines() async {
    await Future.delayed(_delay);
    return dummyMedicines.where((m) => m.isPopular).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(_delay);
    final categories = dummyMedicines.map((m) => m.category).toSet().toList();
    if (!categories.contains('All')) {
      categories.insert(0, 'All');
    }
    return categories;
  }
}
