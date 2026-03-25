import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}
class OrdersLoading extends OrderState {}
class OrderLoading extends OrderState {}
class OrderProcessing extends OrderState {}
class OrderSuccess extends OrderState {}

class OrderFailure extends OrderState {
  final String error;
  final String message;
  const OrderFailure(this.error) : message = error;

  @override
  List<Object> get props => [error, message];
}

class OrdersLoaded extends OrderState {
  final List<dynamic> orders;
  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}

class OrderStatusUpdated extends OrderState {}
