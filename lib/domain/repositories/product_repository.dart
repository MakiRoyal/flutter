import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(int id);
  Future<List<Product>> searchProducts(String query);
  Future<List<String>> getCategories();
  Future<List<Product>> getProductsByCategory(String category);
}
