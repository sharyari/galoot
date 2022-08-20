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

class BlueLevel extends Level {
  BlueLevel()
      : super(
          blueWorld,
          collection,
          Colors.blue,
        );
  @override
  Future<void> onLoad() async {
    size = Vector2(10 * 16, 35 * 16);
    super.onLoad();
  }
}

class RedLevel extends Level {
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
}

class GreenLevel extends Level {
  GreenLevel()
      : super(
          greenWorld,
          collection,
          Colors.green,
        );
  @override
  Future<void> onLoad() async {
    size = Vector2(20 * 16, 30 * 16);
    super.onLoad();
  }
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
    if (other.position.y >= 19 * 16) {
      removeFromParent();
      gameRef.changeLevel(BlueLevel(), Vector2(5 * 16, 0)); // Todo
    }
  }
}
