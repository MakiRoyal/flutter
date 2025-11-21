import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:projectflutter/domain/entities/product.dart';
import 'package:projectflutter/domain/repositories/order_repository.dart';
import 'package:projectflutter/presentation/viewmodels/cart_viewmodel.dart';

@GenerateMocks([OrderRepository])
import 'cart_item_widget_test.mocks.dart';

void main() {
  late MockOrderRepository mockOrderRepository;

  setUp(() {
    mockOrderRepository = MockOrderRepository();
  });

  testWidgets('Cart displays empty message when no items', (WidgetTester tester) async {
    // Arrange
    final cartViewModel = CartViewModel(orderRepository: mockOrderRepository);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: cartViewModel,
          child: Scaffold(
            body: Consumer<CartViewModel>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(
                    child: Text('Panier vide'),
                  );
                }
                return ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      title: Text(item.product.title),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Panier vide'), findsOneWidget);
  });

  testWidgets('Cart displays items when products are added', (WidgetTester tester) async {
    // Arrange
    const testProduct1 = Product(
      id: 1,
      title: 'Product 1',
      price: 19.99,
      description: 'Description 1',
      category: 'electronics',
      thumbnail: 'https://test.com/image1.jpg',
      images: ['https://test.com/image1.jpg'],
    );

    const testProduct2 = Product(
      id: 2,
      title: 'Product 2',
      price: 29.99,
      description: 'Description 2',
      category: 'clothing',
      thumbnail: 'https://test.com/image2.jpg',
      images: ['https://test.com/image2.jpg'],
    );

    final cartViewModel = CartViewModel(orderRepository: mockOrderRepository);
    cartViewModel.addProduct(testProduct1);
    cartViewModel.addProduct(testProduct2);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: cartViewModel,
          child: Scaffold(
            body: Consumer<CartViewModel>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(child: Text('Panier vide'));
                }
                return ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      title: Text(item.product.title),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('Product 2'), findsOneWidget);
    expect(find.text('Panier vide'), findsNothing);
  });
}
