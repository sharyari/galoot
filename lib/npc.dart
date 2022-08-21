import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';

class Npc extends SpriteAnimationComponent {
  Npc({super.position}) : super(size: Vector2(16, 16));
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(size: Vector2(14, 14), position: Vector2(1, 1))
      ..collisionType = CollisionType.passive);
  }
}

class GuardDog extends Npc {
  GuardDog({super.position});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    animation = SpriteAnimation.spriteList(
      [
        Sprite(Flame.images.fromCache('vakthund.png')),
        Sprite(Flame.images.fromCache('vakthund.png')),
      ],
      stepTime: 0.3,
    );
  }
}
