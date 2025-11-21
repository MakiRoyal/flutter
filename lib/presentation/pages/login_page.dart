import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../core/utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();

    try {
      if (_isLogin) {
        await authViewModel.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        if (mounted) {
          context.go('/catalog');
        }
      } else {
        await authViewModel.signUp(
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        if (mounted) {
          // Afficher un message de succès et basculer vers la connexion
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Compte créé avec succès ! Connectez-vous maintenant.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          setState(() {
            _isLogin = true;
            _passwordController.clear();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1F3A),
              const Color(0xFF0A0E27),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sports_esports,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '🎮 GameVault',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Votre paradis du gaming',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: Validators.password,
                      ),
                      const SizedBox(height: 24),
                      Consumer<AuthViewModel>(
                        builder: (context, authViewModel, child) {
                          return authViewModel.isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.games),
                                        const SizedBox(width: 8),
                                        Text(_isLogin ? 'Game On! 🎮' : 'Rejoindre 🚀'),
                                      ],
                                    ),
                                  ),
                                );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? 'Pas encore de compte ? S\'inscrire'
                              : 'Déjà un compte ? Se connecter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
