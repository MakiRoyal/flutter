import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:projectflutter/domain/repositories/order_repository.dart';
import 'package:projectflutter/domain/entities/product.dart';
import 'package:projectflutter/domain/entities/cart_item.dart';
import 'package:projectflutter/presentation/viewmodels/cart_viewmodel.dart';

@GenerateMocks([OrderRepository])
import 'cart_viewmodel_test.mocks.dart';

void main() {
  late CartViewModel viewModel;
  late MockOrderRepository mockRepository;

  setUp(() {
    mockRepository = MockOrderRepository();
    viewModel = CartViewModel(orderRepository: mockRepository);
  });

  test('initial cart should be empty', () {
    expect(viewModel.items, []);
    expect(viewModel.itemCount, 0);
    expect(viewModel.total, 0);
  });

  test('should add product to cart', () {
    // Arrange
    const tProduct = Product(
      id: 1,
      title: 'Test Product',
      price: 19.99,
      description: 'Test Description',
      category: 'electronics',
      thumbnail: 'https://test.com/image.jpg',
      images: ['https://test.com/image.jpg'],
    );

    // Act
    viewModel.addProduct(tProduct);

    // Assert
    expect(viewModel.items.length, 1);
    expect(viewModel.items.first.product, tProduct);
    expect(viewModel.items.first.quantity, 1);
    expect(viewModel.total, 19.99);
  });

  test('should increment quantity when adding same product', () {
    // Arrange
    const tProduct = Product(
      id: 1,
      title: 'Test Product',
      price: 19.99,
      description: 'Test Description',
      category: 'electronics',
      thumbnail: 'https://test.com/image.jpg',
      images: ['https://test.com/image.jpg'],
    );

    // Act
    viewModel.addProduct(tProduct);
    viewModel.addProduct(tProduct);

    // Assert
    expect(viewModel.items.length, 1);
    expect(viewModel.items.first.quantity, 2);
    expect(viewModel.total, 39.98);
  });

  test('should remove product from cart', () {
    // Arrange
    const tProduct = Product(
      id: 1,
      title: 'Test Product',
      price: 19.99,
      description: 'Test Description',
      category: 'electronics',
      thumbnail: 'https://test.com/image.jpg',
      images: ['https://test.com/image.jpg'],
    );

    viewModel.addProduct(tProduct);

    // Act
    viewModel.removeProduct(tProduct);

    // Assert
    expect(viewModel.items, []);
    expect(viewModel.total, 0);
  });

  test('should calculate correct total', () {
    // Arrange
    const tProduct1 = Product(
      id: 1,
      title: 'Product 1',
      price: 10.0,
      description: 'Description 1',
      category: 'electronics',
      thumbnail: 'https://test.com/image1.jpg',
      images: ['https://test.com/image1.jpg'],
    );

    const tProduct2 = Product(
      id: 2,
      title: 'Product 2',
      price: 20.0,
      description: 'Description 2',
      category: 'clothing',
      thumbnail: 'https://test.com/image2.jpg',
      images: ['https://test.com/image2.jpg'],
    );

    // Act
    viewModel.addProduct(tProduct1);
    viewModel.addProduct(tProduct1); // quantity = 2
    viewModel.addProduct(tProduct2);

    // Assert
    expect(viewModel.total, 40.0); // (10 * 2) + 20
  });
}
