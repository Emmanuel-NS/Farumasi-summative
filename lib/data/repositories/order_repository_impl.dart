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
      final itemsMap = order.items.map((item) {
        return {
          'medicineId': item.medicine.id,
          'quantity': item.quantity,
          'price': item.medicine.price,
          'name': item.medicine.name,
        };
      }).toList();

      await _firestore.collection('orders').doc(order.id).set({
        'id': order.id,
        'patientName': order.patientName,
        'patientLocationName': order.patientLocationName,
        'patientCoordinates': order.patientCoordinates,
        'prescriptionImageUrl': order.prescriptionImageUrl,
        'date': Timestamp.fromDate(order.date),
        'status': order.status.index, 
        'items': itemsMap,
        'pharmacyPrice': order.pharmacyPrice,
        'deliveryFee': order.deliveryFee,
        // Optional fields
      });
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<List<PrescriptionOrder>> getOrders(String userId) async {
    // For now assuming patientName is unique enough or we filter by userId if added to model
    // Assuming 'patientName' is used as key for now from models.
    try {
      final snapshot = await _firestore.collection('orders')
          .where('patientName', isEqualTo: userId) // Or separate userId field logic
          .orderBy('date', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PrescriptionOrder(
          id: doc.id,
          patientName: data['patientName'] ?? '',
          patientLocationName: data['patientLocationName'] ?? '',
          patientCoordinates: List<double>.from(data['patientCoordinates'] ?? []),
          prescriptionImageUrl: data['prescriptionImageUrl'],
          date: (data['date'] as Timestamp).toDate(),
          status: OrderStatus.values[data['status'] ?? 0], 
          items: (data['items'] as List?)?.map((i) {
             // Reconstruct CartItem with minimal Medicine
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
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
