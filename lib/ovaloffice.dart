import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/level.dart';
import 'package:galoot/npc.dart';
import 'package:mini_sprite/mini_sprite.dart';

class OvalOffice extends Level with CollisionCallbacks {
  OvalOffice(Vector2 initialPlayerPosition)
      : super(ovaloffice, ovalofficecomponents, Colors.white,
            initialPlayerPosition);
  @override
  Future<void> onLoad() async {
    size = Vector2(10 * 16, 35 * 16);
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
}
