import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../../core/constants/app_constants.dart';

class ProductDetailPageIOS extends StatefulWidget {
  final String productId;

  const ProductDetailPageIOS({super.key, required this.productId});

  @override
  State<ProductDetailPageIOS> createState() => _ProductDetailPageIOSState();
}

class _ProductDetailPageIOSState extends State<ProductDetailPageIOS> {
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
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F23),
        primaryColor: const Color(0xFF6C63FF),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: CupertinoColors.white),
          bodyMedium: TextStyle(color: CupertinoColors.white),
        ),
      ),
      child: CupertinoPageScaffold(
        backgroundColor: const Color(0xFF0F0F23),
        navigationBar: CupertinoNavigationBar(
          backgroundColor: const Color(0xFF1A1F3A),
          middle: const Text('Détails du produit', 
            style: TextStyle(color: CupertinoColors.white)),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.cart, color: CupertinoColors.white),
            onPressed: () => context.push('/cart'),
          ),
        ),
      child: _isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.exclamationmark_triangle, 
                        size: 48, color: CupertinoColors.systemRed),
                      const SizedBox(height: 16),
                      Text(_error!, style: const TextStyle(color: CupertinoColors.systemRed)),
                      const SizedBox(height: 16),
                      CupertinoButton.filled(
                        onPressed: _loadProduct,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
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
                                          child: Icon(CupertinoIcons.game_controller, 
                                            size: 80, color: Color(0xFF6C63FF)),
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(CupertinoIcons.photo, 
                                            size: 80, color: Color(0xFF6C63FF)),
                                        );
                                      },
                                    );
                            },
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Text(
                              _product!.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  '${_product!.price.toStringAsFixed(2)} ${AppConstants.currency}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6C63FF),
                                  ),
                                ),
                                const Spacer(),
                                if (_product!.rating != null) ...[
                                  const Icon(CupertinoIcons.star_fill, 
                                    color: CupertinoColors.systemYellow, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    _product!.rating!.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 16, color: CupertinoColors.white),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C63FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _product!.category,
                                style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _product!.description,
                              style: const TextStyle(
                                fontSize: 16, 
                                height: 1.6,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Consumer<CartViewModel>(
                              builder: (context, cartViewModel, child) {
                                return CupertinoButton.filled(
                                  onPressed: () {
                                    cartViewModel.addProduct(_product!);
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) => CupertinoAlertDialog(
                                        title: const Text('✅ Ajouté au panier'),
                                        content: const Text('Le produit a été ajouté à votre panier'),
                                        actions: [
                                          CupertinoDialogAction(
                                            child: const Text('OK'),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.cart_badge_plus),
                                      SizedBox(width: 8),
                                      Text(
                                        'Ajouter au panier',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
