import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/main.dart';
import 'package:mini_sprite/mini_sprite.dart';

class Level extends PositionComponent with HasGameRef<GalootGame> {
  final String map;
  final String library;
  final Color color;
  final Vector2 initialPlayerPosition;
  late final Map<String, Sprite> mapSprites;
  Level(
    this.map,
    this.library,
    this.color,
    this.initialPlayerPosition,
  ) : super(position: Vector2(0, 0));
  late final Map<String, Sprite> miscSprites;

  @override
  Future<void> onLoad() async {
    final miniLibrary = MiniLibrary.fromDataString(library);
    gameRef.player.setPosition(initialPlayerPosition);
    gameRef.player.locked = false;
    add(RectangleHitbox(size: size));
    mapSprites = await miniLibrary.toSprites(
      color: color,
      pixelSize: 1,
    );

    final assets = MiniLibrary.fromDataString(misc);
    miscSprites = await assets.toSprites(
      color: color,
      pixelSize: 1,
    );

    startBgmMusic();

//    gameRef.camera.worldBounds = size.toRect();

    final miniMap = MiniMap.fromDataString(map);
    for (final entry in miniMap.objects.entries) {
      final sprite = mapSprites[entry.value['sprite']];
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
            )..add(
                RectangleHitbox(size: Vector2(14, 14), position: Vector2(1, 1))
                  ..collisionType = CollisionType.passive),
          ),
        );
      }
    }
    gameRef.player.setAnimations(color);
  }
}

void startBgmMusic() {
  FlameAudio.bgm.initialize();
  FlameAudio.bgm.play('bg.mp3');
}
