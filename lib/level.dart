import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/main.dart';

class Level extends PositionComponent with HasGameRef<GalootGame> {
  final String map;
  final String library;
  final Color color;
  Level(this.map, this.library, Vector2 size, this.color)
      : super(size: size, position: Vector2(0, 0));

  @override
  Future<void> onLoad() async {
    final miniLibrary = MiniLibrary.fromDataString(library);
    add(RectangleHitbox(size: size));
    final sprites = await miniLibrary.toSprites(
      color: color,
      pixelSize: 1,
    );

    startBgmMusic();

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
            )..add(
                RectangleHitbox(size: Vector2(14, 14), position: Vector2(1, 1))
                  ..collisionType = CollisionType.passive),
          ),
        );
      }
    }
  }
}

class BlueLevel extends Level {
  BlueLevel()
      : super(
          blueWorld,
          collection,
          Vector2(10 * 16, 35 * 16),
          Colors.blue,
        );
}

class RedLevel extends Level {
  RedLevel()
      : super(
          redWorld,
          collection,
          Vector2(20 * 16, 30 * 16),
          Colors.red,
        );
}

class GreenLevel extends Level {
  GreenLevel()
      : super(
          greenWorld,
          collection,
          Vector2(20 * 16, 30 * 16),
          Colors.green,
        );
}

void startBgmMusic() {
  FlameAudio.bgm.initialize();
  FlameAudio.bgm.play('scary_bgm.wav');
}

class BWLevel extends Level with CollisionCallbacks {
  BWLevel()
      : super(
          blackWhiteWorld,
          collection,
          Vector2(20 * 16, 30 * 16),
          Colors.white,
        );

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoint,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoint, other);
    if (other.position.y >= 16 * 16) {
      this.removeFromParent();
      gameRef.change_level(BlueLevel(), Vector2(5 * 16, 0)); // Todo
    }
  }
}
