// ---------------------------------------------------------------------------
// POSE TRACKING & ANALYSIS ENGINE — RehabSense
// Preserves all existing camera alignment and landmark computation.
// ---------------------------------------------------------------------------

import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mp_pose_landmarker/flutter_mp_pose_landmarker.dart';

export 'tracking_engine.dart';

// ---------------------------------------------------------------------------
// CAMERA ALIGNMENT (confirmed working - do not change)
// ---------------------------------------------------------------------------
const bool kMirrorFrontCameraX = true;
const bool kMirrorRearCameraX = false;
const bool kFlipRearCameraY = false;
const bool kPreviewUsesCover = true;
const double kAnalysisAspect = 360 / 480;

// ---------------------------------------------------------------------------
// DISPLAY SWITCHES
// ---------------------------------------------------------------------------
const bool kShowJointAngles = true;
const bool kShowJointSpeed = true;
const bool kShowAnglePanel = false;

// ---------------------------------------------------------------------------
// POSTURE TOLERANCES
// ---------------------------------------------------------------------------
const double kMaxShoulderTiltDeg = 6; // shoulders level
const double kMaxHipTiltDeg = 6; // hips level
const double kMaxTrunkLeanDeg = 8; // body upright
const int kPostureHoldMs = 300; // stops colour flicker
const double kPosturePresence = 0.5; // min landmark confidence

const Color kTealColor = Color(0xFF00E5A8);
const Color kGoodColor = Color(0xFF00E676);
const Color kBadColor = Color(0xFFFF1744);

// ---------------------------------------------------------------------------
// ANGLES
// ---------------------------------------------------------------------------
class JointDef {
  final String name;
  final int a; // first point
  final int b; // joint (angle is measured here, also the map key)
  final int c; // last point
  const JointDef(this.name, this.a, this.b, this.c);
}

const List<JointDef> kJoints = [
  JointDef('Left elbow', 11, 13, 15),
  JointDef('Right elbow', 12, 14, 16),
  JointDef('Left shoulder', 13, 11, 23),
  JointDef('Right shoulder', 14, 12, 24),
  JointDef('Left hip', 11, 23, 25),
  JointDef('Right hip', 12, 24, 26),
  JointDef('Left knee', 23, 25, 27),
  JointDef('Right knee', 24, 26, 28),
];

class JointAngleCalculator {
  /// Angle at [b] between a-b-c in degrees, or null if not visible.
  /// X is scaled by the image aspect so angles are not distorted.
  static double? angle(
    List<PoseLandmarkPoint> p,
    int a,
    int b,
    int c,
  ) {
    if (p.length <= math.max(a, math.max(b, c))) return null;
    final pa = p[a], pb = p[b], pc = p[c];
    if (pa.presence < 0.3 || pb.presence < 0.3 || pc.presence < 0.3) {
      return null;
    }

    final abX = (pa.x - pb.x) * kAnalysisAspect;
    final abY = pa.y - pb.y;
    final cbX = (pc.x - pb.x) * kAnalysisAspect;
    final cbY = pc.y - pb.y;

    final abLen = math.sqrt(abX * abX + abY * abY);
    final cbLen = math.sqrt(cbX * cbX + cbY * cbY);
    if (abLen == 0 || cbLen == 0) return null;

    final cosine = ((abX * cbX + abY * cbY) / (abLen * cbLen)).clamp(-1.0, 1.0);
    return math.acos(cosine) * 180 / math.pi;
  }

  static Map<int, double?> all(List<PoseLandmarkPoint> p) => {
        for (final j in kJoints) j.b: angle(p, j.a, j.b, j.c),
      };
}

// ---------------------------------------------------------------------------
// RANGE OF MOTION + SPEED (runs in the background)
// ---------------------------------------------------------------------------
class MotionTracker {
  final Map<int, double> romMin = {};
  final Map<int, double> romMax = {};

  /// Smoothed angular speed in degrees per second.
  final Map<int, double> speed = {};

  final Map<int, double> _last = {};
  int? _lastMs;

  double? rom(int joint) {
    final lo = romMin[joint], hi = romMax[joint];
    return (lo == null || hi == null) ? null : hi - lo;
  }

  void update(Map<int, double?> angles, int nowMs) {
    final dt = _lastMs == null ? null : (nowMs - _lastMs!) / 1000.0;
    _lastMs = nowMs;

    angles.forEach((joint, value) {
      if (value == null) {
        _last.remove(joint);
        speed.remove(joint);
        return;
      }

      romMin[joint] = math.min(romMin[joint] ?? value, value);
      romMax[joint] = math.max(romMax[joint] ?? value, value);

      final prev = _last[joint];
      if (prev != null && dt != null && dt > 0 && dt < 0.5) {
        final instant = (value - prev).abs() / dt;
        speed[joint] = (speed[joint] ?? instant) * 0.7 + instant * 0.3;
      }
      _last[joint] = value;
    });
  }

  void reset() {
    romMin.clear();
    romMax.clear();
    speed.clear();
    _last.clear();
    _lastMs = null;
  }
}

// ---------------------------------------------------------------------------
// POSTURE (stand straight check)
// ---------------------------------------------------------------------------
enum PostureStatus { unknown, good, bad }

class PostureChecker {
  PostureStatus status = PostureStatus.unknown;
  String message = 'Stand in front of the camera';
  double shoulderTilt = 0;
  double hipTilt = 0;
  double trunkLean = 0;

  PostureStatus _candidate = PostureStatus.unknown;
  int _candidateSince = 0;

  // Degrees away from level (0 = perfectly level).
  double _tilt(PoseLandmarkPoint a, PoseLandmarkPoint b) {
    final dx = (b.x - a.x).abs() * kAnalysisAspect;
    final dy = (b.y - a.y).abs();
    return math.atan2(dy, dx) * 180 / math.pi;
  }

  void reset() {
    status = PostureStatus.unknown;
    message = 'Stand in front of the camera';
    _candidate = PostureStatus.unknown;
  }

  void update(List<PoseLandmarkPoint> p, int nowMs) {
    PostureStatus raw = PostureStatus.unknown;
    String text = 'Show your shoulders and hips';

    if (p.length >= 25) {
      final ls = p[11], rs = p[12], lh = p[23], rh = p[24];
      final visible = ls.presence >= kPosturePresence &&
          rs.presence >= kPosturePresence &&
          lh.presence >= kPosturePresence &&
          rh.presence >= kPosturePresence;

      if (visible) {
        shoulderTilt = _tilt(ls, rs);
        hipTilt = _tilt(lh, rh);

        final shX = (ls.x + rs.x) / 2, shY = (ls.y + rs.y) / 2;
        final hpX = (lh.x + rh.x) / 2, hpY = (lh.y + rh.y) / 2;
        final dx = (shX - hpX).abs() * kAnalysisAspect;
        final dy = (shY - hpY).abs();
        trunkLean = math.atan2(dx, dy) * 180 / math.pi;

        if (shoulderTilt > kMaxShoulderTiltDeg) {
          raw = PostureStatus.bad;
          text = 'Level your shoulders';
        } else if (hipTilt > kMaxHipTiltDeg) {
          raw = PostureStatus.bad;
          text = 'Level your hips';
        } else if (trunkLean > kMaxTrunkLeanDeg) {
          raw = PostureStatus.bad;
          text = 'Stand upright';
        } else {
          raw = PostureStatus.good;
          text = 'Posture good';
        }
      }
    }

    if (raw != _candidate) {
      _candidate = raw;
      _candidateSince = nowMs;
    }

    if (nowMs - _candidateSince >= kPostureHoldMs) {
      status = _candidate;
      message = text;
    }
  }
}

// ---------------------------------------------------------------------------
// NATIVE CAMERA PREVIEW WIDGET
// ---------------------------------------------------------------------------
class NativeCameraPreview extends StatelessWidget {
  const NativeCameraPreview({super.key});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return const SizedBox.expand(
        child: AndroidView(
          viewType: 'camera_preview_view',
          layoutDirection: TextDirection.ltr,
        ),
      );
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return const SizedBox.expand(
        child: UiKitView(
          viewType: 'camera_preview_view',
          layoutDirection: TextDirection.ltr,
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          'Camera preview active',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SKELETON PAINTER
// ---------------------------------------------------------------------------
class SkeletonPainter extends CustomPainter {
  final List<PoseLandmarkPoint> landmarks;
  final bool mirrorX;
  final bool flipY;
  final Color skeletonColor;
  final Map<int, double?> angles;
  final Map<int, double> speeds;
  final bool showAngles;
  final bool showSpeed;

  SkeletonPainter({
    required this.landmarks,
    required this.mirrorX,
    required this.skeletonColor,
    required this.angles,
    required this.speeds,
    required this.showAngles,
    required this.showSpeed,
    this.flipY = false,
  });

  static const List<List<int>> connections = [
    [0, 1], [1, 2], [2, 3], [3, 7],
    [0, 4], [4, 5], [5, 6], [6, 8],
    [9, 10],
    [11, 12],
    [11, 13], [13, 15], [15, 17], [15, 19], [15, 21],
    [17, 19],
    [12, 14], [14, 16], [16, 18], [16, 20], [16, 22],
    [18, 20],
    [11, 23], [12, 24], [23, 24],
    [23, 25], [25, 27], [27, 29], [29, 31], [27, 31],
    [24, 26], [26, 28], [28, 30], [30, 32], [28, 32],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.length < 33) return;

    final fitWidthHeight = size.width / kAnalysisAspect;
    final fillByWidth = kPreviewUsesCover
        ? fitWidthHeight >= size.height
        : fitWidthHeight <= size.height;

    double imageW;
    double imageH;
    if (fillByWidth) {
      imageW = size.width;
      imageH = fitWidthHeight;
    } else {
      imageH = size.height;
      imageW = size.height * kAnalysisAspect;
    }

    final offsetX = (size.width - imageW) / 2;
    final offsetY = (size.height - imageH) / 2;

    Offset pointFor(int index) {
      final landmark = landmarks[index];
      var x = landmark.x;
      var y = landmark.y;
      if (mirrorX) x = 1 - x;
      if (flipY) y = 1 - y;
      return Offset(offsetX + x * imageW, offsetY + y * imageH);
    }

    final linePaint = Paint()
      ..color = skeletonColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = const Color(0xFFFFFF00)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (final pair in connections) {
      final a = landmarks[pair[0]];
      final b = landmarks[pair[1]];
      if (a.presence < 0.3 || b.presence < 0.3) continue;

      final start = pointFor(pair[0]);
      final end = pointFor(pair[1]);
      if (!start.dx.isFinite ||
          !start.dy.isFinite ||
          !end.dx.isFinite ||
          !end.dy.isFinite) {
        continue;
      }
      canvas.drawLine(start, end, linePaint);
    }

    for (final entry in landmarks.asMap().entries) {
      if (entry.value.presence < 0.3) continue;
      final point = pointFor(entry.key);
      if (!point.dx.isFinite || !point.dy.isFinite) continue;
      canvas.drawCircle(point, 4.5, pointPaint);
      canvas.drawCircle(point, 4.5, outlinePaint);
    }

    if (showAngles) {
      for (final j in kJoints) {
        final angle = angles[j.b];
        if (angle == null || landmarks[j.b].presence < 0.3) continue;
        final point = pointFor(j.b);
        if (!point.dx.isFinite || !point.dy.isFinite) continue;
        _drawLabel(canvas, size, point, angle, speeds[j.b]);
      }
    }
  }

  void _drawLabel(
    Canvas canvas,
    Size size,
    Offset point,
    double angle,
    double? speed,
  ) {
    final spans = <TextSpan>[
      TextSpan(
        text: '${angle.round()}°',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];

    if (showSpeed && speed != null) {
      spans.add(
        TextSpan(
          text: '\n${speed.round()}°/s',
          style: const TextStyle(color: Color(0xFFB2FFE9), fontSize: 10),
        ),
      );
    }

    final tp = TextPainter(
      text: TextSpan(children: spans),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    final onLeft = point.dx < size.width / 2;
    var dx = onLeft ? point.dx - tp.width - 14 : point.dx + 14;
    dx = dx.clamp(2.0, math.max(2.0, size.width - tp.width - 2)).toDouble();
    final dy = point.dy - tp.height / 2;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(dx - 4, dy - 2, tp.width + 8, tp.height + 4),
      const Radius.circular(6),
    );

    canvas.drawRRect(
      rect,
      Paint()..color = Colors.black.withOpacity(0.6),
    );
    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant SkeletonPainter oldDelegate) => true;
}
