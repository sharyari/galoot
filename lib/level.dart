import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/main.dart';
import 'package:galoot/player.dart';
import 'package:mini_sprite/mini_sprite.dart';

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
    gameRef.player.setAnimations(color);
  }
}

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
    super.onLoad();
//    add(GuardDog(position: Vector2(7 * 16, 29 * 16)));
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
      removeFromParent();
      gameRef.changeLevel(BWLevel(), Vector2(10 * 16, 29 * 16)); // Todo
    }
  }
}

class RedLevel extends Level with CollisionCallbacks {
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
      // south to BW
      final oldPlayerX = gameRef.player.position.x - 8;
      removeFromParent();
      gameRef.changeLevel(BWLevel(), Vector2(oldPlayerX, 0));
    }
  }
}

class GreenLevel extends Level with CollisionCallbacks {
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

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoint,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoint, other);

    if (!(other is Player)) {
      return;
    }

    if (other.position.x < 16) {
      // west to BW
      final oldPlayerY = gameRef.player.position.y - 8;
      removeFromParent();
      gameRef.changeLevel(BWLevel(), Vector2(19 * 16, oldPlayerY));
    }
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
