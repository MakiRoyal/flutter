import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<AppUser> call(String email, String password) async {
    return await repository.signInWithEmailPassword(email, password);
  }
}
