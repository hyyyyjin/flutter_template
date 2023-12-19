import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_v2_actual/layout/default_layout.dart';

class PushScreen extends StatelessWidget {
  const PushScreen({super.key});

  // context.go // push 를 명확히 구분해서 써야함.
  // go - 선언 그대로 라우터를 새로 생성하는 것 (뒤로가기 누르면 / 화면으로 감)
  // push - 이전 버튼 클릭하면 조회 이전 화면으로 이동
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(body: ListView(
      children: [
        ElevatedButton(
            onPressed: (){
              context.push('/basic');
            },
            child: Text('Push Basic')
        ),
        ElevatedButton(
            onPressed: (){
              context.go('/basic');
            },
            child: Text('Go Basic')
        ),
      ],
    ));
  }
}
