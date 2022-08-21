import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/level.dart';
import 'package:galoot/npc.dart';
import 'package:galoot/player.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:galoot/textprompt.dart';
import 'package:mini_sprite/mini_sprite.dart';

class OvalOffice extends Level with CollisionCallbacks {
  OvalOffice(Vector2 initialPlayerPosition)
      : super(ovaloffice, ovalofficecomponents, Colors.white,
            initialPlayerPosition);
  @override
  Future<void> onLoad() async {
    size = Vector2(10 * 16, 35 * 16);
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('scary_bgm.wav', volume: 0.2);

    await super.onLoad();

    final assets = MiniLibrary.fromDataString(misc);
    final sprites = await assets.toSprites(
      color: Colors.deepOrange,
      pixelSize: 1,
    );
    final dognald = sprites['dognald'];
    if (dognald != null) {
      add(Dognald(dognald, Colors.deepOrange,
          position: Vector2(16 * 3, 16 * 6)));
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoint,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoint, other);
    if (!(other is Player)) {
      return;
    }
    print("collision");
    if ((gameRef.globs['game_finished'] == true)) {
      // Game ends!
      print("collision");

      TextPrompt endText = TextPrompt(
        "The curse had been lifted and the orange dog's magic was gone. Now our "
        "Galoot could finally see the beautiful world grandpa had always talked "
        "about!  -- Game end, close the browser :)",
        color: color,
        top: false,
      );
      endText.position = Vector2(10, 10);
      endText.size = Vector2(300, 500);
      add(endText);
    }
  }
}
