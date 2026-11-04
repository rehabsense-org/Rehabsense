import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../tokens.dart';

enum RSLogoVariant {
  mark,
  lockup,
}

/// Redesigned RehabSense Logo.
///
/// Features an ultra-modern, professional HealthTech emblem fusing:
/// 1. A dynamic stylized "R" biomechanical kinetic ribbon & recovery vector.
/// 2. An optical computer-vision tracking sensor arc (precision angle gauge).
/// 3. Luminous biometric core pulse node with ambient gradient glow.
/// 4. Deep Pine & Emerald gradient squircle badge with subtle glassmorphic bevel.
class RSLogo extends StatelessWidget {
  final RSLogoVariant variant;
  final bool onDark;
  final double size;

  const RSLogo({
    super.key,
    this.variant = RSLogoVariant.lockup,
    this.onDark = false,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final markWidget = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _RSLogoMarkPainter(onDark: onDark),
      ),
    );

    if (variant == RSLogoVariant.mark) {
      return markWidget;
    }

    // Lockup variant (Mark + Brand Typography)
    final titlePrimaryColor = onDark ? Colors.white : RSColors.brandGreen;
    final titleAccentColor = onDark ? const Color(0xFF00E5A8) : RSColors.brandAction;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          markWidget,
          SizedBox(width: size * 0.26),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rehab',
                    style: TextStyle(
                      fontFamily: RSText.fontFamily,
                      fontSize: size * 0.54,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      height: 1.1,
                      color: titlePrimaryColor,
                    ),
                  ),
                  Text(
                    'Sense',
                    style: TextStyle(
                      fontFamily: RSText.fontFamily,
                      fontSize: size * 0.54,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                      height: 1.1,
                      color: titleAccentColor,
                    ),
                  ),
                ],
              ),
              if (size >= 44) ...[
                SizedBox(height: size * 0.03),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4.5,
                      height: 4.5,
                      decoration: BoxDecoration(
                        color: titleAccentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'AI BIOMECHANICS LAB',
                      style: TextStyle(
                        fontFamily: RSText.fontFamily,
                        fontSize: size * 0.16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: onDark
                            ? Colors.white.withValues(alpha: 0.72)
                            : RSColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom vector painter creating the distinctive, high-tech RehabSense emblem.
///
/// Combines a modern kinetic "R" monogram, precision angle tracking gauge,
/// and luminous biometric landmark sensor core.
class _RSLogoMarkPainter extends CustomPainter {
  final bool onDark;

  const _RSLogoMarkPainter({required this.onDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = w * 0.26; // Refined squircle corner curvature

    final rect = Rect.fromLTWH(0, 0, w, h);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(r));

    // ── 1. Squircle Badge Background ─────────────────────────────────────────
    if (onDark) {
      // Ambient cyan-mint glow for dark modes
      final glowPaint = Paint()
        ..color = const Color(0xFF00E5A8).withValues(alpha: 0.22)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.16);
      canvas.drawRRect(rrect.inflate(w * 0.02), glowPaint);
    } else {
      // Subtle shadow on light backgrounds
      final shadowPaint = Paint()
        ..color = const Color(0xFF0B3024).withValues(alpha: 0.14)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.12);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, h * 0.05, w, h),
          Radius.circular(r),
        ),
        shadowPaint,
      );
    }

    // Rich dual-diagonal gradient: Deep Pine to Vibrant Emerald
    final bgGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: onDark
          ? const [
              Color(0xFF07231A),
              Color(0xFF0B3D2E),
              Color(0xFF0F5640),
            ]
          : const [
              Color(0xFF07261B),
              Color(0xFF00754A),
              Color(0xFF0B3024),
            ],
      stops: const [0.0, 0.65, 1.0],
    );

    final bgPaint = Paint()
      ..shader = bgGradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, bgPaint);

    // Subtle inner bevel rim highlight
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.026
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.35),
          const Color(0xFF00E5A8).withValues(alpha: 0.18),
          Colors.white.withValues(alpha: 0.05),
        ],
      ).createShader(rect);
    canvas.drawRRect(rrect.deflate(w * 0.013), rimPaint);

    // Clip inner content to badge bounds
    canvas.save();
    canvas.clipRRect(rrect.deflate(w * 0.02));

    // ── 2. Computer-Vision Optical Tracking Grid Arc ─────────────────────────
    final center = Offset(w * 0.50, h * 0.50);
    final arcRadius = w * 0.34;

    // Optical radar tracking arc (180° to 340°)
    final trackingArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.028
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF00E5A8).withValues(alpha: 0.28);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      math.pi * 0.9,
      math.pi * 0.9,
      false,
      trackingArcPaint,
    );

    // Subtle angle gauge tick at 45°
    final tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.022
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.45);
    final tickRad = -math.pi * 0.25;
    final tickP1 = Offset(
      center.dx + math.cos(tickRad) * (arcRadius - w * 0.04),
      center.dy + math.sin(tickRad) * (arcRadius - w * 0.04),
    );
    final tickP2 = Offset(
      center.dx + math.cos(tickRad) * (arcRadius + w * 0.04),
      center.dy + math.sin(tickRad) * (arcRadius + w * 0.04),
    );
    canvas.drawLine(tickP1, tickP2, tickPaint);

    // ── 3. Biomechanical "R" Kinetic Vector Monogram ─────────────────────────
    // Primary vertical spine (Biomechanic axis)
    final spineX = w * 0.34;
    final spineTop = h * 0.24;
    final spineBottom = h * 0.76;
    final strokeThick = w * 0.095;

    final spinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeThick
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE6FAF3),
          Color(0xFF00E5A8),
          Color(0xFF009B63),
        ],
      ).createShader(Rect.fromLTRB(spineX, spineTop, spineX, spineBottom));

    canvas.drawLine(
      Offset(spineX, spineTop),
      Offset(spineX, spineBottom),
      spinePaint,
    );

    // Dynamic sweeping Range-of-Motion upper loop of the 'R'
    final loopPath = Path();
    loopPath.moveTo(spineX, spineTop);
    loopPath.cubicTo(
      w * 0.76,
      spineTop - h * 0.02,
      w * 0.82,
      h * 0.48,
      spineX,
      h * 0.49,
    );

    final loopPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeThick * 0.95
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFF5DF6C9),
          Color(0xFF00D28E),
        ],
      ).createShader(Rect.fromLTWH(spineX, spineTop, w * 0.5, h * 0.3));

    canvas.drawPath(loopPath, loopPaint);

    // Dynamic forward recovery diagonal vector (Lower leg of 'R')
    final legPath = Path();
    legPath.moveTo(spineX + w * 0.08, h * 0.48);
    legPath.cubicTo(
      w * 0.52,
      h * 0.52,
      w * 0.62,
      h * 0.64,
      w * 0.76,
      spineBottom,
    );

    final legPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeThick * 0.95
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF00E5A8),
          Color(0xFF00F5B4),
          Color(0xFFE8FFF8),
        ],
      ).createShader(Rect.fromLTWH(w * 0.4, h * 0.48, w * 0.36, h * 0.3));

    canvas.drawPath(legPath, legPaint);

    // ── 4. Luminous Pose-Landmark Sensor Node (Apex of kinetic loop) ──────────
    final apexNode = Offset(w * 0.68, h * 0.36);
    final nodeRadius = w * 0.055;

    // Ambient radial glow around landmark node
    final nodeGlow = Paint()
      ..color = const Color(0xFF00E5A8).withValues(alpha: 0.55)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.08);
    canvas.drawCircle(apexNode, nodeRadius * 1.6, nodeGlow);

    // Outer precise sensor ring
    final nodeRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.022
      ..color = Colors.white.withValues(alpha: 0.9);
    canvas.drawCircle(apexNode, nodeRadius, nodeRing);

    // Glowing core jewel
    final nodeCore = Paint()
      ..style = PaintingStyle.fill
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFF00E5A8),
        ],
      ).createShader(Rect.fromCircle(center: apexNode, radius: nodeRadius));
    canvas.drawCircle(apexNode, nodeRadius * 0.62, nodeCore);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RSLogoMarkPainter oldDelegate) =>
      oldDelegate.onDark != onDark;
}
