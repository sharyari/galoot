import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Player extends SpriteAnimationGroupComponent<PlayerState> {
  Player() : super(size: Vector2(200, 200));

  @override
  Future<void> onLoad() async {
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
}

enum PlayerState {
  idle,
  up,
  side,
}
