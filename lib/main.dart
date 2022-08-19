import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: GalootGame()));
}

class GalootGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    add(
      CircleComponent(position: Vector2(100, 100), radius: 5),
    );
  }
}
