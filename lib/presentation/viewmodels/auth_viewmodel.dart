import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  
  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthViewModel({required this.authRepository}) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    authRepository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _user = await authRepository.signInWithEmailPassword(email, password);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await authRepository.signUpWithEmailPassword(email, password);
      // Ne pas connecter automatiquement - l'utilisateur doit se connecter manuellement
      await authRepository.signOut();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    await authRepository.signOut();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
