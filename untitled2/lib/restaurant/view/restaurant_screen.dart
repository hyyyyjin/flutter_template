import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled2/common/model/cursor_pagination_model.dart';
import 'package:untitled2/restaurant/component/restaurant_card.dart';
import 'package:untitled2/restaurant/model/restaurant_model.dart';
import 'package:untitled2/restaurant/provider/restaurant_provider.dart';
import 'package:untitled2/restaurant/repository/restaurant_repository.dart';
import 'package:untitled2/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
          itemBuilder: (_, index) {
            final pItem = cp.data[index];
            // parsed
            return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen (id : pItem.id)
                      )
                  );
                  },
                child: RestaurantCard.fromModel(model: pItem)
            );
          },
          separatorBuilder: (_, index) {
            return SizedBox(height: 16.0);
          },
          itemCount: cp.data.length
      )
    );
  }
}
