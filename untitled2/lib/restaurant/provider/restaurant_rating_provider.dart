import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled2/common/model/cursor_pagination_model.dart';
import 'package:untitled2/common/provider/pagination_provider.dart';
import 'package:untitled2/restaurant/repository/restaurant_rating_repository.dart';
import '../../rating/model/rating_model.dart';

final restaurantRatingProvider = StateNotifierProvider.family<
  RestaurantRatingStateNotifier, CursorPaginationBase, String> ((ref, id) {
    final repo = ref.watch(restaurantRatingRepositoryProvider(id));
    return RestaurantRatingStateNotifier(repository: repo);
  });

class RestaurantRatingStateNotifier extends PaginationProvider<RatingModel, RestaurantRatingRepository> {

  RestaurantRatingStateNotifier({ required super.repository });

}