import 'package:farumasi_patient_app/domain/repositories/order_repository.dart';
import '../models/prescription_order.dart';

class MockOrderRepository implements OrderRepository {
  @override
  Future<void> createOrder(PrescriptionOrder order) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    print("Mock Order Created: ${order.items.length} items");
  }

  @override
  Future<List<PrescriptionOrder>> getOrders(String userId) async {
    // Return empty list or some dummy orders if needed
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }
}
