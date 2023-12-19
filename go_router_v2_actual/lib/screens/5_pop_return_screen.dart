import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_v2_actual/layout/default_layout.dart';

class PopReturnScreen extends StatelessWidget {
  const PopReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        body: ListView(
          children: [
            ElevatedButton(
                onPressed: (){
                  context.pop('Code factory');
                },
                child: Text('Pop')
            )
          ],
        )
    );
  }
}
