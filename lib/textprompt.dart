import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class TextPrompt extends TextBoxComponent with HasGameRef {
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
            growingBox: true,
            margins: const EdgeInsets.all(25),
          ),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (top) {
      position = Vector2(10, 10);
      align = Anchor.topCenter;
    } else {
      position = Vector2(10, gameRef.size.y - 10 - size.y);
      align = Anchor.bottomCenter;
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, Paint());
    super.render(canvas);
  }
}
