import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/catalog_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/product_card.dart';

// Conditional import for Web-specific functionality
import 'pwa_helper_stub.dart'
    if (dart.library.js) 'pwa_helper_web.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _searchController = TextEditingController();
  bool _showPWAInstall = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final catalogViewModel = context.read<CatalogViewModel>();
      catalogViewModel.loadProducts();
      catalogViewModel.loadCategories();
      
      // Check PWA install availability (Web only)
      if (kIsWeb) {
        _checkPWAInstall();
      }
    });
  }
  
  void _checkPWAInstall() {
    try {
      final available = checkPWAInstallAvailable();
      if (available) {
        setState(() {
          _showPWAInstall = true;
        });
      }
    } catch (e) {
      // PWA not available
    }
  }
  
  void _installPWA() {
    if (kIsWeb) {
      try {
        installPWA();
        setState(() {
          _showPWAInstall = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Installation PWA non disponible')),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.sports_esports, size: 24),
            const SizedBox(width: 8),
            const Text('GameZone - Catalogue'),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => context.push('/cart'),
              ),
              if (cartViewModel.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cartViewModel.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // PWA Install button (Web only)
          if (kIsWeb)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Installer l\'application',
              onPressed: () {
                if (_showPWAInstall) {
                  _installPWA();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Installation PWA déjà effectuée ou non disponible'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'orders',
                child: Row(
                  children: [
                    Icon(Icons.history),
                    SizedBox(width: 8),
                    Text('Mes commandes'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Déconnexion'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthViewModel>().signOut();
                context.go('/login');
              } else if (value == 'orders') {
                context.push('/orders');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un produit...',
                      prefixIcon: const Icon(Icons.search),
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<CatalogViewModel>().searchProducts('');
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      context.read<CatalogViewModel>().searchProducts(value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<CatalogViewModel>(
                  builder: (context, catalogViewModel, child) {
                    final selectedCount = catalogViewModel.selectedCategories.length;
                    return OutlinedButton.icon(
                      onPressed: () {
                        _showFilterBottomSheet(context, catalogViewModel);
                      },
                      icon: const Icon(Icons.filter_list),
                      label: Text(
                        selectedCount > 0 ? 'Filtres ($selectedCount)' : 'Filtrer',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        side: BorderSide(
                          color: selectedCount > 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          width: 2,
                        ),
                        backgroundColor: selectedCount > 0
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<CatalogViewModel>(
              builder: (context, catalogViewModel, child) {
                if (catalogViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (catalogViewModel.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(catalogViewModel.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => catalogViewModel.loadProducts(),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }

                if (catalogViewModel.products.isEmpty) {
                  return const Center(
                    child: Text('Aucun produit trouvé'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 900 
                        ? 4 
                        : MediaQuery.of(context).size.width > 600 
                            ? 3 
                            : 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: catalogViewModel.products.length,
                  itemBuilder: (context, index) {
                    final product = catalogViewModel.products[index];
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, CatalogViewModel catalogViewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.filter_list, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'Filtrer par catégorie',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (catalogViewModel.selectedCategories.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        catalogViewModel.clearCategories();
                      },
                      child: const Text(
                        'Réinitialiser',
                        style: TextStyle(color: Color(0xFFFF6B9D)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...catalogViewModel.categories.map((category) {
                    final isSelected = catalogViewModel.selectedCategories.contains(category);
                    return FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected)
                            const Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: Icon(Icons.check_circle, color: Colors.white, size: 16),
                            ),
                          Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade300,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        catalogViewModel.toggleCategory(category);
                      },
                      selectedColor: const Color(0xFF6C63FF),
                      backgroundColor: const Color(0xFF2A2F4A),
                      showCheckmark: false,
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF6C63FF) : Colors.transparent,
                        width: 2,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

