import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/main.dart';
import 'package:galoot/player.dart';
import 'package:galoot/npc.dart';
import 'package:galoot/level.dart';
import 'package:galoot/bwlevel.dart';

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
    final yarn = super.miscSprites['yarn'];

    super.onLoad();
    if (yarn != null) {
      add(Yarn(yarn, Colors.green,
          position: Vector2(15 * 16 + 8, 12 * 16 + 8)));
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoint,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoint, other);
    print("bwlevel collision");

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
