import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../tokens.dart';

class RSScoreRing extends StatelessWidget {
  final int score;
  final double size;
  final bool isPersonalBest;
  final String label;

  const RSScoreRing({
    super.key,
    required this.score,
    this.size = 140,
    this.isPersonalBest = false,
    this.label = 'Movement score',
  });

  Color get _ringColor {
    if (isPersonalBest) return RSColors.accentGold;
    if (score >= 70) return RSColors.statusSuccess;
    if (score >= 40) return RSColors.statusWarning;
    return RSColors.statusError;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _ScoreRingPainter(
              score: score,
              color: _ringColor,
              trackColor: RSColors.surfaceCeramic,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score',
                    style: RSText.displayLarge.copyWith(
                      color: _ringColor,
                      fontWeight: FontWeight.bold,
                      fontSize: size * 0.35,
                    ),
                  ),
                  if (isPersonalBest) ...[
                    const SizedBox(height: 2),
                    Text(
                      'BEST',
                      style: RSText.labelOverline.copyWith(
                        color: RSColors.accentGoldDeep,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: RSText.captionStrong.copyWith(color: RSColors.textSecondary),
        ),
      ],
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final int score;
  final Color color;
  final Color trackColor;

  _ScoreRingPainter({
    required this.score,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.085;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (score.clamp(0, 100) / 100.0) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreRingPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
