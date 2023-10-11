import 'dart:developer';
import 'dart:ui';

import 'package:emp_breakout/components/brick_wall.dart';
import 'package:emp_breakout/components/dead_zone.dart';
import 'package:emp_breakout/components/paddle.dart';
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
  late final Paddle _paddle;
  late final DeadZone _deadZone;
  late final BrickWall _brickWall;

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
    log('tap dowm');
    if (gameState == GameState.ready) {
      overlays.remove('PreGame');
      _ball.body.applyLinearImpulse(
          Vector2(-math.pow(10, 25).toDouble(), -math.pow(10, 25).toDouble()));
      log('game readd');
      gameState = GameState.running;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameState == GameState.lost || gameState == GameState.won) {
      pauseEngine();
      overlays.add('PostGame');
    }
  }

  Future<void> resetGame() async {
    gameState = GameState.initializing;

    _ball.reset();
    _paddle.reset();
    await _brickWall.reset();

    gameState = GameState.ready;

    overlays.remove(overlays.activeOverlays.first);
    overlays.add('PreGame');

    resumeEngine();
  }

  Future<void> _initializeGame() async {
    _boundary = Boundary();
    await add(_boundary);

    final brickWallPosition = Vector2(0.0, size.y * 0.075);

    _brickWall = BrickWall(
      position: brickWallPosition,
      rows: 8,
      columns: 6,
      brickBrokenCallback: incrementScore,
    );
    await add(_brickWall);

    final deadZoneSize = Size(size.x, size.y * 0.1);
    final deadZonePosition = Vector2(
      size.x / 2.0,
      size.y - (size.y * 0.1) / 2.0,
    );

    _deadZone = DeadZone(
      size: deadZoneSize,
      position: deadZonePosition,
    );
    await add(_deadZone);

    const paddleSize = Size(80, 8);
    final paddlePosition = Vector2(
      size.x / 2.0,
      size.y - deadZoneSize.height - paddleSize.height / 2.0,
    );

    _paddle = Paddle(
      size: paddleSize,
      ground: _boundary,
      position: paddlePosition,
    );
    await add(_paddle);

    final ballPosition = Vector2(size.x / 2.0, size.y / 2.0 + 10.0);

    _ball = Ball(
      radius: 7,
      position: ballPosition,
    );
    await add(_ball);

    gameState = GameState.ready;
    overlays.add('PreGame');
  }

  void incrementScore() {
    score++; // Increment the score
    brickBrokenCallback?.call(score);
  }
}
