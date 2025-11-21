import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({required this.firebaseAuth});

  @override
  Stream<AppUser?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AppUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
      );
    });
  }

  @override
  Future<AppUser> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = credential.user;
      if (user == null) throw Exception('Sign in failed');
      
      return AppUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    }
  }

  @override
  Future<AppUser> signUpWithEmailPassword(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = credential.user;
      if (user == null) throw Exception('Sign up failed');
      
      return AppUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  AppUser? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'invalid-email':
        return 'Email invalide';
      default:
        return 'Une erreur est survenue';
    }
  }
}
