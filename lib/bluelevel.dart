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

class BlueLevel extends Level with CollisionCallbacks {
  BlueLevel(Vector2 initialPlayerPosition)
      : super(blueWorld, collection, Colors.blue, initialPlayerPosition);
  @override
  Future<void> onLoad() async {
    size = Vector2(10 * 16, 35 * 16);
    super.onLoad();
    add(GuardDog(position: Vector2(5 * 16, 29 * 16)));
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

    if (other.position.y <= 20) {
      // go north to BW
      removeFromParent();
      gameRef.changeLevel(BWLevel(Vector2(8 * 16, 29 * 16))); // Todo
    }
  }
}
