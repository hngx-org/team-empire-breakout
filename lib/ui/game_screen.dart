import 'package:emp_breakout/components/timer.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/breakout_forge2d.dart';
import '../components/overlay.dart';
import '../providers/levels_provider.dart';
import '../providers/valuenotifier.dart';

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGameScreen> {
  final rwGreen = const Color.fromARGB(255, 21, 132, 67);
  final breakout = BreakoutGame();
  int score = 0;
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
    final soundProvider = Provider.of<LevelProvider>(context);

    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          Container(
            child: GameWidget(
              backgroundBuilder: (context) {
                return Container(
                  // margin: EdgeInsets.only(bottom: 100),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/pinkwall.png'), // Replace with the path to your image asset
                      fit: BoxFit
                          .cover, // You can choose how the image fits in the container
                    ),
                  ),
                );
              },
              game: breakout,
              overlayBuilderMap: const {
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
          ValueListenableBuilder(
              valueListenable: scoreInstance,
              builder: (context, value, _) {
                return Positioned(
                    top: 50,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Score: $value',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ));
              }),
          ValueListenableBuilder(
              valueListenable: timeInstance,
              builder: (context, value, _) {
                return Positioned(
                    top: 50,
                    left: 20,
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TimeScreen(breakout: breakout)));
              }),
          Positioned(
              bottom: 20,
              left: 20,
              child: IconButton(
                onPressed: () async {
                  scoreInstance.restScore();
                  final SharedPreferences ref =
                      await SharedPreferences.getInstance();
                  await ref.setInt('score', 0);
                  FlameAudio.bgm.stop();
                  timeInstance.resetZero();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_circle_left_rounded,
                  size: 70,
                  color: Colors.purple,
                ),
              )),
          Positioned(
              bottom: 20,
              right: 20,
              child: IconButton(
                onPressed: () async {
                  scoreInstance.restScore();
                  final SharedPreferences ref =
                      await SharedPreferences.getInstance();
                  await ref.setInt('score', 0);
                  FlameAudio.bgm.stop();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_circle_left_rounded,
                  size: 70,
                  color: Colors.purple,
                ),
              )),
          Positioned(
              bottom: 20,
              left: 140,
              child: IconButton(
                onPressed: () {
                  if (soundProvider.soundPlaying == false) {
                    FlameAudio.bgm.stop();
                    // soundProvider.setSoundOn();
                  } else {
                    FlameAudio.bgm.resume();
                  }
                },
                icon: Icon(
                  Icons.volume_mute_rounded,
                  size: 70,
                  color: Colors.purple,
                ),
              )),
        ]));
  }
}
