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
import 'package:galoot/redlevel.dart';
import 'package:galoot/greenlevel.dart';
import 'package:galoot/bluelevel.dart';

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
