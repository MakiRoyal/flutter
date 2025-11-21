import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:projectflutter/domain/repositories/auth_repository.dart';
import 'package:projectflutter/domain/entities/user.dart';
import 'package:projectflutter/domain/usecases/sign_in.dart';

@GenerateMocks([AuthRepository])
import 'sign_in_test.mocks.dart';

void main() {
  late SignIn usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = SignIn(mockRepository);
  });

  test('should sign in user with email and password', () async {
    // Arrange
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tUser = AppUser(id: '1', email: tEmail);

    when(mockRepository.signInWithEmailPassword(tEmail, tPassword))
        .thenAnswer((_) async => tUser);

    // Act
    final result = await usecase(tEmail, tPassword);

    // Assert
    expect(result, tUser);
    verify(mockRepository.signInWithEmailPassword(tEmail, tPassword));
    verifyNoMoreInteractions(mockRepository);
  });
}
