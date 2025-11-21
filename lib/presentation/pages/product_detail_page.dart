import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../../core/constants/app_constants.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? _product;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final repository = context.read<ProductRepository>();
      final product = await repository.getProductById(int.parse(widget.productId));
      setState(() {
        _product = product;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 900;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du produit'),
        actions: [
          // Share button (Android only)
          if (!kIsWeb && Platform.isAndroid && _product != null)
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Partager',
              onPressed: () {
                Share.share(
                  '${_product!.title}\n${_product!.price.toStringAsFixed(2)} ${AppConstants.currency}\n\nDécouvrez ce produit sur GameZone !',
                  subject: 'Découvrez ${_product!.title}',
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProduct,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: isLargeScreen
                      ? Padding(
                          padding: const EdgeInsets.all(32),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image à gauche
                              Expanded(
                                flex: 2,
                                child: Container(
                                  constraints: const BoxConstraints(maxHeight: 500),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2F4A),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: PageView.builder(
                                      itemCount: _product!.images.length,
                                      itemBuilder: (context, index) {
                                        final imageUrl = _product!.images[index];
                                        return imageUrl.startsWith('http')
                                            ? Image.network(
                                                imageUrl,
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Icon(Icons.sports_esports, 
                                                      size: 100, color: Color(0xFF6C63FF)),
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                imageUrl,
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Icon(Icons.image_not_supported, 
                                                      size: 100, color: Color(0xFF6C63FF)),
                                                  );
                                                },
                                              );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 32),
                              // Détails à droite
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _product!.title,
                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Text(
                                          '${_product!.price.toStringAsFixed(2)} ${AppConstants.currency}',
                                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF6C63FF),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        if (_product!.rating != null) ...[
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.amber.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                                const SizedBox(width: 4),
                                                Text(
                                                  _product!.rating!.toStringAsFixed(1),
                                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Chip(
                                      label: Text(_product!.category),
                                      backgroundColor: const Color(0xFF6C63FF).withOpacity(0.1),
                                      labelStyle: const TextStyle(color: Color(0xFF6C63FF)),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      'Description',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _product!.description,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        height: 1.6,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    Consumer<CartViewModel>(
                                      builder: (context, cartViewModel, child) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              cartViewModel.addProduct(_product!);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Ajouté au panier'),
                                                  duration: Duration(seconds: 2),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 20),
                                              backgroundColor: const Color(0xFF6C63FF),
                                            ),
                                            icon: const Icon(Icons.shopping_cart_outlined),
                                            label: const Text(
                                              'Ajouter au panier',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 300,
                              color: const Color(0xFF2A2F4A),
                              child: PageView.builder(
                                itemCount: _product!.images.length,
                                itemBuilder: (context, index) {
                                  final imageUrl = _product!.images[index];
                                  return imageUrl.startsWith('http')
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(Icons.sports_esports, 
                                                size: 80, color: Color(0xFF6C63FF)),
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          imageUrl,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(Icons.image_not_supported, 
                                                size: 80, color: Color(0xFF6C63FF)),
                                            );
                                          },
                                        );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _product!.title,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        '${_product!.price.toStringAsFixed(2)} ${AppConstants.currency}',
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF6C63FF),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (_product!.rating != null) ...[
                                        const Icon(Icons.star, color: Colors.amber, size: 20),
                                        const SizedBox(width: 4),
                                        Text(
                                          _product!.rating!.toStringAsFixed(1),
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Chip(
                                    label: Text(_product!.category),
                                    backgroundColor: const Color(0xFF6C63FF).withOpacity(0.1),
                                    labelStyle: const TextStyle(color: Color(0xFF6C63FF)),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Description',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _product!.description,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
    );
  }
}
