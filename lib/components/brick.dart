import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../constants/constants.dart';
import 'ball.dart';

class Brick extends SpriteComponent with CollisionCallbacks {
  Brick({required this.blockSize, required this.onBlockRemove, required this.index})
      : super(

    // size: blockSize,
    // paint: Paint()
    //   ..color = kBlockColors[Random().nextInt(kBlockColors.length)],
  );
  final int index;
  final Vector2 blockSize;
  final Future<void> Function() onBlockRemove;

  @override
  Future<void>? onLoad() async {
    if (index % 9 == 0){
      sprite = await Sprite.load("purple_brick_sprite.png");

    }else{
      sprite = await Sprite.load("red_brick_sprite.png");

    }

    final blockHitbox = RectangleHitbox(
      size: size,
    );

    await add(blockHitbox);

    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    if (other is Ball) {
      removeFromParent();
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  Future<void> onRemove() async {
    await onBlockRemove();
    super.onRemove();
  }
}
