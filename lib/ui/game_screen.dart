import 'package:emp_breakout/components/overlay.dart';
import 'package:emp_breakout/providers/levels_provider.dart';
import 'package:flame/flame.dart';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/breakout_forge2d.dart';

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGameScreen> {
  final rwGreen = const Color.fromARGB(255, 21, 132, 67);
  final breakout = BreakoutGame();
  int score = 0;


  @override
  void initState() {
    super.initState();
    breakout.brickBrokenCallback = updateScore;
  }

  void updateScore(int newScore) {
    setState(() async {
      score = newScore;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("score", newScore);
    });
  }



  @override
  Widget build(BuildContext context) {
    // Flame.images.load('background.png');
    // final levelProvider = Provider.of<LevelProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body:
          Stack(
            children: [Container(

              child: GameWidget(
                backgroundBuilder: (context){
                  return Container(
                    // margin: EdgeInsets.only(bottom: 100),
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/pinkwall.png'), // Replace with the path to your image asset
                        fit: BoxFit.cover, // You can choose how the image fits in the container
                      ),
                    ),
                  );
                },
                game: breakout,
                overlayBuilderMap: const {
                  'PreGame': OverlayBuilder.preGame,
                  'PauseGame': OverlayBuilder.pauseGame,
                  'PostGame': OverlayBuilder.postGame,
                },
              ),
            ),

          Positioned(
            bottom: 20,
            right: 20,
            child: pauseGame(context, breakout),
          ),
              Positioned(
                top: 20,
                right: 20,
                child: Text("$score"),
              ),
              Positioned(
                bottom: 20,
                left: 20,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, child: Text("Back"),

                ),
              ),

]
    ));
  }
}

