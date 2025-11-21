import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:projectflutter/domain/entities/product.dart';
import 'package:projectflutter/domain/repositories/order_repository.dart';
import 'package:projectflutter/presentation/widgets/product_card.dart';
import 'package:projectflutter/presentation/viewmodels/cart_viewmodel.dart';

@GenerateMocks([OrderRepository])
import 'product_card_test.mocks.dart';

void main() {
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
  });

  testWidgets('ProductCard displays product information', (WidgetTester tester) async {
    // Arrange
    const testProduct = Product(
      id: 1,
      title: 'Test Product',
      price: 29.99,
      description: 'Test Description',
      category: 'electronics',
      thumbnail: 'https://test.com/image.jpg',
      images: ['https://test.com/image.jpg'],
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => CartViewModel(orderRepository: mockOrderRepository),
          child: const Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('29.99 €'), findsOneWidget);
    expect(find.text('Ajouter'), findsOneWidget);
  });

  testWidgets('ProductCard add button changes when product is in cart', (WidgetTester tester) async {
    // Arrange
    const testProduct = Product(
      id: 1,
      title: 'Test Product',
      price: 29.99,
      description: 'Test Description',
      category: 'electronics',
      thumbnail: 'https://test.com/image.jpg',
      images: ['https://test.com/image.jpg'],
    );

    final cartViewModel = CartViewModel(orderRepository: mockOrderRepository);
    cartViewModel.addProduct(testProduct);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: cartViewModel,
          child: const Scaffold(
            body: ProductCard(product: testProduct),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Dans le panier'), findsOneWidget);
  });
}
