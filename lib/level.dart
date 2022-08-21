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

class Level extends PositionComponent with HasGameRef<GalootGame> {
  final String map;
  final String library;
  final Color color;
  Level(this.map, this.library, this.color) : super(position: Vector2(0, 0));

  @override
  Future<void> onLoad() async {
    final miniLibrary = MiniLibrary.fromDataString(library);
    add(RectangleHitbox(size: size));
    final sprites = await miniLibrary.toSprites(
      color: color,
      pixelSize: 1,
    );

//    startBgmMusic();

//    gameRef.camera.worldBounds = size.toRect();

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
            )..add(
                RectangleHitbox(size: Vector2(14, 14), position: Vector2(1, 1))
                  ..collisionType = CollisionType.passive),
          ),
        );
      }
    }
  }
}

void startBgmMusic() {
  FlameAudio.bgm.initialize();
  FlameAudio.bgm.play('scary_bgm.wav');
}
