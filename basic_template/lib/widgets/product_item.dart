import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    
    // 여기서 listen false하면 favorite 버튼의 상태는 변경되지 않음  
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(

      borderRadius: BorderRadius.circular(10),
      
      child: GridTile(

        child: GestureDetector (
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network (
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),

        footer: GridTileBar (
          backgroundColor: Colors.black87,
          
          // 즐겨 찾기 버튼 (하트 버튼)
          // Consumer : favorite 버튼만 상태 업데이트 할수있도록
          // 왜냐하면 favorite 이 업데이트된다고 전체 내용이 리빌드 되서는 안된다.
          // 가급적이면 Provider 는 listen false로 두고, 변경이 있는 데이터만 Consumer로 감싸준다. 
          leading: Consumer<Product> (
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus(authData.token, authData.userId);
              },
            ),
          ),

          title: Text (
            product.title,
            textAlign: TextAlign.center,
          ),

          trailing: IconButton (
            icon: Icon (
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to cart!', textAlign: TextAlign.center,),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(label: 'UNDO', onPressed: () {
                      cart.removeSingleItem(product.id);
                  },),
                )
              );

            },
            color: Theme.of(context).accentColor,
          ),

        ),
      ),
    );
  }
}
