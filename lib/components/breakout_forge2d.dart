import 'dart:developer';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';


import 'dart:math' as math;

import 'ball.dart';
import 'boundary.dart';

enum GameState {
  initializing,
  ready,
  running,
  paused,
  won,
  lost,
}

class BreakoutGame extends Forge2DGame with TapCallbacks {
  BreakoutGame() : super(gravity: Vector2.zero(), zoom: 10);

  late final Boundary _boundary;
  late final Ball _ball;

  GameState gameState = GameState.initializing;

  void Function(int score)? brickBrokenCallback;

  set scoreUpdatedCallback(void Function(int score) scoreUpdatedCallback) {}

  int score = 0;
  @override
  Future<void> onLoad() async {
    await _initializeGame();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (gameState == GameState.ready) {
      _ball.body.applyLinearImpulse(
          Vector2(-math.pow(10, 25).toDouble(), -math.pow(10, 25).toDouble()));
      gameState = GameState.running;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameState == GameState.lost || gameState == GameState.won) {
      pauseEngine();
    }
  }

  Future<void> resetGame() async {
    gameState = GameState.initializing;

    _ball.reset();

    gameState = GameState.ready;

    overlays.remove(overlays.activeOverlays.first);

    resumeEngine();
  }

  Future<void> _initializeGame() async {
    _boundary = Boundary();
    await add(_boundary);

    final ballPosition = Vector2(size.x / 2.0, size.y / 2.0 + 10.0);

    _ball = Ball(
      radius: 7,
      position: ballPosition,
    );
    await add(_ball);

    gameState = GameState.ready;
  }


}
