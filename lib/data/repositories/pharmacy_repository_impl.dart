import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pharmacy.dart';

abstract class PharmacyRepository {
  Future<List<Pharmacy>> getPharmacies();
  Stream<List<Pharmacy>> getPharmaciesStream();
  Future<void> addPharmacy(Pharmacy pharmacy);
  Future<void> updatePharmacy(Pharmacy pharmacy);
  Future<void> deletePharmacy(String id);
}

class PharmacyRepositoryImpl implements PharmacyRepository {
  final FirebaseFirestore _firestore;

  PharmacyRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Pharmacy>> getPharmacies() async {
    try {
      final snapshot = await _firestore.collection('pharmacies').get();
      return snapshot.docs
          .map((doc) => Pharmacy.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Stream<List<Pharmacy>> getPharmaciesStream() {
    return _firestore.collection('pharmacies').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Pharmacy.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<void> addPharmacy(Pharmacy pharmacy) async {
    if (pharmacy.id.isEmpty) {
      await _firestore.collection('pharmacies').add(pharmacy.toJson());
    } else {
      await _firestore.collection('pharmacies').doc(pharmacy.id).set(pharmacy.toJson());
    }
  }

  @override
  Future<void> updatePharmacy(Pharmacy pharmacy) async {
    await _firestore
        .collection('pharmacies')
        .doc(pharmacy.id)
        .update(pharmacy.toJson());
  }

  @override
  Future<void> deletePharmacy(String id) async {
    await _firestore.collection('pharmacies').doc(id).delete();
  }
}
