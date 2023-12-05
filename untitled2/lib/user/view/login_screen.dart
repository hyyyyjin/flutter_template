import 'package:flutter/material.dart';
import 'package:untitled2/common/layout/default_layout.dart';

import '../../common/component/common_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Title(),
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
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('환영합니다.');
  }
}
