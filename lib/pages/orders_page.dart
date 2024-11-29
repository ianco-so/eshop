import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/order_item.dart';
import '../model/order_list.dart';
import 'order_details_page.dart';

class OrdersPage extends StatelessWidget {

  const OrdersPage({super.key}); // Match this to your `AppRoutes.ORDERS`

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).fetchOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar pedidos. Tente novamente mais tarde.',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return Consumer<OrderList>(
              builder: (ctx, orderList, child) {
                if (orderList.orders.isEmpty) {
                  return Center(child: Text('Nenhum pedido encontrado.'));
                }
                return ListView.builder(
                  itemCount: orderList.orders.length,
                  itemBuilder: (ctx, i) {
                    final order = orderList.orders[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OrderDetailsPage(order: order),
                          ),
                        );
                      },
                      child: OrderItem(order: order),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
