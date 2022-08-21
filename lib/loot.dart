import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:galoot/main.dart';

class Loot extends SpriteComponent with HasGameRef<GalootGame> {
  bool isPickedUp = false;
  Loot({super.position, super.sprite}) : super(size: Vector2(8, 8));
  @override
  Future<void> onLoad() async {
    add(
      RectangleHitbox(size: Vector2(14, 14), position: Vector2(1, 1))
        ..collisionType = CollisionType.passive,
    );
  }

  void pickUp() {
    isPickedUp = true;
  }
}
