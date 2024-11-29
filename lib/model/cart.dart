import 'product.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  // List<Product> _products = [];

  Map<Product, int> _products = {};

  Map<Product, int> get products => Map.from(_products);

  void addProduct(Product product) {
    // if (_products.containsKey(product)) {
    //   _products[product] = _products[product]! + 1;
    // } else {
    //   _products[product] = 1;
    // }
    _products.update(product, (value) => value + 1, ifAbsent: () => 1);
    notifyListeners();
    print(_products);
  }

  // void removeProduct(Product product) {
  //   _products.remove(product);
  //   notifyListeners();
  // }

  void removeProduct(Product product) {
    if (_products.containsKey(product)) {
      if (_products[product] == 1) {
        _products.remove(product);
      } else {
        _products.update(product, (value) => value - 1);
      }
      notifyListeners();
    }
  }

  // bool hasProduct(Product product) {
  //   return _products.contains(product);
  // }

  // double get total => _products.map<double>((prod) => prod.price).toList().reduce((a, b) => a + b);
  double get total {
    double total = 0;
    _products.forEach((product, quantity) {
      total += product.price * quantity;
    });
    return total;
  }

  void clear() {
    _products = {};
    notifyListeners();
  }
}