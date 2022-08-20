import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:galoot/assets.dart';
import 'package:galoot/level.dart';
import 'package:galoot/player.dart';

void main() {
  runApp(GameWidget(game: GalootGame()));
}

Future<JoystickComponent> getJoystick() async {
  return JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(await Flame.images.load('knob.png')),
        size: Vector2.all(70),
      ),
      background: SpriteComponent(
        sprite: Sprite(await Flame.images.load('knob_bg.png')),
        size: Vector2.all(150),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40));
}

class GalootGame extends FlameGame with HasCollisionDetection, HasDraggables {
  late JoystickComponent joystick;
  @override
  Future<void> onLoad() async {
    debugMode = true;
    camera.zoom = 2.0;
    joystick = await getJoystick();
    add(Player(joystick));
    add(joystick);
    add(Level(world, collection));
  }
}
