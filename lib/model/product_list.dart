import 'dart:convert';
import '../utils/urls.dart';
import 'product.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  // final _baseUrl = 'https://mini-projeto-4-eb9f4-default-rtdb.firebaseio.com/';

  //https://st.depositphotos.com/1000459/2436/i/950/depositphotos_24366251-stock-photo-soccer-ball.jpg
  //https://st2.depositphotos.com/3840453/7446/i/600/depositphotos_74466141-stock-photo-laptop-on-table-on-office.jpg

  // List<Product> _items = dummyProducts;
  List<Product> _items = [];
  // bool _showFavoriteOnly = false;

  // List<Product> get items {
  //   return [..._items];
  // }

  // List<Product> get favoriteItems {
  //   return _items.where((prod) => prod.isFavorite).toList();
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<List<Product>> fetchProducts() async {
    List<Product> products = [];
    final response = await http.get(Uri.parse('${Urls.BASE_URL}/products.json'));

    if (response.statusCode == 200) {
      Map<String, dynamic> _productsJson = jsonDecode(response.body);

      _productsJson.forEach((id, product) {
        products.add(Product.fromJson(id, product));
      });
      _items = products;
      return products;
    } else {
      throw Exception("Aconteceu algum erro na requisição");
    }
  }

  Future<Product> addProduct(Map<String, Object> data) async {
    final productWithBlackId = Product(
      id: '',
      title: data['title'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );
    var response = await http.post(Uri.parse('${Urls.BASE_URL}/products.json'),
        body: jsonEncode(productWithBlackId.toJson()));

    if (response.statusCode == 200) {
      final id = jsonDecode(response.body)['name'];
      final product = Product(
        id: id,
        title: productWithBlackId.title,
        description: productWithBlackId.description,
        price: productWithBlackId.price,
        imageUrl: productWithBlackId.imageUrl,
      );
      product.syncProduct();
      _items.add(product);
      notifyListeners();
      return product;
    } else {
      throw Exception("Aconteceu algum erro na requisição");
    }
  }

  Future<void> removeProduct(Product product) async {
    final response = await http.delete(Uri.parse('${Urls.BASE_URL}/products/${product.id}.json'));

    if (response.statusCode == 200) {
      removeProductFromList(product);
    } else {
      throw Exception("Aconteceu algum erro durante a requisição");
    }
  }

  void removeProductFromList(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
      }
    }

  void updateProduct(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      product.syncProduct();  
      _items[index] = product;
      notifyListeners();
    }
  }

  Product findProductById(String productId) {
    return _items.firstWhere((p) => p.id == productId);
  }
}
