import 'dart:async';
import 'dart:ui';

import 'package:emp_breakout/components/paddle.dart';
import 'package:emp_breakout/components/timer.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../providers/valuenotifier.dart';
import 'ball.dart';
import 'brick.dart';
import 'countdown_text.dart';
import 'dead_zone.dart';
import 'levels.dart';
import 'my_text_button.dart';

enum GameState {
  initializing,
  ready,
  running,
  paused,
  won,
  lost,
}

class BreakoutGame extends FlameGame
    with HasCollisionDetection, DragCallbacks, TapCallbacks {
  int failedCount = kGameTryCount;

  bool get isCleared => children.whereType<Brick>().isEmpty;
  GameState gameState = GameState.initializing;
  int score = 0;
  late final DeadZone _deadZone;
  late final Ball _ball;
  late final Paddle _paddle;

  bool get isGameOver => failedCount == 0;

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache.loadAll([
      'audio1.wav',
      'collide.wav',
      'constant.wav',
      'move-paddle.wav',
      'paddle-ball-collide.wav'
    ]);

    FlameAudio.bgm.initialize();
    _paddle = Paddle(draggingPaddle: draggingPaddle);
    final paddleSize = _paddle.size;
    _paddle
      ..position.x = size.x / 2 - paddleSize.x / 2
      ..position.y = size.y - paddleSize.y - kPaddleStartY - 100;

    await addMyTextButton('Start!');
    final deadZoneSize = Size(size.x, size.y * 0.02);
    final deadZonePosition = Vector2(
      0,
      size.y - ((size.y * 0.1) / 2.0) - 100,
    );

    _deadZone = DeadZone(
      deadZonePosition,
      deadZoneSize,
    );
    await add(_deadZone);
    await addAll(
      [
        ScreenHitbox(),
        _paddle,
      ],
    );
    await resetBlocks();
    gameState = GameState.ready;
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

  void incrementScore() {
    score++; // Increment the score
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

  Future<void> nextLevel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? level = prefs.getInt("level");
    level = level! + 1;
    prefs.setInt("level", level);
  }

  Future<void> resetBall(int index) async {
    Ball _ball = Ball(Level.radius);
    gameState = GameState.running;

    _ball.position
      ..x = size.x / 2
      ..y = size.y / 2;
    await add(_ball);
  }

  Future<void> resetBlocks() async {
    int rows = await Level.getRows();
    int cols = await Level.getColumn();
    children.whereType<Brick>().forEach((block) {
      block.removeFromParent();
    });

    final sizeX =
        (size.x - kBlocksStartXPosition * 2 - kBlockPadding * rows) / rows;

    final sizeY = (size.y * kBlocksHeightRatio -
            kBlocksStartYPosition -
            kBlockPadding * (cols - 1)) /
        cols;

    final blocks = List<Brick>.generate(cols * rows, (int index) {
      final block = Brick(
        blockSize: Vector2(sizeX, sizeY),
        onBlockRemove: onBlockRemove,
      );

      final indexX = index % rows;
      final indexY = index ~/ rows;

      block.position
        ..x = kBlocksStartXPosition + indexX * (block.size.x + kBlockPadding)
        ..y = kBlocksStartYPosition + indexY * (block.size.y + kBlockPadding);

      return block;
    });

    await addAll(blocks);
  }

  Future<void> addMyTextButton(String text) async {
    final myTextButton = MyTextButton(
      text,
      onTapDownMyTextButton: onTapDownMyTextButton,
      renderMyTextButton: renderMyTextButton,
    );

    myTextButton.position
      ..x = size.x / 2 - myTextButton.size.x / 2
      ..y = size.y / 2 - myTextButton.size.y / 2;

    await add(myTextButton);
  }

  Future<void> onBallRemove() async {
    if (!isCleared) {
      failedCount--;
      if (isGameOver ||
          gameState == GameState.won ||
          gameState == GameState.lost) {
        await addMyTextButton('Game Over!');
      } else {
        await addMyTextButton('Retry');
      }
    }
  }

  Future<void> onBlockRemove() async {
    if (isCleared) {
      await addMyTextButton('Clear!');
      children.whereType<Ball>().forEach((ball) {
        ball.removeFromParent();
      });
    }
  }

  void draggingPaddle(DragUpdateEvent event) {
    final paddle = children.whereType<Paddle>().first;

    paddle.position.x += event.delta.x;

    if (paddle.position.x < 0) {
      paddle.position.x = 0;
    }
    if (paddle.position.x > size.x - paddle.size.x) {
      paddle.position.x = size.x - paddle.size.x;
    }
  }

  Future<void> resetGame() async {
    gameState = GameState.initializing;
    overlays.remove(overlays.activeOverlays.first);
    await resetBlocks();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("score", 0);
    scoreInstance.restScore();

    // int i;
    int balls = await Level.getBalls();
    for (int i = 1; i < balls + 1; i++) {
      await resetBall(i);
    }
    gameState = GameState.ready;
    // overlays.add('PreGame');

    resumeEngine();
  }

  Future<void> onTapDownMyTextButton() async {
    children.whereType<MyTextButton>().forEach((button) {
      button.removeFromParent();
    });
    gameState = GameState.ready;

    // overlays.remove(overlays.activeOverlays.first);
    // overlays.add('PreGame');

    // if (isCleared || isGameOver || gameState == GameState.lost) {
    //   await resetBlocks();
    //   failedCount = kGameTryCount;
    // }
    // await resetBlocks();
    // await resetBall();
    await countdown();
    int balls = await Level.getBalls();
    for (int i = 1; i < balls + 1; i++) {
      print(">>>>>ball $i");
      await resetBall(i);
    }
    FlameAudio.bgm.play('constant.wav');
  }

  void renderMyTextButton(Canvas canvas) {
    final myTextButton = children.whereType<MyTextButton>().first;
    final rect = Rect.fromLTWH(
      0,
      0,
      myTextButton.size.x,
      myTextButton.size.y,
    );
    final bgPaint = Paint()
      ..color = isGameOver ? kGameOverButtonColor : kButtonColor;
    canvas.drawRect(rect, bgPaint);
  }

  Future<void> countdown() async {
    for (var i = kCountdownDuration; i > 0; i--) {
      final countdownText = CountdownText(count: i);

      countdownText.position
        ..x = size.x / 2 - countdownText.size.x / 2
        ..y = size.y / 2 - countdownText.size.y / 2;

      await add(countdownText);

      await Future<void>.delayed(const Duration(seconds: 1));
    }
    timeInstance.startTimer(await Level.getTime());
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);

    // await FlameAudio.audioCache.clearAll();

    if (isCleared) {
      gameState = GameState.won;
      pauseEngine();
      overlays.add('PostGame');

      // children.whereType<Ball>().forEach((ball) {
      //   ball.removeFromParent();
      // });
      FlameAudio.bgm.stop();
      FlameAudio.play('audio1.wav');
    }
    if (gameState == GameState.lost) {
      pauseEngine();
      overlays.add('PostGame');
      FlameAudio.bgm.stop();
      FlameAudio.play('audio1.wav');
    }
    if (isGameOver) {
      await resetBlocks();
      failedCount = kGameTryCount;
      await resetBall(2);
    }
    if (gameState == GameState.initializing) {
      await resetBlocks();
      failedCount = kGameTryCount;
      await resetBall(2);
    }
  }
}
