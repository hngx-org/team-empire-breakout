import 'dart:math';
import 'dart:ui';

import 'package:emp_breakout/components/timer.dart';
import 'package:flame/collisions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../../constants/constants.dart';
// import 'block.dart' as b;
import '../providers/valuenotifier.dart';
import 'breakout_forge2d.dart';
import 'brick.dart';
import 'dead_zone.dart';
import 'levels.dart';
import 'paddle.dart';

class Ball extends SpriteComponent
    with HasGameRef<BreakoutGame>, CollisionCallbacks {
  // final double radius;

  Ball(
    // this.radius,
  ) {
    // radius = radius;
    paint = Paint()..color = kBallColor;
    final vx = -kBallSpeed * cos(spawnAngle * kRad);
    final vy = -kBallSpeed * sin(spawnAngle * kRad);
    velocity = Vector2(vx, vy);
  }
  late Vector2 velocity;
  late final _hitbox;
  bool isCollidedScreenHitboxX = false;
  bool isCollidedScreenHitboxY = false;

  // final Future<void> Function() onBallRemove;

  double get spawnAngle {
    final random = Random().nextDouble();
    final spawnAngle =
        lerpDouble(kBallMinSpawnAngle, kBallMaxSpawnAngle, random)!;
    return spawnAngle;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('ball_pink_sprite.png');

    _hitbox = CircleHitbox(radius: 20);

    await add(_hitbox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += velocity * dt;
    final screenSize = gameRef.size;
    final playerSize = _hitbox.size;

    // Calculate the min and max positions for both X and Y axes
    final minX = playerSize.x / 2;
    final maxX = screenSize.x - playerSize.x / 2;
    final minY = playerSize.y / 2;
    final maxY = screenSize.y - playerSize.y / 2;

    // Clamp the player's position within the screen boundaries
    position
      ..x = position.x.clamp(minX, maxX).toDouble()
      ..y = position.y.clamp(minY, maxY).toDouble();
    if (position.x <= minX || position.x >= maxX) {
      // Reverse the horizontal velocity to make the ball bounce off
      velocity.x = -velocity.x;
    }

// Check if the ball hits the Y-axis clamp boundaries
    if (position.y <= minY || position.y >= maxY) {
      // Reverse the vertical velocity to make the ball bounce off
      velocity.y = -velocity.y;
    }
    super.update(dt);
  }

  Future<void> resetBall() async {
    position
      ..x = size.x / 2
      ..y = size.y / 2;
  }

  @override
  Future<void> onRemove() async {
    // await onBallRemove();
    super.onRemove();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    final collisionPoint = intersectionPoints.first;
    if (other is Brick) {
      final blockRect = other.toAbsoluteRect();
      FlameAudio.play('collide.wav');
      Brick o = other;
      if (o.index % 9 == 0){
        // scoreInstance.incrementScore(5);
        timeInstance.increaseTimer(4);

      }else{
        timeInstance.increaseTimer(0);
      }
      scoreInstance.incrementScore(1);

      // for (final point in intersectionPoints) {
      //   // if (point.x == brickHitbox.left ) {
      //   //   velocity.x = -velocity.x;
      //   // }
      //   // if (point.x == brickHitbox.right ) {
      //   //   velocity.x = -velocity.x;
      //   //
      //   // }
      //   // if (point.y == brickHitbox.top ) {
      //   //   velocity.y = -velocity.y;
      //   // }
      //   if (point.y == brickHitbox.bottom)  {
      //     velocity.y = -velocity.y;
      //   }

      updateBallTrajectory(collisionPoint, blockRect);
    }

    if (other is Paddle) {
      final paddleRect = other.toAbsoluteRect();
      FlameAudio.play('paddle-ball-collide.wav');

      updateBallTrajectory(collisionPoint, paddleRect);
    }
    if (other is ScreenHitbox) {
      final screenHitBox = other.toAbsoluteRect();
      FlameAudio.play('paddle-ball-collide.wav');

      updateBallTrajectory(collisionPoint, screenHitBox);
    }

    if (other is DeadZone || timeInstance.value == 0) {
      gameRef.gameState = GameState.lost;
      timeInstance.cancelTimer();
      final deadZoneBoxRect = other.toAbsoluteRect();
      for (final point in intersectionPoints) {
        if (point.x == deadZoneBoxRect.top) {
          // velocity.x = -velocity.x;
          // isCollidedScreenHitboxX = true;

          print("collided with deadzone");
          // game.gameState = GameState.lost;
          // gameRef.gameState = GameState.lost;
          FlameAudio.play('audio1.wav');
        }
      }
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  // @override
  // void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  //   if (other is ScreenHitbox) {
  //     final screenHitBoxRect = other.toAbsoluteRect();
  //     FlameAudio.play('paddle-ball-collide.wav');
  //
  //     // for (final point in intersectionPoints) {
  //     //   if (point.x == screenHitBoxRect.left && !isCollidedScreenHitboxX) {
  //     //     velocity.x = -velocity.x;
  //     //     isCollidedScreenHitboxX = true;
  //     //   }
  //     //   if (point.x == screenHitBoxRect.right && !isCollidedScreenHitboxX) {
  //     //     velocity.x = -velocity.x;
  //     //     // isCollidedScreenHitboxX = true;
  //     //   }
  //     //   if (point.y == screenHitBoxRect.top && !isCollidedScreenHitboxY) {
  //     //     velocity.y = -velocity.y;
  //     //     isCollidedScreenHitboxY = true;
  //     //   }
  //     //   if (point.y == screenHitBoxRect.bottom && !isCollidedScreenHitboxY) {
  //     //     velocity.y = -velocity.y;
  //     //     // isCollidedScreenHitboxY = true;
  //     //
  //     //   }
  //    // }
  //   }else if (other is DeadZone){
  //     final deadZoneBoxRect = other.toAbsoluteRect();
  //     for (final point in intersectionPoints) {
  //       if (point.x == deadZoneBoxRect.top ) {
  //         velocity.x = -velocity.x;
  //         isCollidedScreenHitboxX = true;
  //
  //         print("collided with deadzone");
  //         game.gameState = GameState.lost;
  //         gameRef.gameState = GameState.lost;
  //         FlameAudio.play('audio1.wav');
  //       }}
  //   } else if (other is Brick){
  //     FlameAudio.play('collide.wav');
  //
  //     final brickHitbox = other.toAbsoluteRect();
  //     scoreInstance.incrementScore();
  //     for (final point in intersectionPoints) {
  //       // if (point.x == brickHitbox.left ) {
  //       //   velocity.x = -velocity.x;
  //       // }
  //       // if (point.x == brickHitbox.right ) {
  //       //   velocity.x = -velocity.x;
  //       //
  //       // }
  //       // if (point.y == brickHitbox.top ) {
  //       //   velocity.y = -velocity.y;
  //       // }
  //       if (point.y == brickHitbox.bottom)  {
  //         velocity.y = -velocity.y;
  //       }
  //     }
  //   }
  //   super.onCollision(intersectionPoints, other);
  // }

  @override
  void onCollisionEnd(PositionComponent other) {
    isCollidedScreenHitboxX = false;
    isCollidedScreenHitboxY = false;
    super.onCollisionEnd(other);
  }

  void updateBallTrajectory(
    Vector2 collisionPoint,
    Rect rect,
  ) {
    final isLeftHit = collisionPoint.x == rect.left;
    final isRightHit = collisionPoint.x == rect.right;
    final isTopHit = collisionPoint.y == rect.top;
    final isBottomHit = collisionPoint.y == rect.bottom;

    final isLeftOrRightHit = isLeftHit || isRightHit;
    final isTopOrBottomHit = isTopHit || isBottomHit;

    if (isLeftOrRightHit) {
      if (isRightHit && velocity.y > 0) {
        print("hiiiii right hit down");
        velocity.x -= kBallNudgeSpeed;
        return;
      } else {
        print("hiiiii right hit up");
        velocity.x += kBallNudgeSpeed;
      }

      if (isLeftHit && velocity.x < 0) {
        velocity.x += kBallNudgeSpeed;
        print("hiiiii left hit up");

        return;
      } else {
        velocity.x -= kBallNudgeSpeed;
        print("hiiiii left hit down");
      }

      velocity.x = -velocity.x;
      return;
    }

    if (isTopOrBottomHit) {
      velocity.y = -velocity.y;
      if (Random().nextInt(kBallRandomNumber) % kBallRandomNumber == 0) {
        velocity.x += kBallNudgeSpeed;
      }
    }
  }
}
