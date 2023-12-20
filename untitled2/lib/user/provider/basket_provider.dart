import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled2/product/model/product_model.dart';
import 'package:untitled2/user/model/basket_item_model.dart';
import 'package:collection/collection.dart';
import 'package:untitled2/user/model/patch_basket_body.dart';

import '../repository/user_me_repository.dart';

final basketProvider = StateNotifierProvider<BasketProvider, List<BasketItemModel>>(
  (ref) {
    final repository = ref.watch(userMeRepositoryProvider);
    return BasketProvider(
      repository: repository
    );
  });

class BasketProvider extends StateNotifier<List<BasketItemModel>> {

  final UserMeRepository repository;

  BasketProvider({required this.repository}) : super([]);
  
  Future<void> patchBasket() async {
    await repository.patchBasket(
        body: PatchBasketBody(
            basket: state.map((e) =>
                PatchBasketBodyBasket(
                    productId: e.product.id,
                    count: e.count
                )
            ).toList()
        )
    );
  }

  Future<void> addToBasket({required ProductModel product}) async {
    // As-is 요청을 먼저 보내고
    // 응답이 오면 캐시를 업데이트 했다.

    // 만약? 요청이 500ms이 걸린다고 가정하자.
    // await Future.delayed(Duration(microseconds: 500));
    // 잘 생각해보면...
    // 과연 에러가 날 가능성이 높을까?
    // 사용자 입장에서 장바구니에 안담겼다고 느끼지 않을까?

    // 요청은 나중에 보낸다(맨 밑으로 보내면 요청 보내기 전에 상태를 업데이트 친다.)

    /***
     * 1) 아직 장바구니에 해당되는 상품이 없다면
     *    장바구니에 상품을 추가한다.
     *
     * 2) 만약에 이미 들어 있다면
     *    장바구니에 있는 값에 +1을 한다.
     */
    final exists = state.firstWhereOrNull((e) => e.product.id == product.id) !=
        null;

    if (exists) {
      state = state.map(
              (e) =>
          e.product.id == product.id
              ? e.copyWith(count: e.count + 1)
              : e).toList();
    } else {
      state = [
        ...state,
        BasketItemModel(
            product: product,
            count: 1
        ),
      ];
    }
    // Optimistic Response (긍정적 응답)
    // 응답이 성공할거라고 가정하고 상태를 먼저 업데이트 한다.
    // await Future.delayed(Duration(microseconds: 500));
    await patchBasket();
  }

  /***
   * isDelete가 true인 경우 count와 관계없이 모두 삭제
   */

  Future<void> removeFromBasket({required ProductModel product, bool isDelete = false}) async {
    /***
     * 1) 장바구니에 상품이 존재할 때
     *    case 1-1. 상품의 카운트가 1보다 크면 - 1 한다.
     *    case 1-2. 상품의 카운트가 1이면 삭제한다.
     * 2) 상품이 존재하지 않을 때
     *    즉시 함수를 반환하고 아무것도 하지 않는다.
     */
    final exists = state.firstWhereOrNull((e) => e.product.id == product.id) !=
        null;

    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    // 같이 않은 대상들만 List로 뽑아냄
    // 0이면 삭제
    if (existingProduct.count == 1 || isDelete) {
      state = state.where((e) => e.product.id != product.id).toList();
    }
    else {
      state = state.map(
              (e) => e.product.id == product.id
              ? e.copyWith(count: e.count - 1)
              : e).toList();
    }

    await patchBasket();
  }
}