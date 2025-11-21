import '../entities/user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  Future<AppUser> signInWithEmailPassword(String email, String password);
  Future<AppUser> signUpWithEmailPassword(String email, String password);
  Future<void> signOut();
  AppUser? getCurrentUser();
}
