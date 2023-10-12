import 'dart:developer';
import 'dart:ui';

import 'package:emp_breakout/components/brick_wall.dart';
import 'package:emp_breakout/components/dead_zone.dart';
import 'package:emp_breakout/components/paddle.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
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

class BreakoutGame extends Forge2DGame
    with TapCallbacks, HasCollisionDetection {
  BreakoutGame() : super(gravity: Vector2.zero(), zoom: 10);

  late final Boundary _boundary;
  late final Ball _ball;
  late final Paddle _paddle;
  late final DeadZone _deadZone;
  late final BrickWall _brickWall;
  late final Image background;

  GameState gameState = GameState.initializing;

  void Function(int score)? brickBrokenCallback;

  set scoreUpdatedCallback(void Function(int score) scoreUpdatedCallback) {}
  late AudioPool pool;

  int score = 0;
  @override
  Future<void> onLoad() async {
    // background = await images.load('assets/images/background.png');
    pool = await FlameAudio.createPool(
      'audio1.wav',
      minPlayers: 3,
      maxPlayers: 4,
    );
    await FlameAudio.audioCache.loadAll([
      'audio1.wav',
      'collide.wav',
      'constant.wav',
      'move-paddle.wav',
      'paddle-ball-collide.wav'
    ]);

    FlameAudio.bgm.initialize();
    // FlameAudio.play('audio1.wav');

    await _initializeGame();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (gameState == GameState.ready) {
      overlays.remove('PreGame');
      _ball.body.applyLinearImpulse(
          Vector2(-math.pow(10, 25).toDouble(), -math.pow(10, 25).toDouble()));
      gameState = GameState.running;
      FlameAudio.bgm.play('constant.wav');
    }
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    // await FlameAudio.audioCache.clearAll();

    if (gameState == GameState.lost || gameState == GameState.won) {
      pauseEngine();
      overlays.add('PostGame');
      FlameAudio.bgm.stop();
      FlameAudio.play('audio1.wav');
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

  void pauseGame() {
    super.pauseEngine();
    gameState = GameState.paused;
    FlameAudio.bgm.pause();
    if (gameState == GameState.paused) {
      // gameState = GameState.paused;
      overlays.add('PauseGame');
    }
  }

  void resumeGame() {
    super.resumeEngine();
    FlameAudio.bgm.resume();

    if (gameState == GameState.paused) {
      gameState = GameState.ready;
      gameState = GameState.running;
      overlays.remove('PauseGame');
    }
  }

  Future<void> _initializeGame() async {
    // FlameAudio.loop('audio1.wav');

    _boundary = Boundary();
    await add(_boundary);

    final brickWallPosition = Vector2(0.0, size.y * 0.075);

    _brickWall = BrickWall(
      position: brickWallPosition,
      rows: 2,
      columns: 3,
      brickBrokenCallback: incrementScore,
    );
    await add(_brickWall);

    final deadZoneSize = Size(size.x, size.y * 0.1);
    final deadZonePosition = Vector2(
      size.x / 2.0,
      size.y - ((size.y * 0.1) / 2.0) - 80,
    );

    _deadZone = DeadZone(
      size: deadZoneSize,
      position: deadZonePosition,
    );
    await add(_deadZone);

    const paddleSize = Size(80, 8);
    final paddlePosition = Vector2(
      size.x / 2.0,
      size.y - (deadZoneSize.height - paddleSize.height / 2.0 + 100),
    );

    _paddle = Paddle(
      size: paddleSize,
      ground: _boundary,
      position: paddlePosition,
    );
    await add(_paddle);

    final ballPosition = Vector2(size.x / 2.0, size.y / 2.0 + 10.0);

    _ball = Ball(
      radius: 50,
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
