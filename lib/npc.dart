import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:galoot/main.dart';
import 'package:galoot/textprompt.dart';
import 'package:flutter/material.dart';

class Npc extends SpriteAnimationComponent with HasGameRef<GalootGame> {
  Npc({super.position}) : super(size: Vector2(16, 16));
  void converse() {}
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(size: Vector2(14, 14), position: Vector2(1, 1))
      ..collisionType = CollisionType.passive);
  }
}

class GuardDog extends Npc with CollisionCallbacks {
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

  @override
  void converse() {
    if (gameRef.globs['has_bone'] == true) {
      gameRef.add(TextPrompt(
        "Voof. Only big dogs can pass here, scram!",
        color: Colors.blue,
        top: true,
      ));
      // conv1
    } else {
      gameRef.add(TextPrompt(
        "Voof!! What's that you have there?!",
        color: Colors.blue,
        top: false,
      ));
    }
  }
}
