import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:provider/provider.dart';

import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {

  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    // 새로운 소식은 계속해서 받을 필요는 없음, 1회성 refresh 이기때문에 listen false로 세팅
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {

    // final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            //.. 
          },)
        ]
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting 
          ? Center(
              child: CircularProgressIndicator(),
            ) 
          : RefreshIndicator (

              onRefresh: () => _refreshProducts(context),
              child: Consumer<Products> (

                builder: (ctx, productsData, _) => Padding (
                  padding: EdgeInsets.all(8),

                  child: ListView.builder(
                    itemCount: productsData.items.length, 
                    itemBuilder: (_, i) => Column(
                      children: [
                        UserProductItem(
                          productsData.items[i].id,
                          productsData.items[i].title, 
                          productsData.items[i].imageUrl,
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  
                ),
              ),
        ),
      )
    );
  }
}