import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/bluelevel.dart';
import 'package:galoot/greenlevel.dart';
import 'package:galoot/level.dart';
import 'package:galoot/npc.dart';
import 'package:galoot/player.dart';
import 'package:galoot/redlevel.dart';

import 'loot.dart';

class BWLevel extends Level with CollisionCallbacks {
  BWLevel()
      : super(
          blackWhiteWorld,
          collection,
          Colors.white,
        );

  @override
  Future<void> onLoad() async {
    size = Vector2(20 * 16, 30 * 16);

    await super.onLoad();
    final grandpa = miscSprites['grandpa'];
    final treehouseTop = miscSprites['treehouse_top'];
    final treehouseBottom = miscSprites['treehouse_bottom'];
    final bone = miscSprites['bone'];
    if (bone != null) {
      add(Loot(sprite: bone, position: Vector2(5 * 16, 23 * 16)));
    }
    if (grandpa != null) {
      add(Grandpa(grandpa, position: Vector2(7 * 16, 8 * 16)));
    }
    if (treehouseTop != null && treehouseBottom != null) {
      add(
        SpriteComponent(
          sprite: treehouseTop,
          position: Vector2(5 * 16, 6 * 16),
        )..add(
            RectangleHitbox(size: Vector2(14, 14), position: Vector2(1, 1))
              ..collisionType = CollisionType.passive,
          ),
      );
      add(
        SpriteComponent(
          sprite: treehouseBottom,
          position: Vector2(5 * 16, 7 * 16),
        )..add(
            RectangleHitbox(size: Vector2(14, 14), position: Vector2(1, 1))
              ..collisionType = CollisionType.passive,
          ),
      );
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoint,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoint, other);

    if (!(other is Player)) {
      return;
    }
    if (other.position.y >= 29 * 16) {
      // south to blue
      removeFromParent();
      gameRef.changeLevel(BlueLevel(), Vector2(5 * 16, 0)); // Todo
    } else if (other.position.y <= 30 && other.position.x > 7 * 16) {
      // north to red
      removeFromParent();
      gameRef.changeLevel(RedLevel(), Vector2(8 * 16, 29 * 16)); // Todo
    } else if (other.position.x >= 19 * 16) {
      // east to green
      removeFromParent();
      final oldPlayerY = gameRef.player.position.y - 8;
      gameRef.changeLevel(GreenLevel(), Vector2(0, oldPlayerY)); // Todo

    }
  }
}
