import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

class CartViewModel extends ChangeNotifier {
  final OrderRepository orderRepository;
  
  final List<CartItem> _items = [];
  
  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  
  double get total {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  CartViewModel({required this.orderRepository});

  void addProduct(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      removeProduct(product);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void incrementQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      notifyListeners();
    }
  }

  void decrementQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final newQuantity = _items[index].quantity - 1;
      if (newQuantity <= 0) {
        removeProduct(product);
      } else {
        _items[index] = _items[index].copyWith(quantity: newQuantity);
        notifyListeners();
      }
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Future<void> checkout() async {
    if (_items.isEmpty) return;

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(_items),
      total: total,
      createdAt: DateTime.now(),
    );

    await orderRepository.createOrder(order);
    clear();
  }

  bool isInCart(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }

  int getQuantity(Product product) {
    final item = _items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    return item.quantity;
  }
}
