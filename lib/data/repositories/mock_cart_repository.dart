import 'package:farumasi_patient_app/data/models/models.dart';
import 'package:farumasi_patient_app/domain/repositories/cart_repository.dart';

class MockCartRepository implements CartRepository {
  // In-memory cart storage
  final List<CartItem> _cartItems = [];

  // Simulate network delay
  final Duration _delay = const Duration(milliseconds: 200);

  @override
  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(_delay);
    return List.from(_cartItems);
  }

  @override
  Future<void> addToCart(Medicine medicine, int quantity) async {
    await Future.delayed(_delay);
    final existingIndex = _cartItems.indexWhere(
      (item) => item.medicine.id == medicine.id,
    );
    if (existingIndex >= 0) {
      final currentItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = currentItem.copyWith(
        quantity: currentItem.quantity + quantity,
      );
    } else {
      _cartItems.add(CartItem(medicine: medicine, quantity: quantity));
    }
  }

  @override
  Future<void> removeFromCart(String medicineId) async {
    await Future.delayed(_delay);
    _cartItems.removeWhere((item) => item.medicine.id == medicineId);
  }

  @override
  Future<void> updateQuantity(String medicineId, int quantity) async {
    await Future.delayed(_delay);
    final existingIndex = _cartItems.indexWhere(
      (item) => item.medicine.id == medicineId,
    );
    if (existingIndex >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(existingIndex);
      } else {
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: quantity,
        );
      }
    }
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(_delay);
    _cartItems.clear();
  }

  @override
  Future<double> getTotalAmount() async {
    await Future.delayed(_delay);
    return _cartItems.fold<double>(0.0, (sum, item) => sum + item.total);
  }
}
