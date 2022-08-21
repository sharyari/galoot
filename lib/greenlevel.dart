import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/bwlevel.dart';
import 'package:galoot/level.dart';
import 'package:galoot/npc.dart';
import 'package:galoot/player.dart';

class GreenLevel extends Level with CollisionCallbacks {
  GreenLevel(Vector2 initialPlayerPosition)
      : super(
          greenWorld,
          collection,
          Colors.green,
          initialPlayerPosition,
        );
  @override
  Future<void> onLoad() async {
    size = Vector2(20 * 16, 30 * 16);
    await super.onLoad();
    final yarn = super.miscSprites['yarn'];

    if (yarn != null && gameRef.globs['has_green_yarn'] == false) {
      add(Yarn(yarn, Colors.green,
          position: Vector2(12 * 16 + 8, 12 * 16 + 8)));
    }
    final trashcan = miscSprites['trashcan'];
    if (trashcan != null) {
      add(Trashcan(trashcan, color, position: Vector2(10 * 16, 16 * 24)));
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

    if (other.position.x < 16) {
      // west to BW
      final oldPlayerY = gameRef.player.position.y - 8;
      removeFromParent();
      gameRef.changeLevel(BWLevel(Vector2(19 * 16, oldPlayerY)));
    }
  }
}
