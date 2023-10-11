import 'package:emp_breakout/components/overlay.dart';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../components/breakout_forge2d.dart';

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGameScreen> {
  final rwGreen = const Color.fromARGB(255, 21, 132, 67);
  final forge2dGameWorld = BreakoutGame();
  int score = 0;
  @override
  void initState() {
    super.initState();
    forge2dGameWorld.brickBrokenCallback = updateScore;
  }

  void updateScore(int newScore) {
    setState(() {
      score = newScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rwGreen,
      body: Stack(
        children: [
          Container(
            color: Colors.black87,
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 40,
            ),
            child: GameWidget(
              game: forge2dGameWorld,
              overlayBuilderMap: const {
                'PreGame': OverlayBuilder.preGame,
                'PostGame': OverlayBuilder.postGame,
              },
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Score: $score',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
