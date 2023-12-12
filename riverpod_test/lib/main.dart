import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/screen/home_screen.dart';

import 'riverpod/provider_observer.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [
        Logger(),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    )
  );
}
