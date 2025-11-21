import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../core/constants/app_constants.dart';

class ProductRepositoryImpl implements ProductRepository {
  final http.Client client;

  ProductRepositoryImpl({required this.client});

  @override
  Future<List<Product>> getProducts() async {
    try {
      // Matériel gaming Sony
      final sonyGearData = [
        {
          'id': 1,
          'title': 'Sony DualSense PS5 - Blanc',
          'price': 74.99,
          'description': 'Manette sans fil PlayStation 5 avec retour haptique, gâchettes adaptatives, micro intégré et batterie rechargeable. Immersion totale garantie.',
          'category': 'Manettes',
          'image': 'assets/images/dualsense_white.png',
          'rating': {'rate': 4.9}
        },
        {
          'id': 2,
          'title': 'Sony DualSense Edge',
          'price': 239.99,
          'description': 'Manette pro-gaming PS5 haut de gamme avec stick caps interchangeables, boutons arrière programmables et sacoche de transport. Pour les joueurs exigeants.',
          'category': 'Manettes',
          'image': 'assets/images/dualsense_edge.png',
          'rating': {'rate': 4.8}
        },
        {
          'id': 3,
          'title': 'Sony INZONE H9',
          'price': 299.99,
          'description': 'Casque gaming sans fil avec réduction de bruit active (ANC), son spatial 360°, micro antibruit et autonomie jusqu\'à 32 heures. Compatible PS5 et PC.',
          'category': 'Casques',
          'image': 'assets/images/inzone_h9.png',
          'rating': {'rate': 4.7}
        },
        {
          'id': 4,
          'title': 'Sony INZONE H3',
          'price': 99.99,
          'description': 'Casque gaming filaire avec son spatial 360°, drivers 40mm et design léger. Micro bidirectionnel à réduction de bruit pour communications claires.',
          'category': 'Casques',
          'image': 'assets/images/inzone_h3.png',
          'rating': {'rate': 4.6}
        },
        {
          'id': 5,
          'title': 'Sony PlayStation VR2',
          'price': 599.99,
          'description': 'Casque de réalité virtuelle PS5 avec écrans OLED 4K HDR, eye tracking, retour haptique dans le casque et manettes Sense. Nouvelle génération VR.',
          'category': 'Casques VR',
          'image': 'assets/images/psvr2.png',
          'rating': {'rate': 4.8}
        },
        {
          'id': 6,
          'title': 'Sony DualSense Charging Station',
          'price': 29.99,
          'description': 'Station de charge officielle pour 2 manettes DualSense. Design élégant assorti à la PS5, charge rapide via connexion USB-C. Rangement pratique.',
          'category': 'Accessoires',
          'image': 'assets/images/charging_station.png',
          'rating': {'rate': 4.5}
        }
      ];

      return sonyGearData.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final products = await getProducts();
      return products.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Product not found'),
      );
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final products = await getProducts();
    return products
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return [
        'Manettes',
        'Casques',
        'Casques VR',
        'Accessoires',
      ];
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final products = await getProducts();
      return products
          .where((product) => product.category.toLowerCase() == category.toLowerCase())
          .toList();
    } catch (e) {
      throw Exception('Error fetching products by category: $e');
    }
  }
}
