import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled2/common/component/pagination_list_view.dart';
import 'package:untitled2/common/utils/pagination_utils.dart';
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
    PaginationUtils.paginate(
        controller: controller,
        provider: ref.read(restaurantProvider.notifier)
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
        provider: restaurantProvider,
        itemBuilder: <RestaurantModel>(_, index, model) {
          return GestureDetector(
              onTap: (){
                // 아래와 같음 context.go('/restaurant/${model.id}');
                // 모바일에서는 queryParam을 쓰지 않는 것을 권고함
                context.goNamed(
                    RestaurantDetailScreen.routeName,
                    pathParameters: {
                      'rid': model.id
                    }
                );
              },
              child: RestaurantCard.fromModel(model: model)
          );
        }
    );

  }
}
