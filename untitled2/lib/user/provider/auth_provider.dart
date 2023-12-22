import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled2/common/view/root_tab.dart';
import 'package:untitled2/common/view/splash_screen.dart';
import 'package:untitled2/order/view/order_done_screen.dart';
import 'package:untitled2/restaurant/view/restaurant_detail_screen.dart';
import 'package:untitled2/user/model/user_model.dart';
import 'package:untitled2/user/provider/user_me_provider.dart';
import 'package:untitled2/user/view/login_screen.dart';

import '../../restaurant/view/basket_screen.dart';

// return : AuthProvider
final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if(previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: RootTab.routeName,
      builder: (_, __) => RootTab(),
      routes: [
        GoRoute(
          path: 'restaurant/:rid',
          name: RestaurantDetailScreen.routeName,
          builder: (_, state) => RestaurantDetailScreen(
              id: state.pathParameters['rid']!,
          )
        )
      ]
    ),
    GoRoute(
      path: '/basket',
      name: BasketScreen.routeName,
      builder: (_, __) => BasketScreen(),
    ),
    GoRoute(
      path: '/order_done',
      name: OrderDoneScreen.routeName,
      builder: (_, __) => OrderDoneScreen(),
    ),
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen(),
    ),
  ];

  // SpalshScreen
  // 왜 필요한가?
  // 앱을 처음 시작 했을때, 로그인 스크리으로 보내줄지, 홈스크린으로 보내줄지 확인하는 과정이 필요하다.
  String? redirectLogic(BuildContext context, GoRouterState state) {

    final UserModelBase? user = ref.read(userMeProvider);
    final loggingIn = state.location == '/login';

    // 유저 정보가 없는데 로그인 중이라면 그대로 로그인 페이지에 두고,
    // 만약에 로그인 중이 아니라면 로그인 페이지로 이동
    if(user == null) {
      return loggingIn ? null : '/login';
    }

    // user가 null이 아님

    // case1: UserModel 인 상태
    // 사용자 정보가 있는 상태면, 로그인 중 이거나 현재 위치가 SplashScreen 이면,
    // 홈으로 이동
    if(user is UserModel) {
      return loggingIn || state.location == '/splash' ? '/' : null;
    }

    // 로그인 페이지로 이동
    if(user is UserModelError) {
      return !loggingIn ? '/login' : null;
    }

    // null => 원래 가던곳으로 가라.
    return null;
  }

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

}