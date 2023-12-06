import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled2/common/const/colors.dart';
import 'package:untitled2/common/const/data.dart';
import 'package:untitled2/common/layout/default_layout.dart';
import 'package:untitled2/common/view/root_tab.dart';

import '../../common/component/common_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    // localhost
    final emulatorIp = '10.0.2.2:3000';
    final simulatorIp = '127.0.0.1:3000';

    final ip = Platform.isIOS ? simulatorIp : emulatorIp;

    return DefaultLayout(
        child: SingleChildScrollView(
          // 화면에서 다른 곳 눌렀을때 키보드 사라짐
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SafeArea(
            top: true,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Title(),
                  const SizedBox(height: 16.0),
                  _SubTitle(),
                  Image.asset(
                    'asset/img/misc/logo.png',
                    width: MediaQuery.of(context).size.width / 3 * 2,
                  ),
                  CustomTextFormField(
                    hintText: '이메일을 입력해주세요.',
                    onChanged: (String value) {
                      username = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextFormField(
                    hintText: '비밀번호를 입력해주세요.',
                    onChanged: (String value) {
                      password = value;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                      onPressed: () async {
                        // id:password
                        final rawString = '$username:$password';
                        Codec<String, String> stringToBase64 = utf8.fuse(base64);
                        String token = stringToBase64.encode(rawString);

                        final resp = await dio.post('http://$ip/auth/login',
                            options: Options(
                              headers: {
                                'authorization': 'Basic $token',
                              }
                            )
                        );

                        final refreshToken = resp.data['refreshToken'];
                        final accessToken = resp.data['accessToken'];

                        await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RootTab(),
                          )
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: PRIMARY_COLOR
                      ),
                      child: Text(
                          '로그인'
                      ),
                  ),
                  TextButton(
                      onPressed: () async {
                        String refreshToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTcwMTc3MTg2OSwiZXhwIjoxNzAxODU4MjY5fQ.tkgOAQ41ta6uI0jVmJtiSxpScezcKKxLERjBzXcHI5w';

                        final resp = await dio.post('http://$ip/auth/token',
                            options: Options(
                                headers: {
                                  'authorization': 'Bearer $refreshToken',
                                }
                            )
                        );
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: Text(
                        '회원가입'
                      )
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다.',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길:)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
