import 'dart:convert';

import '../model/cart.dart';
import '../model/product.dart';
import 'package:http/http.dart' as http;
import '../utils/urls.dart';


class Order {

  String id;
  final List<Product> products;
  final DateTime date;

  Order({
    required this.id, 
    required this.products,
    DateTime? date
  }): date = date ?? DateTime.now(),
      assert(products.isNotEmpty);

  Future<Order> createOrder() async {
    // final order = Order(id: '', products: products);
    final response = await http.post(
      Uri.parse('${Urls.BASE_URL}/orders.json'),
      body: jsonEncode(this.toJson())
    );

    if (response.statusCode == 200) {
      final id = jsonDecode(response.body)['name'];
      this.id = id;
      this.syncOrder();
      return this;
    } else {
      throw Exception("Aconteceu algum erro na requisição");
    }
  }

  // Create order from a cart instance
  factory Order.fromCart(Cart cart) {
    // return Order(id: '', products: cart.products.keys.toList());
    // multipli the products by the quantity and then flatten the list
    final products = cart.products.entries.expand((entry) => List.filled(entry.value, entry.key)).toList();
    return Order(id: '', products: products);
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      products: (json['products'] as List).map((product) => Product.fromJson(product['id'], product)).toList(),
      date: DateTime.parse(json['date']),
    );
  }

  double get total {
    return products
      .map((product) => product.price)
      .reduce((value, element) => value + element);
  }

  Map<Product, int> get productsCount {
    final Map<Product, int> productsCount = {};
    for (var product in products) {
      if (productsCount.containsKey(product)) {
        productsCount[product] = productsCount[product]! + 1;
      } else {
        productsCount[product] = 1;
      }
    }
    return productsCount;
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'products': products.map((product) => product.toJson()).toList(),
      'date': date.toIso8601String(),
    };
    return data;
  }
  
  Future<void> syncOrder() async {
    final response = await http.patch(
      Uri.parse('${Urls.BASE_URL}/orders/${this.id}.json'),
      body: jsonEncode(this.toJson())
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update order');
    }
  }

  @override
  String toString() {
    return 'Order(id: $id, products: ${this.products}, date: $date)';
  }

}