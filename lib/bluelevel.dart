import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/bwlevel.dart';
import 'package:galoot/level.dart';
import 'package:galoot/npc.dart';
import 'package:galoot/player.dart';

import 'loot.dart';

class BlueLevel extends Level with CollisionCallbacks {
  BlueLevel()
      : super(
          blueWorld,
          collection,
          Colors.blue,
        );
  @override
  Future<void> onLoad() async {
    size = Vector2(10 * 16, 35 * 16);
    await super.onLoad();

    final dog = super.miscSprites['dog'];
    final yarn = super.miscSprites['yarn'];
    if (dog != null) {
      add(GuardDog(dog, position: Vector2(5 * 16, 29 * 16)));
    }
    if (yarn != null) {
      add(Loot(sprite: yarn, position: Vector2(1 * 16 + 8, 33 * 16 + 8)));
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

    if (other.position.y <= 20) {
      // go north to BW
      removeFromParent();
      gameRef.changeLevel(BWLevel(), Vector2(10 * 16, 29 * 16)); // Todo
    }
  }
}
