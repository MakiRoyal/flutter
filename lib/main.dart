import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/repositories/order_repository.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/catalog_viewmodel.dart';
import 'presentation/viewmodels/cart_viewmodel.dart';
import 'presentation/viewmodels/order_viewmodel.dart';
import 'presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('✅ Firebase initialized successfully');

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    // Create repositories
    final AuthRepository authRepository = AuthRepositoryImpl(firebaseAuth: FirebaseAuth.instance);
    
    final productRepository = ProductRepositoryImpl(
      client: http.Client(),
    );
    final orderRepository = OrderRepositoryImpl(
      prefs: prefs,
    );

    return MultiProvider(
      providers: [
        // Repositories
        Provider<AuthRepository>.value(value: authRepository),
        Provider<ProductRepository>.value(value: productRepository),
        Provider<OrderRepository>.value(value: orderRepository),

        // ViewModels
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(authRepository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => CatalogViewModel(productRepository: productRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => CartViewModel(orderRepository: orderRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderViewModel(orderRepository: orderRepository),
        ),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          final appRouter = AppRouter(authViewModel: authViewModel);

          return MaterialApp.router(
            title: 'GameZone - E-commerce Gaming',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}


class CalculatricePage extends StatefulWidget {
  const CalculatricePage({super.key});

  @override
  State<CalculatricePage> createState() => _CalculatricePageState();
}

enum Operation { addition, soustraction, multiplication, division }

class _CalculatricePageState extends State<CalculatricePage> {
  final TextEditingController nb1Controller = TextEditingController();
  final TextEditingController nb2Controller = TextEditingController();

  Operation? selectedOperation = Operation.addition;
  String resultat = "";

  void calculer() {
    final double? n1 = double.tryParse(nb1Controller.text);
    final double? n2 = double.tryParse(nb2Controller.text);

    if (n1 == null || n2 == null) {
      setState(() {
        resultat = "Veuillez entrer des nombres valides.";
      });
      return;
    }

    double res = 0;

    switch (selectedOperation) {
      case Operation.addition:
        res = n1 + n2;
        break;
      case Operation.soustraction:
        res = n1 - n2;
        break;
      case Operation.multiplication:
        res = n1 * n2;
        break;
      case Operation.division:
        res = n1 / n2;
        break;
      default:
        return;
    }

    setState(() {
      resultat = res.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculatrice"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nb1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Entrez un nombre",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: nb2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Entrez un second nombre",
              ),
            ),

            const SizedBox(height: 24),

            // Radios
            Row(
              children: [
                Radio<Operation>(
                  value: Operation.addition,
                  groupValue: selectedOperation,
                  onChanged: (value) {
                    setState(() => selectedOperation = value);
                  },
                ),
                const Text("Addition"),

                Radio<Operation>(
                  value: Operation.soustraction,
                  groupValue: selectedOperation,
                  onChanged: (value) {
                    setState(() => selectedOperation = value);
                  },
                ),
                const Text("Soustraction"),
              ],
            ),

            Row(
              children: [
                Radio<Operation>(
                  value: Operation.multiplication,
                  groupValue: selectedOperation,
                  onChanged: (value) {
                    setState(() => selectedOperation = value);
                  },
                ),
                const Text("Multiplication"),

                Radio<Operation>(
                  value: Operation.division,
                  groupValue: selectedOperation,
                  onChanged: (value) {
                    setState(() => selectedOperation = value);
                  },
                ),
                const Text("Division"),
              ],
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: calculer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                ),
                child: const Text("Calculer"),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                "Résultat : $resultat",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
