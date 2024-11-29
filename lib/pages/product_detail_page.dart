import 'package:eshop/model/product_list.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import '../utils/app_routes.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Retrieve the product passed via route arguments
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productList = Provider.of<ProductList>(context);
    final user = Provider.of<User>(context);
    final product = productList.findProductById(productId);
    // final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          // Remove Product Button
          user.isLoggedIn ? 
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              productList.removeProduct(product);
              Navigator.of(context).pop();
            },
          )
          : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image
            Image.network(
              product.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),

            // Product Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            // Product Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            // Product Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20),

            // Edit Product Button (open a new page to edit the product)
            if (user.isLoggedIn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.PRODUCT_FORM,
                      arguments: product.id,
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Product'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
