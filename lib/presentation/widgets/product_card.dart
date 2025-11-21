import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../../core/constants/app_constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 8,
      child: InkWell(
        onTap: () {
          context.push('/product/${product.id}');
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF16213E),
                const Color(0xFF0F0F23),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: const Color(0xFF2A2F4A),
                      child: product.thumbnail.startsWith('http')
                          ? Image.network(
                              product.thumbnail,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF6C63FF),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.sports_esports, size: 50, color: Color(0xFF6C63FF)),
                                );
                              },
                            )
                          : Image.asset(
                              product.thumbnail,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.image_not_supported, size: 50, color: Color(0xFF6C63FF)),
                                );
                              },
                            ),
                    ),
                    // Badge "NEW" ou "HOT" selon le rating
                    if (product.rating != null && product.rating! > 4.0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '🔥 HOT',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF5548C8)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${product.price.toStringAsFixed(2)} ${AppConstants.currency}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (product.rating != null) ...[
                          const Spacer(),
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            product.rating!.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Consumer<CartViewModel>(
                      builder: (context, cartViewModel, child) {
                        final isInCart = cartViewModel.isInCart(product);
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isInCart 
                                ? [Colors.green.shade600, Colors.green.shade700]
                                : [const Color(0xFFFF6B9D), const Color(0xFFFF8E53)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                cartViewModel.addProduct(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('🎮 Ajouté au panier !'),
                                    backgroundColor: const Color(0xFF6C63FF),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              icon: Icon(
                                isInCart ? Icons.check_circle : Icons.add_shopping_cart,
                                size: 18,
                              ),
                              label: Text(
                                isInCart ? 'Dans le panier' : 'Ajouter',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
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
        ),
      ),
    );
  }
}
