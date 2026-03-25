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

class LoadUserOrders extends OrderEvent {
  final String userId;

  const LoadUserOrders(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadAllOrders extends OrderEvent {}

class UpdateOrderStatusEvent extends OrderEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatusEvent(this.orderId, this.status);

  @override
  List<Object> get props => [orderId, status];
}
