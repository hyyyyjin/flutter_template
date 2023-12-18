import 'package:flutter/material.dart';
import 'package:untitled2/common/component/pagination_list_view.dart';
import 'package:untitled2/product/component/product_card.dart';
import 'package:untitled2/product/model/product_model.dart';
import 'package:untitled2/product/provider/product_provider.dart';
import 'package:untitled2/restaurant/view/restaurant_detail_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(_, index, model){
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_)
              => RestaurantDetailScreen(id: model.restaurant.id))
            );
          },
            child: ProductCard.fromProductModel(model: model)
        );
      },
    );
  }
}
