import '../model/order.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final productsCount = order.productsCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedido: ${order.id}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Data: ${order.date.toLocal()}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(),
            Text(
              'Produtos:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: productsCount.length,
                itemBuilder: (ctx, index) {
                  final product = productsCount.keys.elementAt(index);
                  final quantity = productsCount[product]!;

                  return ListTile(
                    title: Text(product.title),
                    subtitle: Text('Quantidade: $quantity'),
                    trailing: Text(
                      'R\$ ${(product.price * quantity).toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              'Total: R\$ ${order.total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
