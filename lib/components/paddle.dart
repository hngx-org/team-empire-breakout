import 'package:emp_breakout/components/breakout_forge2d.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/rendering.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'dart:math' as math;






import 'ball.dart';

class Paddle extends BodyComponent<BreakoutGame>
    with DragCallbacks, HasGameRef<BreakoutGame> , ContactCallbacks {
  final Size size;
  final BodyComponent ground;
  @override
  final Vector2 position;

  Paddle({
    required this.size,
    required this.ground,
    required this.position,
  });

  MouseJoint? _mouseJoint;
  Vector2 dragStartPosition = Vector2.zero();
  Vector2 dragAccumlativePosition = Vector2.zero();

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..type = BodyType.dynamic
      ..position = position
      ..fixedRotation = true
      ..angularDamping = 1.0
      ..linearDamping = 10.0;

    final paddleBody = world.createBody(bodyDef);

    final shape = PolygonShape()
      ..setAsBox(
        size.width / 2.0,
        size.height / 1.0,
        Vector2(0.0, 0.0),
        0.0,
      );

    paddleBody.createFixture(FixtureDef(shape)
      ..density = 100.0
      ..friction = 0.0
      ..restitution = 1.0);

    return paddleBody;
  }

  void reset() {
    body.setTransform(position, angle);
    body.angularVelocity = 0.0;
    body.linearVelocity = Vector2.zero();
  }

  @override
  void onMount() {
    super.onMount();

    final worldAxis = Vector2(1.0, 0.0);

    final travelExtent = (gameRef.size.x / 2) - (size.width / 2.0);

    final jointDef = PrismaticJointDef()
      ..enableLimit = true
      ..lowerTranslation = -travelExtent
      ..upperTranslation = travelExtent
      ..collideConnected = true;
     FlameAudio.play('paddle-ball-collide.wav');
    jointDef.initialize(body, ground.body, body.worldCenter, worldAxis);
    final joint = PrismaticJoint(jointDef);
    world.createJoint(joint);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_mouseJoint != null) {
      return;
    }
    dragStartPosition = event.devicePosition;
    FlameAudio.play('move-paddle.wav');
    _setupDragControls();

    return;
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    dragAccumlativePosition += event.delta;
    if ((dragAccumlativePosition - dragStartPosition).length > 0.1) {
      _mouseJoint?.setTarget(dragAccumlativePosition);
      dragStartPosition = dragAccumlativePosition;
    }

    // Don't continue passing the event.
    return false;
  }

  @override
  bool onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _resetDragControls();

    return false;
  }

  @override
  bool onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _resetDragControls();

    return false;
  }



  void _setupDragControls() {
    final mouseJointDef = MouseJointDef()
      ..bodyA = ground.body
      ..bodyB = body
      ..frequencyHz = 1.0
      ..dampingRatio = 0.9
      ..collideConnected = false
      ..maxForce = 2000.0 * body.mass;

    _mouseJoint = MouseJoint(mouseJointDef);
    world.createJoint(_mouseJoint!);
  }

  void _resetDragControls() {
    dragAccumlativePosition = Vector2.zero();
    if (_mouseJoint != null) {
      world.destroyJoint(_mouseJoint!);
      _mouseJoint = null;
    }
  }

  @override
  void render(Canvas canvas) {
    final shape = body.fixtures.first.shape as PolygonShape;

    final paint = Paint()
      ..color = const Color.fromARGB(255, 25, 105, 255)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        Rect.fromLTRB(
          shape.vertices[0].x,
          shape.vertices[0].y,
          shape.vertices[2].x,
          shape.vertices[2].y,
        ),
        paint);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      FlameAudio.play('paddle-ball-collide.wav');
      final Vector2 impulse = Vector2(-math.pow(10, -25).toDouble(), -math.pow(- ut10, 25).toDouble()); // Adjust the values as needed

      other.applyForce2(impulse);
    }
  }
}
