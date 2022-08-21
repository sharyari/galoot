import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:galoot/level.dart';

import 'dart:math';

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with CollisionCallbacks, Tappable {
  late Vector2 lastPosition;
  late final AudioPool mjau1;
  late AudioPool mjau2;
  late AudioPool angry;
  late Random rng = Random();

  Player(Vector2 pos) : super(size: Vector2(200, 200), anchor: Anchor.center) {
    setPosition(pos);
    lastPosition = pos;
  }

  void setPosition(Vector2 position) {
    this.position = position + Vector2(8, 8);
  }

  @override
  Future<void> onLoad() async {
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

    await Flame.images.loadAll([
      "katt1.png",
      "katt2.png",
      "katt3.png",
      "kattbak1.png",
      "kattbak2.png",
      "kattbak3.png",
      "kattfram1.png",
      "kattfram2.png",
      "kattfram3.png",
      "nykatt1.png",
      "nykatt2.png",
      "nykatt3.png",
    ]);
    animations = {
      PlayerState.side: SpriteAnimation.spriteList(
        [
          Sprite(Flame.images.fromCache("nykatt1.png")),
          Sprite(Flame.images.fromCache("nykatt2.png")),
          Sprite(Flame.images.fromCache("nykatt1.png")),
          Sprite(Flame.images.fromCache("nykatt3.png")),
        ],
        stepTime: 0.3,
      ),
      PlayerState.idle: SpriteAnimation.spriteList(
        [
          Sprite(Flame.images.fromCache("nykatt1.png")),
        ],
        stepTime: 0.2,
      ),
      PlayerState.up: SpriteAnimation.spriteList(
        [
          Sprite(Flame.images.fromCache("kattbak1.png")),
          Sprite(Flame.images.fromCache("kattbak2.png")),
          Sprite(Flame.images.fromCache("kattbak1.png")),
          Sprite(Flame.images.fromCache("kattbak3.png")),
        ],
        stepTime: 0.2,
      ),
      PlayerState.down: SpriteAnimation.spriteList(
        [
          Sprite(Flame.images.fromCache("kattfram3.png")),
          Sprite(Flame.images.fromCache("kattfram1.png")),
          Sprite(Flame.images.fromCache("kattfram3.png")),
          Sprite(Flame.images.fromCache("kattfram2.png"))
        ],
        stepTime: 0.2,
      )
    };
  }

  void move(Vector2 clickPos) {
    Vector2 direction = clickPos - position;
    void onComplete() => {lastPosition = position.clone()};
    if (children.query<MoveByEffect>().length > 0) {
      return;
    }
    if (direction.x.abs() > direction.y.abs()) {
      if (direction.x > 0) {
        add(MoveByEffect(
          Vector2(16, 0),
          EffectController(duration: 0.2),
          onComplete: onComplete,
        )); // right
        current = PlayerState.side;
        if (!isFlippedHorizontally) {
          flipHorizontallyAroundCenter();
        }
      } else {
        add(MoveByEffect(
          Vector2(-16, 0),
          EffectController(duration: 0.2),
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
          EffectController(duration: 0.2),
          onComplete: onComplete,
        )); // right
        current = PlayerState.down;
      } else {
        add(MoveByEffect(
          Vector2(0, -16),
          EffectController(duration: 0.2),
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
      return;
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
