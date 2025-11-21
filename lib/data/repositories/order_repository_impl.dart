import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../core/constants/app_constants.dart';

class OrderRepositoryImpl implements OrderRepository {
  final SharedPreferences prefs;

  OrderRepositoryImpl({required this.prefs});

  @override
  Future<void> createOrder(Order order) async {
    final orders = await getOrders();
    orders.add(order);
    final ordersJson = orders.map((o) => o.toJson()).toList();
    await prefs.setString(AppConstants.ordersKey, json.encode(ordersJson));
  }

  @override
  Future<List<Order>> getOrders() async {
    final ordersString = prefs.getString(AppConstants.ordersKey);
    if (ordersString == null) return [];
    
    final List<dynamic> ordersJson = json.decode(ordersString);
    return ordersJson.map((json) => Order.fromJson(json)).toList();
  }

  @override
  Future<void> clearOrders() async {
    await prefs.remove(AppConstants.ordersKey);
  }
}
