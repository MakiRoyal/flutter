import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/order_viewmodel.dart';
import '../../core/constants/app_constants.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.receipt_long, size: 24),
            const SizedBox(width: 8),
            const Text('Historique Gaming'),
          ],
        ),
      ),
      body: Consumer<OrderViewModel>(
        builder: (context, orderViewModel, child) {
          if (orderViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderViewModel.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune commande',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Vos commandes apparaîtront ici'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderViewModel.orders.length,
            itemBuilder: (context, index) {
              final order = orderViewModel.orders[index];
              final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text('Commande #${order.id}'),
                  subtitle: Text(dateFormat.format(order.createdAt)),
                  trailing: Text(
                    '${order.total.toStringAsFixed(2)} ${AppConstants.currency}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  children: [
                    const Divider(height: 1),
                    ...order.items.map((item) {
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.thumbnail,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, size: 50);
                            },
                          ),
                        ),
                        title: Text(item.product.title),
                        subtitle: Text('Quantité: ${item.quantity}'),
                        trailing: Text(
                          '${item.totalPrice.toStringAsFixed(2)} ${AppConstants.currency}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
