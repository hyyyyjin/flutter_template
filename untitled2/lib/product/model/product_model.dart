import 'package:json_annotation/json_annotation.dart';
import 'package:untitled2/common/model/model_with_id.dart';
import 'package:untitled2/common/utils/data_utils.dart';
import 'package:untitled2/restaurant/model/restaurant_model.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements IModelWithId {
  final String id;
  // 상품 이름
  final String name;
  // 상품 상세
  final String detail;
  @JsonKey(
    fromJson: DataUtils.pathToUrl
  )
  final String imgUrl;
  final int price;
  final RestaurantModel restaurant;

  ProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
    required this.restaurant
  });

  factory ProductModel.fromJson(Map<String, dynamic> json)
  => _$ProductModelFromJson(json);
}