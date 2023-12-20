import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';
import 'package:untitled2/common/const/colors.dart';
import 'package:untitled2/common/layout/default_layout.dart';
import 'package:untitled2/common/model/cursor_pagination_model.dart';
import 'package:untitled2/common/utils/pagination_utils.dart';
import 'package:untitled2/product/component/product_card.dart';
import 'package:untitled2/product/model/product_model.dart';
import 'package:untitled2/rating/component/rating_card.dart';
import 'package:untitled2/rating/model/rating_model.dart';
import 'package:untitled2/restaurant/component/restaurant_card.dart';
import 'package:untitled2/restaurant/model/restaurant_detail_model.dart';
import 'package:untitled2/restaurant/provider/restaurant_provider.dart';
import 'package:untitled2/restaurant/provider/restaurant_rating_provider.dart';
import 'package:untitled2/user/provider/basket_provider.dart';
import 'package:badges/badges.dart' as badges;

import '../model/restaurant_model.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'restaurantDetail';

  final String id;
  const RestaurantDetailScreen({
    required this.id,
    super.key
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
        controller: controller,
        provider: ref.read(restaurantRatingProvider(widget.id).notifier)
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);

    if(state == null) {
      return DefaultLayout(
          child: Center(
            child: CircularProgressIndicator(),
          )
      );
    }

    return DefaultLayout(
      title: '불타는 떡볶이',
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: PRIMARY_COLOR,
        child: badges.Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(
            basket.fold<int>(0, (previous, next) => previous + next.count).toString(),
            style: TextStyle(
              color: PRIMARY_COLOR
            ),
          ),
          child: Icon(Icons.shopping_basket_outlined),
          badgeColor: Colors.white,
        ),
      ),
      child:  CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(
            model: state,
          ),
          if(state is !RestaurantDetailModel) rederLoading(),
          if(state is RestaurantDetailModel) renderLabel(),
          if(state is RestaurantDetailModel) renderProducts(products: state.products, restaurant: state),

          if(ratingState is CursorPagination<RatingModel>) renderRatings(models: ratingState.data)
        ],
      )
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models}) {

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((_, index)
            => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RatingCard.fromModel(model: models[index]),
            ),
          childCount: models.length
        ),
      )
    );
  }

  SliverPadding rederLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
              3, (index) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 5,
                    padding: EdgeInsets.zero,

                  ),
                ),
              )
          )
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts({required RestaurantModel restaurant, required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final model = products[index];
            // Inkwell 은 누르면 action이 있음, Gesture은 없음. 
            return InkWell(
              onTap: (){
                ref.read(basketProvider.notifier).addToBasket(
                    product: ProductModel(
                        id: model.id,
                        name: model.name,
                        detail: model.detail,
                        imgUrl: model.imgUrl,
                        price: model.price,
                        restaurant: restaurant
                    )
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard.fromRestaurantProductModel(
                    model: model
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model}) {

    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

}
