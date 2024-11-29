// import 'package:eshop/model/cart.dart';
import 'package:eshop/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
// import '../model/product_list.dart';
import '../model/user.dart';
import '../utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {

    //PEGANDO CONTEUDO PELO PROVIDER
    final product = context.watch<Product>();
    final user = Provider.of<User>(context);
    // final cart = Provider.of<Cart>(context);

    return ClipRRect(
      //corta de forma arredondada o elemento de acordo com o BorderRaius
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: product.id);
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              //adicionando metodo ao clique do botão
              product.toggleFavorite();
            },
            //icon: Icon(Icons.favorite),
            //pegando icone se for favorito ou não
            icon: Consumer<Product>(
              builder: (context, product, child) => Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
            //isFavorite ? Icons.favorite : Icons.favorite_border),
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          // trailing: IconButton(
          //   onPressed: () => Provider.of<ProductList>(context, listen: false).removeProduct(product),
          //   icon: Icon(Icons.delete),
          //   color: Theme.of(context).colorScheme.secondary
          // ),
          trailing: user.isLoggedIn 
            ? IconButton(
              onPressed: () {  
                //adicionando produto ao carrinho
                Provider.of<Cart>(context, listen: false).addProduct(product);
              }, 
              icon: const Icon(Icons.add_shopping_cart_rounded),
              color: Theme.of(context).colorScheme.secondary,
            )
            : Container(),
        ),
      ),
    );
  }
}
