import 'package:flutter/material.dart';
import 'package:untitled2/common/component/common_text_form_field.dart';

void main() {
  runApp(
      _App()
  );

}

// private class 는 _가 앞에붙음
class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormField(
                hintText: '이메일을 입력해주세요.',
                onChanged: (String value) {},
              ),
              CustomTextFormField(
                hintText: '비밀번호를 입력해주세요.',
                onChanged: (String value) {},
                obscureText: true,
              ),
            ],
          ),
        )
    );
  }
}
