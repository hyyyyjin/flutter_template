import 'package:flutter/material.dart';
import 'package:web_rtc/view/web_rtc_chat.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebRTCChat(),
    );
  }
}