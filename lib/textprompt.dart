import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:galoot/main.dart';
import 'package:flame/input.dart';

class TextPrompt extends TextBoxComponent
    with HasGameRef<GalootGame>, Tappable {
  final bool top;
  TextPrompt(
    String text, {
    required Color color,
    required this.top,
  }) : super(
          text: text,
          textRenderer: TextPaint(
            style: TextStyle(
              color: color,
              fontFamily: 'monospace',
              letterSpacing: 2.0,
            ),
          ),
          boxConfig: TextBoxConfig(
            maxWidth: 300,
            timePerChar: 0.04,
            margins: const EdgeInsets.all(25),
            growingBox: false,
          ),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (top) {
      position =
          gameRef.player.position + Vector2(-size.x / 2, -size.y - 2 * 16);
      align = Anchor.topLeft;
    } else {
      position = gameRef.player.position + Vector2(-size.x / 2, 2 * 16);
      align = Anchor.bottomCenter;
    }
    gameRef.player.locked = true;
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, Paint());
    super.render(canvas);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    removeFromParent();
    return true;
  }
}
