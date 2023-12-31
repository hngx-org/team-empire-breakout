// import 'package:emp_breakout/components/breakout_forge2d.dart';
// import 'package:emp_breakout/providers/levels_provider.dart';
// import 'package:flame_audio/flame_audio.dart';
// import 'package:flutter/material.dart';
// import 'package:flame/components.dart';
// import 'package:provider/provider.dart';
//
// import 'brick.dart';
//
// class BrickWall extends Component with HasGameRef<BreakoutGame> {
//   late List<Brick> bricks;
//   void Function()? brickBrokenCallback;
//   int pointValue = 10;
//   final Vector2 position;
//   final Size? size;
//   final int rows;
//   final int columns;
//   final double gap;
//   void breakBrick(Brick brick) {
//     bricks.remove(brick);
//
//     brickBrokenCallback?.call();
//   }
//
//   BrickWall({
//     Vector2? position,
//     this.size,
//     int? rows,
//     int? columns,
//     double? gap,
//     required void Function() brickBrokenCallback,
//   })  : position = position ?? Vector2.zero(),
//         rows = rows ?? 1,
//         columns = columns ?? 1,
//         gap = gap ?? 0.4;
//
//   late final List<Color> _colors;
//
//   static const transparency = 1.0;
//   static const saturation = 0.85;
//   static const lightness = 0.5;
//
//   List<Color> _colorSet(int count) => List<Color>.generate(
//         count,
//         (int index) => HSLColor.fromAHSL(
//           transparency,
//           index / count * 360.0,
//           saturation,
//           lightness,
//         ).toColor(),
//         growable: false,
//       );
//
//   @override
//   Future<void> onLoad() async {
//     _colors = _colorSet(rows);
//     await _buildWall();
//   }
//
//   Future<void> reset() async {
//     removeAll(children);
//     await _buildWall();
//   }
//
//   @override
//   void update(double dt) {
//     for (final child in [...children]) {
//       if (child is Brick && child.destroy) {
//         for (final fixture in [...child.body.fixtures]) {
//           child.body.destroyFixture(fixture);
//         }
//         FlameAudio.play('collide.wav');
//
//         gameRef.world.destroyBody(child.body);
//         remove(child);
//       }
//     }
//
//     if (children.isEmpty) {
//       gameRef.gameState = GameState.won;
//     }
//
//     super.update(dt);
//   }
//
//   Future<void> _buildWall() async {
//     final wallSize = size ??
//         Size(
//           gameRef.size.x,
//           gameRef.size.y * 0.25,
//         );
//
//     final brickSize = Size(
//       ((wallSize.width - gap * 2.0) - (columns - 1) * gap) / columns,
//       (wallSize.height - (rows - 1) * gap) / rows,
//     );
//
//     var brickPosition = Vector2(
//       brickSize.width / 2.0 + gap,
//       brickSize.height / 2.0 + position.y,
//     );
//
//     for (var i = 0; i < rows; i++) {
//       for (var j = 0; j < columns; j++) {
//         await add(Brick(
//           size: brickSize,
//           position: brickPosition,
//           color: _colors[i],
//         ));
//         brickPosition += Vector2(brickSize.width + gap, 0.0);
//       }
//       brickPosition += Vector2(
//         (brickSize.width / 2.0 + gap) - brickPosition.x,
//         brickSize.height + gap,
//       );
//     }
//   }
// }
