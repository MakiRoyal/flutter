import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  final String status;

  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String? ?? 'pending',
    );
  }

  @override
  List<Object?> get props => [id, items, total, createdAt, status];
}
