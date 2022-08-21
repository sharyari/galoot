import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/bwlevel.dart';
import 'package:galoot/level.dart';
import 'package:galoot/player.dart';

void main() {
  runApp(GameWidget(game: GalootGame()));
}

Map<String, bool> initialize_glob_vars() {
  Map<String, bool> map = new Map();
  map['has_bone'] = false;
  return map;
}

class GalootGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  late Player player;
  Map<String, bool> globs = initialize_glob_vars();
  @override
  Future<void> onLoad() async {
    //debugMode = true;
    await Flame.images.loadAll([
      'vakthund.png',
      'katt1.png',
    ]);

    camera.zoom = 2;
    player = Player(Vector2(20 * 16, 10 * 16), playerCat);
    add(player);
    changeLevel(BWLevel(), Vector2(15 * 16, 20 * 16));
    camera.followComponent(player);
//    add(TextPrompt("Hello world!", color: Colors.white, top: false));
  }

  @override
  void onTapDown(int _pointerId, TapDownInfo info) {
    super.onTapDown(_pointerId, info);
    // two tapdowns are triggered. The textbox has locked the cat, so unlock it
    // and don't move (it would trigger another textbox!)
    if (player.locked) {
      player.locked = false;
    } else {
      player.move(info.eventPosition.game);
    }
  }

  void changeLevel(Level level, Vector2 position) {
    player.children.query<MoveByEffect>().forEach((effect) {
      effect.removeFromParent();
    });
    player.setPosition(position);
    add(level);
  }
}
