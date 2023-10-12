import 'package:emp_breakout/components/breakout_forge2d.dart';
import 'package:emp_breakout/components/paddle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/rendering.dart';
import 'package:flame/extensions.dart';

class Ball extends BodyComponent<BreakoutGame> with CollisionCallbacks {
  @override
  final Vector2 position;
  final double radius;

  Ball({required this.position, required this.radius});

  final _gradient = RadialGradient(
    center: Alignment.topLeft,
    colors: [
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 1.0).toColor(),
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.9).toColor(),
      const HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.4).toColor(),
    ],
    stops: const [0.0, 0.5, 1.0],
    radius: 0.95,
  );

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..type = BodyType.dynamic
      ..position = position;

    final ball = world.createBody(bodyDef);

    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 1.0
      ..density = 1.0;

    ball.createFixture(fixtureDef);
    return ball;
  }

  void reset() {
    body.setTransform(position, angle);
    body.angularVelocity = 0.0;
    body.linearVelocity = Vector2(80, 7900);
  }

  @override
  void render(Canvas canvas) {
    final circle = body.fixtures.first.shape as CircleShape;

    final paint = Paint()
      ..shader = _gradient.createShader(Rect.fromCircle(
        center: circle.position.toOffset(),
        radius: radius,
      ))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(circle.position.toOffset(), radius, paint);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Paddle) {
      FlameAudio.play('paddle-ball-collide.wav');
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is ScreenHitbox) {}
  }
}
