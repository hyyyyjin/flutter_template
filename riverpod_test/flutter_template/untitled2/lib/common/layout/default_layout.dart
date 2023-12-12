import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if(title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        // appBar가 튀어나온듯한 효과
        elevation: 0,
        title: Text(
          // !가 들어가면 null이 될수없다는 표시
          title!,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500
          ),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
