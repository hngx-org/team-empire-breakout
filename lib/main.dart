
import 'package:emp_breakout/ui/game_screen.dart';
import 'package:emp_breakout/ui/splash_screen.dart';
import 'package:flutter/material.dart';

import 'components/ball.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Breakout Game',

      home: SplashPage()
    );
  }
}
