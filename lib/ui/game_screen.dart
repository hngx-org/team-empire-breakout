import 'package:flame_forge2d/forge2d_game.dart';
import '../components/ball.dart';
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
  final breakoutGame = BreakoutGame();
  int score = 0;
  @override
  void initState() {
    super.initState();
    breakoutGame.brickBrokenCallback = updateScore;
  }

  void updateScore(int newScore) {
    setState(() {
      score = newScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            color: Colors.black87,
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 40,
            ),
            child: GameWidget(
              game: breakoutGame,

            ),
          ),

        ],
      ),
    );
  }
}

