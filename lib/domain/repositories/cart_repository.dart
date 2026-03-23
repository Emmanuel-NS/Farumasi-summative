import 'package:farumasi_patient_app/data/models/models.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addToCart(Medicine medicine, int quantity);
  Future<void> removeFromCart(String medicineId);
  Future<void> updateQuantity(String medicineId, int quantity);
  Future<void> clearCart();
  Future<double> getTotalAmount();
}
