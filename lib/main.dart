import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/bwlevel.dart';
import 'package:galoot/level.dart';
import 'package:galoot/textprompt.dart';
import 'package:galoot/player.dart';

void main() {
  runApp(GameWidget(game: GalootGame()));
}

Map<String, bool> initialize_glob_vars() {
  Map<String, bool> map = new Map();
  map['has_bone'] = false;
  map['has_blue_yarn'] = false;
  map['has_red_yarn'] = false;
  map['has_green_yarn'] = false;
  map['has_rod'] = false;
  map['has_cap'] = false;
  map['has_bridge'] = false;
  map['has_fish'] = false;
  map['dog_moved'] = false;
  return map;
}

class GalootGame extends FlameGame
    with HasCollisionDetection, HasDraggables, HasTappables {
  late Player player;
  late BWLevel currentLevel;
  Map<String, bool> globs = initialize_glob_vars();
  @override
  Future<void> onLoad() async {
    debugMode = false;
    await Flame.images.loadAll([
      'vakthund.png',
      'katt1.png',
    ]);

    camera.zoom = 2;
    player = Player(playerCat);
    add(player);
    changeLevel(BWLevel(Vector2(5 * 16, 8 * 16)));
    camera.followComponent(player);
    TextPrompt startText = TextPrompt(
        "Once upon a time, stuff happend and we no longer have any color",
        color: Colors.white,
        top: false);
    startText.position = Vector2(50, 50);
    startText.size = Vector2(300, 300);
    add(startText);
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

  void changeLevel(Level level) {
    player.children.query<MoveByEffect>().forEach((effect) {
      effect.removeFromParent();
    });
    add(level);
    if (level is BWLevel) {
      currentLevel = level;
    }
    player.lastPosition = player.position;
    player.changeParent(level);
  }
}
