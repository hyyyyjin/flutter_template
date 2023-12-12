import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled2/common/component/common_text_form_field.dart';
import 'package:untitled2/common/view/splash_screen.dart';
import 'package:untitled2/user/view/login_screen.dart';

void main() {
  runApp(
      ProviderScope(
          child: _App()
      )
  );

}

// private class 는 _가 앞에붙음
class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'NotoSans',
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
    );
  }
}
