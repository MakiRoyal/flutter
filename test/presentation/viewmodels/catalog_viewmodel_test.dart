import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:projectflutter/domain/repositories/product_repository.dart';
import 'package:projectflutter/domain/entities/product.dart';
import 'package:projectflutter/presentation/viewmodels/catalog_viewmodel.dart';

@GenerateMocks([ProductRepository])
import 'catalog_viewmodel_test.mocks.dart';

void main() {
  late CatalogViewModel viewModel;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    viewModel = CatalogViewModel(productRepository: mockRepository);
  });

  test('initial state should be correct', () {
    expect(viewModel.products, []);
    expect(viewModel.isLoading, false);
    expect(viewModel.error, null);
  });

  test('should load products successfully', () async {
    // Arrange
    final tProducts = [
      const Product(
        id: 1,
        title: 'Product 1',
        price: 19.99,
        description: 'Description 1',
        category: 'electronics',
        thumbnail: 'https://test.com/image1.jpg',
        images: ['https://test.com/image1.jpg'],
      ),
      const Product(
        id: 2,
        title: 'Product 2',
        price: 29.99,
        description: 'Description 2',
        category: 'clothing',
        thumbnail: 'https://test.com/image2.jpg',
        images: ['https://test.com/image2.jpg'],
      ),
    ];

    when(mockRepository.getProducts())
        .thenAnswer((_) async => tProducts);

    // Act
    await viewModel.loadProducts();

    // Assert
    expect(viewModel.products, tProducts);
    expect(viewModel.isLoading, false);
    expect(viewModel.error, null);
  });

  test('should filter products by search query', () async {
    // Arrange
    final tProducts = [
      const Product(
        id: 1,
        title: 'iPhone 14',
        price: 999.99,
        description: 'Latest iPhone',
        category: 'electronics',
        thumbnail: 'https://test.com/iphone.jpg',
        images: ['https://test.com/iphone.jpg'],
      ),
      const Product(
        id: 2,
        title: 'Samsung Galaxy',
        price: 899.99,
        description: 'Android phone',
        category: 'electronics',
        thumbnail: 'https://test.com/samsung.jpg',
        images: ['https://test.com/samsung.jpg'],
      ),
    ];

    when(mockRepository.getProducts())
        .thenAnswer((_) async => tProducts);

    await viewModel.loadProducts();

    // Act
    viewModel.searchProducts('iPhone');

    // Assert
    expect(viewModel.products.length, 1);
    expect(viewModel.products.first.title, 'iPhone 14');
  });
}
