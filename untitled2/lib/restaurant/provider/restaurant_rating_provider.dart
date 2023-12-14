import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled2/common/model/cursor_pagination_model.dart';
import 'package:untitled2/restaurant/repository/restaurant_rating_repository.dart';

class RestaurantRatingStateNotifier extends StateNotifier<CursorPaginationBase> {

  final RestaurantRatingRepository repository;

  RestaurantRatingStateNotifier({ required this.repository }):
        super(CursorPaginationLoading());



}