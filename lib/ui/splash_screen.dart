import 'dart:async';

import 'package:emp_breakout/components/linear_progressive_bar.dart';
import 'package:emp_breakout/ui/menu_screen.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  startSplashScreen() async {
    var duration = const Duration(seconds: 6);
    return Timer(duration, () async {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MenuScreen()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startSplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/breakout4.webp'), // Replace with your image path
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 150),
            // Text('Breakout (atari)',
            //     style: TextStyle(
            //         fontFamily: 'Pacifico', fontSize: 50, color: Colors.red)),
            SizedBox(height: 20),
            // Text('Game',
            //     style: TextStyle(
            //         fontFamily: 'Pacifico', fontSize: 50, color: Colors.red)),
            SizedBox(height: 600),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LinearProgressWidget()),
            ),
          ],
        ),
      ),
    );
  }
}
