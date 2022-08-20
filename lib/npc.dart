import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Npc extends SpriteAnimationComponent {
  final SpriteAnimation spriteAnimation;
  Npc(this.spriteAnimation) : super(size: Vector2(16, 16));
  @override
  Future<void> onLoad() async {
    size = Vector2(16, 16);
    add(RectangleHitbox());
    animation = spriteAnimation;
  }
}
