
import 'package:emp_breakout/providers/levels_provider.dart';
import 'package:emp_breakout/ui/game_screen.dart';
import 'package:emp_breakout/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/ball.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(providers:
          [ ChangeNotifierProvider(create: (context) => LevelProvider())],
          child:const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Breakout Game',

    home:  SplashPage())
    );
  }
}
