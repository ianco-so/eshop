import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/urls.dart';
import 'order.dart';

class OrderList with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<Order> addOrder(Order order) async {
    return await order.createOrder().then((order) {
      _orders.add(order);
      notifyListeners();
      return order;
    }).catchError( (error) {
      throw error;
    });
  }

  Future<void> fetchOrders() async {
    this._orders.clear();
    final response = await http.get(Uri.parse('${Urls.BASE_URL}/orders.json'));
    if (response.statusCode == 200) {
      Map<String, dynamic> _ordersJson = jsonDecode(response.body);
      _ordersJson.forEach((id, order) {
        _orders.add(Order.fromJson(order));
      });
    } else {
      throw Exception("Aconteceu algum erro na requisição");
    }
  }

  @override
  String toString() {
    return _orders.toString();
  }
  
}