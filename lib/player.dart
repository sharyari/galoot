import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';

import 'package:flutter/material.dart';
import 'package:galoot/level.dart';
import 'package:galoot/npc.dart';
import 'package:mini_sprite/mini_sprite.dart';

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with CollisionCallbacks, Tappable {
  late Vector2 lastPosition;
  late final AudioPool mjau1;
  late AudioPool mjau2;
  late AudioPool angry;
  late Random rng = Random();
  bool locked = false;
  final String library;
  late MiniLibrary miniLibrary;

  Player(
    this.library,
  ) : super(size: Vector2(200, 200), anchor: Anchor.center);

  void setPosition(Vector2 position) {
    this.position = position + Vector2(8, 8);
  }

  @override
  Future<void> onLoad() async {
    miniLibrary = MiniLibrary.fromDataString(library);

    size = Vector2(16, 16);
    add(RectangleHitbox(size: Vector2(14, 14), position: Vector2(1, 1)));

    current = PlayerState.idle;
    children.register<MoveByEffect>();
    mjau1 = await FlameAudio.createPool(
      'default_mjau.mp3',
      minPlayers: 3,
      maxPlayers: 10,
    );
    mjau2 = await AudioPool.create('audio/default_mjau2.mp3', maxPlayers: 10);
    angry = await AudioPool.create('audio/arg_mjau.mp3', maxPlayers: 10);
  }

  Future<void> setAnimations(Color color) async {
    final sprites = await miniLibrary.toSprites(
      color: color,
      pixelSize: 1,
    );

    animations = {
      PlayerState.side: SpriteAnimation.spriteList(
        [
          sprites['cat_side_1']!,
          sprites['cat_side_2']!,
          sprites['cat_side_1']!,
          sprites['cat_side_3']!,
        ],
        stepTime: 0.2,
      ),
      PlayerState.idle: SpriteAnimation.spriteList(
        [
          sprites['cat_side_1']!,
        ],
        stepTime: 0.2,
      ),
      PlayerState.up: SpriteAnimation.spriteList(
        [
          sprites['cat_back_1']!,
          sprites['cat_back_2']!,
          sprites['cat_back_1']!,
          sprites['cat_back_3']!,
        ],
        stepTime: 0.2,
      ),
      PlayerState.down: SpriteAnimation.spriteList(
        [
          sprites['cat_front_1']!,
          sprites['cat_front_2']!,
          sprites['cat_front_1']!,
          sprites['cat_front_3']!,
        ],
        stepTime: 0.2,
      )
    };
  }

  void move(Vector2 clickPos) {
    Vector2 direction = clickPos - position;
    void onComplete() => {lastPosition = position.clone()};
    if (children.query<MoveByEffect>().length > 0 || locked) {
      return;
    }
    if (direction.x.abs() > direction.y.abs()) {
      if (direction.x > 0) {
        add(MoveByEffect(
          Vector2(16, 0),
          EffectController(duration: 0.15),
          onComplete: onComplete,
        )); // right
        current = PlayerState.side;
        if (!isFlippedHorizontally) {
          flipHorizontallyAroundCenter();
        }
      } else {
        add(MoveByEffect(
          Vector2(-16, 0),
          EffectController(duration: 0.15),
          onComplete: onComplete,
        )); // right
        current = PlayerState.side;
        if (isFlippedHorizontally) {
          flipHorizontallyAroundCenter();
        }
      }
    } else {
      if (direction.y > 0) {
        add(MoveByEffect(
          Vector2(0, 16),
          EffectController(duration: 0.15),
          onComplete: onComplete,
        )); // right
        current = PlayerState.down;
      } else {
        add(MoveByEffect(
          Vector2(0, -16),
          EffectController(duration: 0.15),
          onComplete: onComplete,
        )); // right
        current = PlayerState.up;
      }
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (rng.nextBool()) {
      mjau1.start();
    } else {
      mjau2.start();
    }
    return true;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoint,
    PositionComponent other,
  ) {
    if (other is Level) {
      // level will fix it
      return;
    }
    if (other is Npc) {
      if (rng.nextBool()) {
        mjau1.start();
      } else {
        mjau2.start();
      }
      other.converse();
    }

    super.onCollisionStart(intersectionPoint, other);
    children.query<MoveByEffect>().forEach((effect) {
      effect.removeFromParent();
    });
    position = lastPosition;
  }
}

enum PlayerState {
  idle,
  up,
  side,
  down,
}
