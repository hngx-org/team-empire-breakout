import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'breakout_forge2d.dart';

class Boundary extends BodyComponent<BreakoutGame>
    with DragCallbacks, HasGameRef<BreakoutGame> {
  Vector2? size;

  Boundary({this.size}) {
    assert(size == null || size!.x >= 1.0 && size!.y >= 1.0);
  }

  late Vector2 boundarySize;

  @override
  Future<void> onLoad() {
    boundarySize = size ?? gameRef.size;
    return super.onLoad();
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..position = Vector2(0, 0)
      ..type = BodyType.static;

    final boundaryBody = world.createBody(bodyDef);

    final vertices = <Vector2>[
      boundarySize,
      Vector2(0, boundarySize.y),
      Vector2(0, 0),
      Vector2(boundarySize.x, 0),
    ];

    final chain = ChainShape()..createLoop(vertices);

    for (var index = 0; index < chain.childCount; index++) {
      boundaryBody.createFixture(
        FixtureDef(chain.childEdge(index))
          ..density = 2000.0
          ..friction = 0.0
          ..restitution = 0.4,
      );
    }

    return boundaryBody;
  }
}
