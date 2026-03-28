import 'package:farumasi_patient_app/data/models/models.dart';

abstract class MedicineRepository {
  Future<List<Medicine>> getMedicines();
  Stream<List<Medicine>> getMedicinesStream();
  Future<Medicine?> getMedicineById(String id);
  Future<List<Medicine>> searchMedicines(String query);
  Future<List<Medicine>> getMedicinesByCategory(String category);
  Future<List<Medicine>> getPopularMedicines();
  Future<List<String>> getCategories();

  // Admin CRUD
  Future<void> addMedicine(Medicine medicine);
  Future<void> updateMedicine(Medicine medicine);
  Future<void> deleteMedicine(String id);
}
