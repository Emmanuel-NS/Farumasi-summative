import 'package:bloc/bloc.dart';
import '../../../../domain/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartLoaded(cartItems: [], totalAmount: 0.0)) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await cartRepository.getCartItems();
      final total = await cartRepository.getTotalAmount();
      emit(CartLoaded(cartItems: items, totalAmount: total));
    } catch (e) {
      emit(CartError("Failed to load cart: $e"));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      // Optimistic update could be done here, but let's stick to simple logic for now
      emit(CartLoading());
      await cartRepository.addToCart(event.medicine, event.quantity);
      final items = await cartRepository.getCartItems();
      final total = await cartRepository.getTotalAmount();
      emit(CartLoaded(cartItems: items, totalAmount: total));
    } catch (e) {
      emit(CartError("Failed to add to cart: $e"));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      await cartRepository.removeFromCart(event.medicineId);
      final items = await cartRepository.getCartItems();
      final total = await cartRepository.getTotalAmount();
      emit(CartLoaded(cartItems: items, totalAmount: total));
    } catch (e) {
      emit(CartError("Failed to remove from cart: $e"));
    }
  }

  Future<void> _onUpdateCartItemQuantity(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      await cartRepository.updateQuantity(event.medicineId, event.quantity);
      final items = await cartRepository.getCartItems();
      final total = await cartRepository.getTotalAmount();
      emit(CartLoaded(cartItems: items, totalAmount: total));
    } catch (e) {
      emit(CartError("Failed to update quantity: $e"));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      await cartRepository.clearCart();
      emit(const CartLoaded(cartItems: [], totalAmount: 0.0));
    } catch (e) {
      emit(CartError("Failed to clear cart: $e"));
    }
  }
}
