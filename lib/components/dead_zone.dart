import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flame/palette.dart';

import 'ball.dart';
import 'breakout_forge2d.dart';

class DeadZone extends RectangleComponent
    with HasGameRef<BreakoutGame>, CollisionCallbacks {
  final Paint redPaint = Paint()..color.red;

  DeadZone(position, size) {
    this.position = position;
    width = size.width;
    height = size.height;


  }
  @override
  FutureOr<void> onLoad() {
    final deadZoneHitbox = RectangleHitbox(
      size: size,
    );

    add(deadZoneHitbox);
    return super.onLoad();
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Ball) {
      // gameRef.gameState = GameState.lost;

    }
  }





}

