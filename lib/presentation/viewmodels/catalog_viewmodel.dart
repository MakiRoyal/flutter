import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class CatalogViewModel extends ChangeNotifier {
  final ProductRepository productRepository;
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  Set<String> _selectedCategories = {};
  List<String> _categories = [];

  List<Product> get products => _filteredProducts.isEmpty && _searchQuery.isEmpty 
      ? _products 
      : _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  Set<String> get selectedCategories => _selectedCategories;
  List<String> get categories => _categories;

  CatalogViewModel({required this.productRepository});

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await productRepository.getProducts();
      _filteredProducts = _products;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      _categories = await productRepository.getCategories();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredProducts = _selectedCategories.isNotEmpty
          ? _products.where((p) => _selectedCategories.contains(p.category)).toList()
          : _products;
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      if (_selectedCategories.isNotEmpty) {
        _filteredProducts = _filteredProducts
            .where((p) => _selectedCategories.contains(p.category))
            .toList();
      }
    }
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    
    if (_selectedCategories.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((p) => _selectedCategories.contains(p.category))
          .toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      searchProducts(_searchQuery);
    } else {
      notifyListeners();
    }
  }
  
  void clearCategories() {
    _selectedCategories.clear();
    _filteredProducts = _products;
    if (_searchQuery.isNotEmpty) {
      searchProducts(_searchQuery);
    } else {
      notifyListeners();
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategories.clear();
    _filteredProducts = _products;
    notifyListeners();
  }
}
