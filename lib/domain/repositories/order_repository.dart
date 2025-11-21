import '../entities/order.dart';

abstract class OrderRepository {
  Future<void> createOrder(Order order);
  Future<List<Order>> getOrders();
  Future<void> clearOrders();
}
