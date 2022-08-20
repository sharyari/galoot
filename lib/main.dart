import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/level.dart';
import 'package:galoot/player.dart';
import 'package:galoot/textprompt.dart';

void main() {
  runApp(GameWidget(game: GalootGame()));
}

class GalootGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  late Player player;
  @override
  Future<void> onLoad() async {
//    debugMode = true;
    camera.zoom = 2.0;
    player = Player(Vector2(25 * 16, 10 * 16));
    add(player);
    change_level(BWLevel(), Vector2(10 * 16, 25 * 16));
    camera.followComponent(player);
    add(TextPrompt("Hello world!", color: Colors.white, top: false));
  }

  @override
  void onTapDown(int _pointerId, TapDownInfo info) {
    super.onTapDown(_pointerId, info);
    player.move(info.eventPosition.game);
  }

  void change_level(Level level, Vector2 position) {
    add(level);
    player.position = position;
  }
}
