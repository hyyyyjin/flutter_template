import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled2/common/model/cursor_pagination_model.dart';
import 'package:untitled2/restaurant/component/restaurant_card.dart';
import 'package:untitled2/restaurant/provider/restaurant_provider.dart';
import 'package:untitled2/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {

  final controller = ScrollController();


  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가
    // 최대 길이보다 조금 덜 되는 위치까지 왔다면
    // 새로운 데이터를 추가 요청

    // controller.offset = 현재 위치
    if(controller.offset > controller.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(
        fetchMore: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // 완전 처음 로딩인 경우
    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0
                ),
                child: Center(
                  child: data is CursorPaginationFetchingMore ?
                    CircularProgressIndicator() : Text('마지막 데이터 입니다.'),
                ),
              );
            }

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
      )
    );
  }
}
