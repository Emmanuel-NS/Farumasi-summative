import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/prescription_order.dart';
import '../models/cart_item.dart';
import '../models/medicine.dart';
import '../models/order_status.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createOrder(PrescriptionOrder order) async {
    try {
      // Create a new document reference with an auto-generated ID if order.id is empty
      DocumentReference docRef;
      if (order.id.isEmpty) {
        docRef = _firestore.collection('orders').doc();
      } else {
        docRef = _firestore.collection('orders').doc(order.id);
      }

      final itemsMap = order.items.map((item) {
        return {
          'medicineId': item.medicine.id,
          'quantity': item.quantity,
          'price': item.medicine.price,
          'name': item.medicine.name,
        };
      }).toList();

      await docRef.set({
        'id': docRef.id, // Use the actual document ID
        'userId': order.userId,
        'patientName': order.patientName,
        'patientPhone': order.patientPhone,
        'patientLocationName': order.patientLocationName,
        'patientCoordinates': order.patientCoordinates,
        'prescriptionImageUrl': order.prescriptionImageUrl,
        'date': Timestamp.fromDate(order.date),
        'status': order.status.index,
        'items': itemsMap,
        'pharmacyPrice': order.pharmacyPrice,
        'deliveryFee': order.deliveryFee,
      });
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Helper method to map document snapshot to Model
  PrescriptionOrder _mapSnapshotToOrder(Map<String, dynamic> data, String id) {
    return PrescriptionOrder(
      id: id,
      userId: data['userId'],
      patientName: data['patientName'] ?? '',
      patientPhone: data['patientPhone'],
      patientLocationName: data['patientLocationName'] ?? '',
      patientCoordinates: List<double>.from(data['patientCoordinates'] ?? []),
      prescriptionImageUrl: data['prescriptionImageUrl'],
      date: (data['date'] as Timestamp).toDate(),
      status: OrderStatus.values[data['status'] ?? 0],
      items: (data['items'] as List?)?.map((i) {
            return CartItem(
              medicine: Medicine(
                id: i['medicineId'],
                name: i['name'] ?? 'Unknown',
                description: '',
                price: (i['price'] as num).toDouble(),
                imageUrl: '',
                category: '',
              ),
              quantity: i['quantity'] ?? 1,
            );
          }).toList() ?? [],
      pharmacyPrice: (data['pharmacyPrice'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (data['deliveryFee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  Future<List<PrescriptionOrder>> getOrders(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) => _mapSnapshotToOrder(doc.data(), doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<PrescriptionOrder>> getAllOrders() async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) => _mapSnapshotToOrder(doc.data(), doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final statusIndex = OrderStatus.values.indexWhere((e) => e.name == status);
      if (statusIndex == -1) return;

      await _firestore.collection('orders').doc(orderId).update({
        'status': statusIndex,
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  @override
  Stream<List<PrescriptionOrder>> getOrdersStream(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => _mapSnapshotToOrder(doc.data(), doc.id)).toList());
  }

  @override
  Stream<List<PrescriptionOrder>> getAllOrdersStream() {
    return _firestore
        .collection('orders')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => _mapSnapshotToOrder(doc.data(), doc.id)).toList());
  }
}
