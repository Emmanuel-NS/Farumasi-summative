import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<LoadUserOrders>(_onLoadUserOrders);
    on<LoadAllOrders>(_onLoadAllOrders);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    emit(OrderProcessing());
    try {
      await orderRepository.createOrder(event.order);
      emit(OrderSuccess());
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> _onLoadUserOrders(
    LoadUserOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await orderRepository.getOrders(event.userId);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> _onLoadAllOrders(
    LoadAllOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await orderRepository.getAllOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      await orderRepository.updateOrderStatus(event.orderId, event.status);
      emit(OrderStatusUpdated());
      // Re-trigger load to refresh UI for admin
      add(LoadAllOrders());
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }
}
