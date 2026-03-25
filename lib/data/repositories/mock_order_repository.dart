import 'package:farumasi_patient_app/domain/repositories/order_repository.dart';
import 'package:farumasi_patient_app/data/models/prescription_order.dart';

class MockOrderRepository implements OrderRepository {
  final List<PrescriptionOrder> _orders = [];

  @override
  Future<void> createOrder(PrescriptionOrder order) async {
    _orders.add(order);
  }

  @override
  Future<List<PrescriptionOrder>> getOrders(String userId) async {
    return _orders.where((o) => o.userId == userId).toList();
  }

  @override
  Future<List<PrescriptionOrder>> getAllOrders() async {
    return _orders;
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    // Mock update: do nothing complex
  }

  @override
  Stream<List<PrescriptionOrder>> getOrdersStream(String userId) {
    return Stream.value(_orders.where((o) => o.userId == userId).toList());
  }

  @override
  Stream<List<PrescriptionOrder>> getAllOrdersStream() {
    return Stream.value(_orders);
  }
}
