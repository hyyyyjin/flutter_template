import 'package:flutter/material.dart';
import 'package:untitled2/common/const/colors.dart';
import 'package:untitled2/restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    super.key});

  factory ProductCard.fromModel({
    required RestaurantProductModel model}) {

    return ProductCard(
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover
        ),
        name: model.name,
        detail: model.detail,
        price: model.price
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: REMEMBER THINGs
    // IntrinsicHeight를 사용하면 Row에 있는
    // 모든 위젯들이 최대 높이와 동일한 높이를 가지게 된다.
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: image,
          ),
          const SizedBox(width: 16.0,),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    detail,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: BODY_TEXT_COLOR,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    '₩$price',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}
