import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../viewmodels/auth_viewmodel.dart';
import '../pages/landing_page.dart';
import '../pages/login_page.dart';
import '../pages/catalog_page.dart';
import '../pages/product_detail_page.dart';
import '../pages/product_detail_page_ios.dart';
import '../pages/cart_page.dart';
import '../pages/checkout_page.dart';
import '../pages/orders_page.dart';

class AppRouter {
  final AuthViewModel authViewModel;

  AppRouter({required this.authViewModel});

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: authViewModel,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authViewModel.isAuthenticated;
      final isGoingToLanding = state.matchedLocation == '/';
      final isGoingToLogin = state.matchedLocation == '/login';

      // Utilisateurs non authentifiés
      if (!isAuthenticated) {
        if (isGoingToLanding || isGoingToLogin) {
          return null; // Autorise l'accès à la landing page et login
        }
        return '/'; // Redirige vers la landing page pour toutes les autres routes
      }

      // Utilisateurs authentifiés
      if (isAuthenticated) {
        if (isGoingToLanding || isGoingToLogin) {
          return '/catalog'; // Redirige vers le catalogue
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const CatalogPage(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          // Use Cupertino page for iOS, Material for others
          if (!kIsWeb && Platform.isIOS) {
            return ProductDetailPageIOS(productId: id);
          }
          return ProductDetailPage(productId: id);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersPage(),
      ),
    ],
  );
}
