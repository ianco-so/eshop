import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/product_grid.dart';
import '../model/user.dart';
import '../utils/app_routes.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showOnlyFavorites = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<ProductList>(context);
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Minha Loja'),
        actions: [
          user.isLoggedIn ? IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCT_FORM,
              );
            },
            icon: Icon(Icons.add),
          )
          : Container(),
          user.isLoggedIn ? IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.CART,
              );
            },
            icon: Icon(Icons.shopping_cart)
          )
          : Container(),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  //provider.showFavoriteOnly();
                  _showOnlyFavorites = true;
                } else {
                  //provider.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Text(
                'Minha Loja',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Consumer<User>(
                builder: (ctx, user, _) => Text(
                  user.isLoggedIn ? '${user.username}' : 'Login',
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PROFILE, // Define this route in your app routes
                );
              },
            ),
            // Orders
            user.isLoggedIn ? ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Meus Pedidos'),
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.ORDERS, // Define this route in your app routes
                );
              },
            ) : Container(),
          ],
        ),
      ),
      body: ProductGrid(_showOnlyFavorites),
    );
  }
}