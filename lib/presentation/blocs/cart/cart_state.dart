// cart_state.dart
import 'package:equatable/equatable.dart';
import '../../../../data/models/models.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final double totalAmount;

  const CartLoaded({this.cartItems = const [], this.totalAmount = 0.0});

  @override
  List<Object> get props => [cartItems, totalAmount];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
