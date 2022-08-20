import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with CollisionCallbacks, Tappable {
  late Vector2 lastPosition;

  Player(Vector2 pos) : super(size: Vector2(200, 200)) {
    position = pos;
    lastPosition = pos;
  }

  @override
  Future<void> onLoad() async {
    size = Vector2(16, 16);
    add(RectangleHitbox());
    current = PlayerState.up;

    await Flame.images.loadAll([
      "katt1.png",
      "katt2.png",
      "katt3.png",
      "kattbak1.png",
      "kattbak2.png",
      "kattbak3.png",
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
    };
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoint,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoint, other);
    position = lastPosition;
  }
}

enum PlayerState {
  idle,
  up,
  side,
}
