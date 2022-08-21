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

class RedLevel extends Level with CollisionCallbacks {
  RedLevel()
      : super(
          redWorld,
          collection,
          Colors.red,
        );
  @override
  Future<void> onLoad() async {
    size = Vector2(20 * 16, 30 * 16);
    super.onLoad();
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
      // south to BW
      final oldPlayerX = gameRef.player.position.x - 8;
      removeFromParent();
      gameRef.changeLevel(BWLevel(), Vector2(oldPlayerX, 0));
    }
  }
}
