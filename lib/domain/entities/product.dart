import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String thumbnail;
  final List<String> images;
  final double? rating;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.images,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      thumbnail: json['image'] as String? ?? json['thumbnail'] as String? ?? '',
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [json['image'] as String? ?? ''],
      rating: json['rating']?['rate']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': thumbnail,
      'thumbnail': thumbnail,
      'images': images,
      'rating': rating != null ? {'rate': rating} : null,
    };
  }

  @override
  List<Object?> get props => [id, title, price, description, category, thumbnail, images, rating];
}
