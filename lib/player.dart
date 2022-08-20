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
    animations = {
      PlayerState.side: SpriteAnimation.spriteList(
        [
          Sprite(await Flame.images.load("katt1.png")),
          Sprite(await Flame.images.load("katt2.png")),
          Sprite(await Flame.images.load("katt3.png")),
        ],
        stepTime: 0.2,
      ),
      PlayerState.idle: SpriteAnimation.spriteList(
        [
          Sprite(await Flame.images.load("katt1.png")),
        ],
        stepTime: 0.2,
      ),
      PlayerState.up: SpriteAnimation.spriteList(
        [
          Sprite(await Flame.images.load("kattbak1.png")),
          Sprite(await Flame.images.load("kattbak2.png")),
          Sprite(await Flame.images.load("kattbak3.png")),
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
