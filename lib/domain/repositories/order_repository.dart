import 'package:farumasi_patient_app/data/models/prescription_order.dart';

abstract class OrderRepository {
  Future<void> createOrder(PrescriptionOrder order);
  Future<List<PrescriptionOrder>> getOrders(String userId);
}
