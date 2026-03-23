import 'package:farumasi_patient_app/data/models/models.dart';

abstract class MedicineRepository {
  Future<List<Medicine>> getMedicines();
  Future<Medicine?> getMedicineById(String id);
  Future<List<Medicine>> searchMedicines(String query);
  Future<List<Medicine>> getMedicinesByCategory(String category);
  Future<List<Medicine>> getPopularMedicines();
  Future<List<String>> getCategories();
}
