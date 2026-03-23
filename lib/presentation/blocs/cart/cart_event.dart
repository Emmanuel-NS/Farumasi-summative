// cart_event.dart
import 'package:equatable/equatable.dart';
import 'package:farumasi_patient_app/data/models/models.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final Medicine medicine;
  final int quantity;

  const AddToCart(this.medicine, {this.quantity = 1});

  @override
  List<Object> get props => [medicine, quantity];
}

class RemoveFromCart extends CartEvent {
  final String medicineId;

  const RemoveFromCart(this.medicineId);

  @override
  List<Object> get props => [medicineId];
}

class UpdateCartItemQuantity extends CartEvent {
  final String medicineId;
  final int quantity;

  const UpdateCartItemQuantity(this.medicineId, this.quantity);

  @override
  List<Object> get props => [medicineId, quantity];
}

class ClearCart extends CartEvent {}
