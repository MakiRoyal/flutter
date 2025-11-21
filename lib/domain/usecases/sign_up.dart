import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<AppUser> call(String email, String password) async {
    return await repository.signUpWithEmailPassword(email, password);
  }
}
