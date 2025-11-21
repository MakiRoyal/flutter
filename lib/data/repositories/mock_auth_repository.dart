import 'dart:async';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Mock Auth Repository - utilisé quand Firebase n'est pas disponible
class MockAuthRepository implements AuthRepository {
  final StreamController<AppUser?> _authStateController = StreamController<AppUser?>.broadcast();
  AppUser? _currentUser;

  MockAuthRepository() {
    // Simuler un utilisateur déjà connecté en mode démo
    _currentUser = const AppUser(
      id: 'demo-user',
      email: 'demo@shopflutter.com',
      displayName: 'Demo User',
    );
    _authStateController.add(_currentUser);
  }

  @override
  Stream<AppUser?> get authStateChanges => _authStateController.stream;

  @override
  Future<AppUser> signInWithEmailPassword(String email, String password) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(seconds: 1));
    
    // Toujours accepter en mode démo
    _currentUser = AppUser(
      id: 'demo-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@').first,
    );
    
    _authStateController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<AppUser> signUpWithEmailPassword(String email, String password) async {
    // Même comportement que signIn en mode démo
    return signInWithEmailPassword(email, password);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  AppUser? getCurrentUser() {
    return _currentUser;
  }

  void dispose() {
    _authStateController.close();
  }
}
