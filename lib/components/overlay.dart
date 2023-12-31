import 'package:emp_breakout/components/timer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/game_screen.dart';
import 'breakout_forge2d.dart';

class OverlayBuilder {
  OverlayBuilder._();
  //
  // static Widget preGame(BuildContext context, BreakoutGame game) {
  //   return const PreGameOverlay();
  // }

  static Widget postGame(BuildContext context, BreakoutGame game) {
    assert(game.gameState == GameState.lost || game.gameState == GameState.won);

    final message = game.gameState == GameState.won ? 'Winner!' : 'Game Over';
    return PostGameOverlay(message: message, game: game);
  }

  static Widget pauseGame(BuildContext context, BreakoutGame game) {
    assert(game.gameState == GameState.paused);

    final message = game.gameState == GameState.paused ? 'Resume' : 'Pause';
    return PauseGameOverlay(message: message, game: game);
  }
}

class PreGameOverlay extends StatelessWidget {
  const PreGameOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 600),
            Center(
              child: Text(
                'Tap to begin',
                style: TextStyle(
                    color: Colors.white, fontSize: 30, fontFamily: 'Pacifico'),
              ),
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}

class PostGameOverlay extends StatelessWidget {
  final String message;
  final BreakoutGame game;

  const PostGameOverlay({
    super.key,
    required this.message,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green.withOpacity(0.7)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(
                  color: Colors.white, fontSize: 30, fontFamily: "Pacifico"),
            ),
            const SizedBox(height: 24),
            _resetButton(context, game),
          ],
        ),
      ),
    );
  }

  Widget _resetButton(BuildContext context, BreakoutGame game) {
    return (game.gameState == GameState.won)
        ? IconButton(
            onPressed: () async {
              game.nextLevel();

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainGameScreen()));
            },
            icon: Icon(
              Icons.next_plan_outlined,
              size: 70,
              color: Colors.purple,
            ))
        : IconButton(
            onPressed: () {
              game.resetGame();
              timeInstance.resetTimer();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainGameScreen()));
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => MainGameScreen()));
            },
            icon: Icon(
              Icons.replay,
              size: 70,
              color: Colors.purple,
            ),
          );
  }
}

class PauseGameOverlay extends StatelessWidget {
  final String message;
  final BreakoutGame game;

  const PauseGameOverlay({
    super.key,
    required this.message,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green.withOpacity(0.7)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Pacifico',
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 24),
            _resetButton2(context, game),
          ],
        ),
      ),
    );
  }

  Widget _resetButton2(BuildContext context, BreakoutGame game) {
    return IconButton(
      onPressed: () => game.resumeGame(),
      icon: Icon(
        Icons.play_circle,
        size: 70,
        color: Colors.purple,
      ),
    );
  }
}

Widget pauseGame(BuildContext context, BreakoutGame game) {
  return IconButton(
    onPressed: () => game.pauseGame(),
    icon: Icon(
      Icons.pause_circle,
      size: 70,
      color: Colors.purple,
    ),
  );
}
