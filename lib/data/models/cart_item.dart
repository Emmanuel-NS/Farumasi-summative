import 'package:equatable/equatable.dart';
import 'medicine.dart';

class CartItem extends Equatable {
  final Medicine medicine;
  final int
  quantity; // Made final for Equatable, mutation should be handled via copyWith

  const CartItem({required this.medicine, this.quantity = 1});

  double get total => medicine.price * quantity;

  @override
  List<Object?> get props => [medicine, quantity];

  CartItem copyWith({Medicine? medicine, int? quantity}) {
    return CartItem(
      medicine: medicine ?? this.medicine,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {'medicine': medicine.toJson(), 'quantity': quantity};
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      medicine: Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }
}
