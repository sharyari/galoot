import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';

import 'package:flame_audio/audio_pool.dart';

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with CollisionCallbacks, Tappable {
  late Vector2 lastPosition;
  late AudioPool mjau1;
  late AudioPool mjau2;
  late AudioPool angry;

  Player(Vector2 pos) : super(size: Vector2(200, 200)) {
    position = pos;
    lastPosition = pos;
  }

  @override
  Future<void> onLoad() async {
    size = Vector2(16, 16);
    add(RectangleHitbox(size: Vector2(15, 15)));
    current = PlayerState.idle;
    children.register<MoveByEffect>();
    mjau1 = await AudioPool.create('default_mjau.mp3', maxPlayers: 1);
    mjau2 = await AudioPool.create('default_mjau2.mp3', maxPlayers: 1);
    angry = await AudioPool.create('arg_mjau.mp3', maxPlayers: 1);

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
    ]);
    animations = {
      PlayerState.side: SpriteAnimation.spriteList(
        [
          Sprite(Flame.images.fromCache("katt1.png")),
          Sprite(Flame.images.fromCache("katt2.png")),
          Sprite(Flame.images.fromCache("katt3.png")),
        ],
        stepTime: 0.2,
      ),
      PlayerState.idle: SpriteAnimation.spriteList(
        [
          Sprite(Flame.images.fromCache("katt1.png")),
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
    void onComplete() =>
        {lastPosition = position.clone(), current = PlayerState.idle};
    if (children.query<MoveByEffect>().length == 0) {
      mjau1.start();
      if (direction.x.abs() > direction.y.abs()) {
        if (direction.x > 0) {
          add(MoveByEffect(
            Vector2(16, 0),
            EffectController(duration: 0.4),
            onComplete: onComplete,
          )); // right
          current = PlayerState.side;
        } else {
          add(MoveByEffect(
            Vector2(-16, 0),
            EffectController(duration: 0.4),
            onComplete: onComplete,
          )); // right
          current = PlayerState.side;
        }
      } else {
        if (direction.y > 0) {
          add(MoveByEffect(
            Vector2(0, 16),
            EffectController(duration: 0.4),
            onComplete: onComplete,
          )); // right
          current = PlayerState.down;
        } else {
          add(MoveByEffect(
            Vector2(0, -16),
            EffectController(duration: 0.4),
            onComplete: onComplete,
          )); // right
          current = PlayerState.up;
        }
      }
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoint,
    PositionComponent other,
  ) {
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
