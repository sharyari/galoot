import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/bluelevel.dart';
import 'package:galoot/greenlevel.dart';
import 'package:galoot/level.dart';
import 'package:galoot/npc.dart';
import 'package:galoot/ovaloffice.dart';
import 'package:galoot/player.dart';
import 'package:galoot/redlevel.dart';
import 'package:galoot/textprompt.dart';

import 'objects.dart';

class BWLevel extends Level with CollisionCallbacks {
  late Objects riverTile;
  BWLevel(Vector2 initialPlayerPosition)
      : super(
          blackWhiteWorld,
          collection,
          Colors.white,
          initialPlayerPosition,
        );

  @override
  Future<void> onLoad() async {
    size = Vector2(20 * 16, 30 * 16);

    await super.onLoad();
    final grandpa = miscSprites['grandpa'];
    final treehouseTop = miscSprites['treehouse_top'];
    final treehouseBottom = miscSprites['treehouse_bottom'];
    final bone = miscSprites['bone'];
    final lumberjack = miscSprites['lumberjack'];
    final trashcan = miscSprites['trashcan'];
    if (trashcan != null) {
      add(Trashcan(trashcan, color, position: Vector2(7 * 16, 16 * 25)));
    }
    if (lumberjack != null) {
      add(Lumberjack(lumberjack, color, position: Vector2(11 * 16, 11 * 16)));
    }
    if (bone != null) {
      add(Bone(bone, color, position: Vector2(3 * 16, 16 * 25)));
    }
    if (grandpa != null) {
      add(Grandpa(grandpa, color, position: Vector2(7 * 16, 8 * 16)));
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

    if ((gameRef.globs['has_bridge']) == false) {
      riverTile = River(
          sprite: mapSprites['river'], position: Vector2(17 * 16, 14 * 16));
    } else {
      riverTile = Bridge(
          sprite: miscSprites['bridge'], position: Vector2(17 * 16, 14 * 16));
    }
    add(riverTile);
  }

  void addBridge() {
    add(Bridge(
        sprite: miscSprites['bridge'], position: Vector2(17 * 16, 14 * 16)));
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
    if (other.position.y >= 29 * 16) {
      // south to blue
      removeFromParent();
      gameRef.changeLevel(BlueLevel(Vector2(5 * 16, 0)));
    } else if (other.position.y <= 32) {
      // north to red
      if (!(gameRef.globs['has_cap'] == true)) {
        gameRef.add(TextPrompt(
          "It's cold here! Let's find some clothes",
          color: Colors.white,
          top: false,
        ));

        // hack to keep player on map
        gameRef.player.add(MoveByEffect(
          Vector2(0, 16),
          EffectController(duration: 0.2),
//          onComplete: onComplete,
        ));
      } else {
        removeFromParent();
        gameRef.changeLevel(RedLevel(Vector2(8 * 16, 29 * 16)));
      }
    } else if (other.position.x >= 19 * 16) {
      // east to green
      removeFromParent();
      final oldPlayerY = gameRef.player.position.y - 8;
      gameRef.changeLevel(GreenLevel(Vector2(0, oldPlayerY)));
    } else if (other.position.x < 17) {
      // oval office TODO: set to door
      removeFromParent();
      gameRef.changeLevel(OvalOffice(Vector2(19 * 16, 8 * 16)));
    }
  }
}
