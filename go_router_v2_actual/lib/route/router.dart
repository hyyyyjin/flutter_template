import 'package:go_router/go_router.dart';
import 'package:go_router_v2_actual/screens/1_basic_screen.dart';
import 'package:go_router_v2_actual/screens/2_named_screen.dart';

import '../screens/root_screen.dart';

// https://blog.codefactory.ai -> / -> path
// https://blog.codefactory.ai/flutter -> /flutter
// / -> home
// /basic -> basic screen

// /named
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return RootScreen();
      },
      routes: [
        GoRoute(
          path: 'basic',
          builder: (context, state) {
            return BasicScreen();
          }),
        GoRoute(
            path: 'named',
            builder: (context, state) {
              return NamedScreen();
        })
      ],
    )
  ],
);