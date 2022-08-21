import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:galoot/main.dart';

class Objects extends SpriteComponent with HasGameRef<GalootGame> {
  Objects({super.sprite, super.position}) : super(size: Vector2(16, 16));
  @override
  Future<void> onLoad() async {
    add(
      RectangleHitbox(size: Vector2(14, 14), position: Vector2(1, 1))
        ..collisionType = CollisionType.passive,
    );
  }
}

class River extends Objects {
  River({super.sprite, super.position});
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }
}

class Bridge extends Objects {
  Bridge({super.sprite, super.position});
  @override
  Future<void> onLoad() async {
    return;
  }
}

class Door extends Objects {
  Door({super.sprite, super.position});
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }
}
