import 'package:farumasi_patient_app/data/models/prescription_order.dart';

abstract class OrderRepository {
  Future<void> createOrder(PrescriptionOrder order);
  Future<List<PrescriptionOrder>> getOrders(String userId);
  Future<List<PrescriptionOrder>> getAllOrders(); // For Admin
  Future<void> updateOrderStatus(String orderId, String status);
  Stream<List<PrescriptionOrder>> getOrdersStream(String userId);
  Stream<List<PrescriptionOrder>> getAllOrdersStream();
}

