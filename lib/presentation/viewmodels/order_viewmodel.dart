import 'package:flutter/foundation.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository orderRepository;
  
  List<Order> _orders = [];
  bool _isLoading = false;
  
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  OrderViewModel({required this.orderRepository});

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    _orders = await orderRepository.getOrders();
    _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _isLoading = false;
    notifyListeners();
  }
}
