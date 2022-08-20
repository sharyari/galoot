import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/level.dart';
import 'package:galoot/player.dart';

void main() {
  runApp(GameWidget(game: GalootGame()));
}

class GalootGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  late Player player;
  @override
  Future<void> onLoad() async {
    debugMode = true;
    camera.zoom = 2.0;
    player = Player(Vector2(64, 64));
    add(player);
    add(BlueLevel());
  }

  @override
  void onTapDown(int _pointerId, TapDownInfo info) {
    super.onTapDown(_pointerId, info);
    player.move(info.eventPosition);
  }
}
