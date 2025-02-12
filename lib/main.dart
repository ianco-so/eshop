
import 'package:eshop/pages/profile_page.dart';

import '/pages/product_detail_page.dart';
import '/pages/product_form_page.dart';
import '/pages/products_overview_page.dart';
import '/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/cart.dart';
import 'model/order_list.dart';
import 'model/product_list.dart';
import 'model/user.dart';
import 'pages/cart_page.dart';
import 'pages/create_account_page.dart';
import 'pages/orders_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductList()),
        ChangeNotifierProvider(create: (context) => Cart()), // Add the Cart provider
        ChangeNotifierProvider(create: (context) => User()),
        ChangeNotifierProvider(create: (context) => OrderList()),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ThemeData().colorScheme.copyWith(
            primary: Colors.pink,
            secondary: Colors.orangeAccent,
          ),
        ),
        home: ProductsOverviewPage(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (context) => const ProductDetailPage(),
          AppRoutes.PRODUCT_FORM: (context) => const ProductFormPage(),
          AppRoutes.CART: (context) => const CartPage(),
          AppRoutes.PROFILE: (context) => const ProfilePage(),
          AppRoutes.CREATE_ACCOUNT: (context) => const CreateAccountPage(),
          AppRoutes.ORDERS: (context) => const OrdersPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
