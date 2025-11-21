import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:projectflutter/domain/repositories/product_repository.dart';
import 'package:projectflutter/domain/entities/product.dart';
import 'package:projectflutter/domain/usecases/get_products.dart';

@GenerateMocks([ProductRepository])
import 'get_products_test.mocks.dart';

void main() {
  late GetProducts usecase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = GetProducts(mockRepository);
  });

  test('should get products from the repository', () async {
    // Arrange
    final tProducts = [
      const Product(
        id: 1,
        title: 'Test Product',
        price: 19.99,
        description: 'Test Description',
        category: 'electronics',
        thumbnail: 'https://test.com/image.jpg',
        images: ['https://test.com/image.jpg'],
      ),
    ];

    when(mockRepository.getProducts())
        .thenAnswer((_) async => tProducts);

    // Act
    final result = await usecase();

    // Assert
    expect(result, tProducts);
    verify(mockRepository.getProducts());
    verifyNoMoreInteractions(mockRepository);
  });
}
