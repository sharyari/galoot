import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';

import 'package:galoot/assets.dart';

class Level extends PositionComponent with HasGameRef {
  final String map;
  final String library;
  Level(this.map, this.library, Vector2 size)
      : super(size: size, position: Vector2(0, 0));

  @override
  Future<void> onLoad() async {
    final miniLibrary = MiniLibrary.fromDataString(library);
    add(RectangleHitbox(size: this.size));
    final sprites = await miniLibrary.toSprites(
      color: Colors.white,
      pixelSize: 1,
    );

    gameRef.camera.worldBounds = gameRef.size.toRect();

    final miniMap = MiniMap.fromDataString(map);
    for (final entry in miniMap.objects.entries) {
      final sprite = sprites[entry.value['sprite']];
      if (sprite != null) {
        unawaited(
          add(
            SpriteComponent(
              sprite: sprite,
              position: Vector2(entry.key.x * 16, entry.key.y * 16),
              size: Vector2(
                sprite.image.width.toDouble(),
                sprite.image.height.toDouble(),
              ),
            )..add(RectangleHitbox(
                size: Vector2(15, 15),
              )..collisionType = CollisionType.passive),
          ),
        );
      }
    }
  }
}

class BlueLevel extends Level {
  BlueLevel() : super(blueWorld, collection, Vector2(10 * 16, 35 * 16));
}

class BWLevel extends Level {
  BWLevel() : super(world, collection, Vector2(1000, 1000));
}
