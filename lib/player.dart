import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/collisions.dart';

class Player extends SpriteAnimationGroupComponent<PlayerState> {
  final JoystickComponent joystick;
  Player(this.joystick) : super(size: Vector2(200, 200));
  @override
  Future<void> onLoad() async {
    size = Vector2(20, 20);
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
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      position.add(joystick.delta);
    }
  }
}

enum PlayerState {
  idle,
  up,
  side,
}
