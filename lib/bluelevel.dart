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
  BlueLevel(Vector2 initialPlayerPosition)
      : super(blueWorld, collection, Colors.blue, initialPlayerPosition);
  @override
  Future<void> onLoad() async {
    size = Vector2(10 * 16, 35 * 16);
    await super.onLoad();

    final dog = super.miscSprites['dog'];
    final yarn = super.miscSprites['yarn'];
    final fish = super.miscSprites['fish'];
    if (dog != null && gameRef.globs['dog_moved'] == false) {
      add(GuardDog(dog, color, position: Vector2(5 * 16, 29 * 16)));
    }
    if (fish != null && gameRef.globs['has_fish'] == false) {
      add(Fish(fish, color, position: Vector2(5 * 16, 33 * 16)));
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
