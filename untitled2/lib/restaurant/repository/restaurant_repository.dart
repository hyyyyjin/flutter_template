import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:untitled2/common/dio/dio.dart';
import 'package:untitled2/common/model/pagination_params.dart';
import 'package:untitled2/restaurant/model/restaurant_detail_model.dart';
import 'package:untitled2/restaurant/model/restaurant_model.dart';
import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

  return repository;
});

@RestApi()
abstract class RestaurantRepository {

  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository;

  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken': 'true'
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams()
  });

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'accessToken': 'true'
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  }) ;

}