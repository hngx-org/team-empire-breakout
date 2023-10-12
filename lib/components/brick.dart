import 'package:emp_breakout/components/breakout_forge2d.dart';
import 'package:emp_breakout/providers/valuenotifier.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'ball.dart';

class Brick extends BodyComponent<BreakoutGame> with ContactCallbacks {
  final Size size;
  @override
  final Vector2 position;
  final Color color;

  Brick({
    required this.size,
    required this.position,
    required this.color,
  });

  var destroy = false;

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      destroy = true;
      scoreInstance.value++;
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..type = BodyType.static
      ..position = position
      ..angularDamping = 1.0
      ..linearDamping = 1.0;

    final brickBody = world.createBody(bodyDef);

    final shape = PolygonShape()
      ..setAsBox(
        size.width / 2.0,
        size.height / 2.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    brickBody.createFixture(
      FixtureDef(shape)
        ..density = 100.0
        ..friction = 0.0
        ..restitution = 0.1,
    );

    return brickBody;
  }

  @override
  void render(Canvas canvas) {
    if (body.fixtures.isEmpty) {
      return;
    }

    final rectangle = body.fixtures.first.shape as PolygonShape;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromCenter(
          center: rectangle.centroid.toOffset(),
          width: size.width,
          height: size.height,
        ),
        paint);
  }
}
