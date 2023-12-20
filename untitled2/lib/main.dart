import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled2/common/component/common_text_form_field.dart';
import 'package:untitled2/common/provider/go_router.dart';
import 'package:untitled2/common/view/splash_screen.dart';
import 'package:untitled2/user/provider/auth_provider.dart';
import 'package:untitled2/user/view/login_screen.dart';

void main() {
  runApp(
      ProviderScope(
          child: _App()
      )
  );

}

// private class 는 _가 앞에붙음
class _App extends ConsumerWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch - 값이 변경될때마다 다시 빌드, auth정보가 바뀔때마다 goRoute가 리빌드되게됨 watch를 쓰면
    // read - 한번만 읽고 값이 변경돼도 다시 빌드하지 않음.
    final router = ref.read(routerProvider);

    return MaterialApp.router(
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        debugShowCheckedModeBanner: false,
        // home: SplashScreen(),
        routerConfig: router,
    );
  }
}
