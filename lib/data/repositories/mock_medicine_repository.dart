import 'dart:async';
import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/domain/repositories/medicine_repository.dart';
import '../dummy_data.dart';

class MockMedicineRepository implements MedicineRepository {
  final Duration _delay = const Duration(milliseconds: 800);
  final StreamController<List<Medicine>> _controller = StreamController<List<Medicine>>.broadcast();

  MockMedicineRepository() {
    _controller.add(dummyMedicines);
  }

  void _notify() {
    _controller.add(List.from(dummyMedicines));
  }

  @override
  Future<List<Medicine>> getMedicines() async {
    await Future.delayed(_delay);
    return dummyMedicines;
  }

  @override
  Stream<List<Medicine>> getMedicinesStream() {
    // Return current state immediately, then follow with updates
    final controller = StreamController<List<Medicine>>();
    controller.add(List.from(dummyMedicines));
    controller.addStream(_controller.stream);
    return controller.stream;
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
    if (query.isEmpty) return List.from(dummyMedicines);

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
    if (category == 'All' || category.isEmpty) return List.from(dummyMedicines);
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

  @override
  Future<void> addMedicine(Medicine medicine) async {
    dummyMedicines.add(medicine);
    _notify();
  }

  @override
  Future<void> updateMedicine(Medicine medicine) async {
    final index = dummyMedicines.indexWhere((m) => m.id == medicine.id);
    if (index != -1) {
      dummyMedicines[index] = medicine;
      _notify();
    }
  }

  @override
  Future<void> deleteMedicine(String id) async {
    dummyMedicines.removeWhere((m) => m.id == id);
    _notify();
  }
}
