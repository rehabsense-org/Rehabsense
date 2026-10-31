import 'package:flutter/material.dart';
import '../tokens.dart';

class RSProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color? fillColor;
  final Color? trackColor;

  const RSProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.fillColor,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        width: double.infinity,
        color: trackColor ?? RSColors.surfaceCeramic,
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: clamped,
          child: Container(
            color: fillColor ?? RSColors.brandAction,
          ),
        ),
      ),
    );
  }
}
