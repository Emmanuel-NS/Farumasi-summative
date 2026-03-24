import 'package:equatable/equatable.dart';
import '../../../../data/models/prescription_order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrder extends OrderEvent {
  final PrescriptionOrder order;

  const PlaceOrder(this.order);

  @override
  List<Object> get props => [order];
}
