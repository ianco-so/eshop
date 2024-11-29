import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../utils/urls.dart';
class Product with ChangeNotifier {
  // final _baseUrl = 'https://mini-projeto-4-eb9f4-default-rtdb.firebaseio.com/';

  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // Constructor that clones from an existing Product
  Product.fromProduct(Product _product) : 
    id          = _product.id,
    title       = _product.title,
    description = _product.description,
    price       = _product.price,
    imageUrl    = _product.imageUrl,
    isFavorite  = _product.isFavorite;

   // Factory method to create a Product instance from a JSON map
  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id:           id,
      title:        json['title'],
      description:  json['description'],
      price:        json['price'].toDouble(), // Assuming 'price' is stored as a double in JSON
      imageUrl:     json['imageUrl'],
      isFavorite:   json['isFavorite'] ?? false, // Default to false if 'isFavorite' is not present
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id':           id,
      'title':        title,
      'description':  description,
      'price':        price,
      'imageUrl':     imageUrl,
      'isFavorite':   isFavorite,
    };
    return data;
  }

  Future<void> toggleFavorite() async {
    // print('Toggling favorite status for product $id');
    var response = await http.patch(
      Uri.parse('${Urls.BASE_URL}/products/$id.json'),
      body: jsonEncode({'isFavorite': !isFavorite}),
    );
    if (response.statusCode != 200) throw Exception('Failed to update favorite status');
    isFavorite = !isFavorite;
    notifyListeners();  
  }

  // Future<Product> updateProduct (Product product) async {
  //   final response = await http.patch(
  //     Uri.parse('${Urls.BASE_URL}/products/${product.id}.json'),
  //     body: jsonEncode({
  //       'id':           product.id,
  //       'title':        product.title,
  //       'description':  product.description,
  //       'price':        product.price,
  //       'imageUrl':     product.imageUrl,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     this.id = product.id;
  //     this.title = product.title;
  //     this.description = product.description;
  //     this.price = product.price;
  //     this.imageUrl = product.imageUrl;
  //     notifyListeners();
  //     return this;
  //   } else {
  //     throw Exception('Failed to update product');
  //   }
  // }

  Future<void> syncProduct() async {
    final response = await http.patch(
      Uri.parse('${Urls.BASE_URL}/products/$id.json'),
      body: jsonEncode({
        'id':           id,
        'title':        title,
        'description':  description,
        'price':        price,
        'imageUrl':     imageUrl,
        'isFavorite':   isFavorite,
      }),
    );
    if (response.statusCode != 200) throw Exception('Failed to sync product');
  }

  // Future<Product> get product async {
  //   final response = await http.get(Uri.parse('${Urls.BASE_URL}/products/$id.json'));
  //   if (response.statusCode == 200) {
  //     final product = Product.fromJson(id, jsonDecode(response.body));
  //     return product;
  //   } else {
  //     throw Exception('Failed to load product');
  //   }
  // }

  @override
  String toString() {
    return 'Product {title: $title, price: $price}';
  }
}
