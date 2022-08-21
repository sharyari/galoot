import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/bwlevel.dart';
import 'package:galoot/level.dart';
import 'package:galoot/npc.dart';
import 'package:galoot/player.dart';

import 'loot.dart';

class OvalOffice extends Level with CollisionCallbacks {
  OvalOffice(Vector2 initialPlayerPosition)
      : super(ovaloffice, ovalofficecomponents, Colors.white,
            initialPlayerPosition);
  @override
  Future<void> onLoad() async {
    size = Vector2(10 * 16, 35 * 16);
    await super.onLoad();
  }
}
