import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderProcessing extends OrderState {}

class OrderSuccess extends OrderState {}

class OrderFailure extends OrderState {
  final String error;

  const OrderFailure(this.error);
}
