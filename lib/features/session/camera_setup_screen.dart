import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mp_pose_landmarker/flutter_mp_pose_landmarker.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/seed/seed_data.dart';
import '../../domain/pose/pose_tracker.dart';

class CameraSetupScreen extends StatefulWidget {
  final String exerciseId;

  const CameraSetupScreen({super.key, required this.exerciseId});

  @override
  State<CameraSetupScreen> createState() => _CameraSetupScreenState();
}

class _CameraSetupScreenState extends State<CameraSetupScreen> {
  StreamSubscription<PoseLandMarker>? _subscription;
  final Stopwatch _clock = Stopwatch()..start();

  final MotionTracker _motion = MotionTracker();
  final PostureChecker _posture = PostureChecker();

  List<PoseLandmarkPoint> _landmarks = [];
  Map<int, double?> _angles = {};
  Map<int, double> _speeds = {};

  bool _frontCamera = true;
  bool _bodyDetected = false;
  int _bodyDetectedSince = 0;
  Timer? _undetectedTimer;

  @override
  void initState() {
    super.initState();
    _startTracking();
    _undetectedTimer = Timer(const Duration(seconds: 12), () {
      if (!mounted) return;
      if (!_bodyDetected) {
        // Can offer tracking error screen
      }
    });
  }

  Future<void> _startTracking() async {
    PoseLandmarker.setConfig(
      delegate: 0,
      model: 1,
      minPoseDetectionConfidence: 0.5,
      minPoseTrackingConfidence: 0.5,
      minPosePresenceConfidence: 0.5,
      analysisWidth: 480,
      analysisHeight: 360,
    );

    await _subscription?.cancel();

    _subscription = PoseLandmarker.poseLandmarkStream.listen(
      (pose) {
        if (!mounted) return;

        final incoming = pose.landmarks;
        final now = _clock.elapsedMilliseconds;

        setState(() {
          if (incoming.isEmpty) {
            _landmarks = [];
            _bodyDetected = false;
            _angles = {};
            _speeds = {};
            _posture.reset();
            return;
          }

          _landmarks = incoming;
          _bodyDetected = incoming.length >= 25;
          if (_bodyDetected && _bodyDetectedSince == 0) {
            _bodyDetectedSince = now;
          } else if (!_bodyDetected) {
            _bodyDetectedSince = 0;
          }

          _angles = JointAngleCalculator.all(_landmarks);
          _motion.update(_angles, now);
          _speeds = Map<int, double>.from(_motion.speed);
          _posture.update(_landmarks, now);
        });
      },
      onError: (Object error) {
        debugPrint('Pose tracking error: $error');
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _undetectedTimer?.cancel();
    super.dispose();
  }

  void _onReady() {
    context.pushReplacement('/session/${widget.exerciseId}/live');
  }

  @override
  Widget build(BuildContext context) {
    final readyToStart = _bodyDetected;
    final exercise = seedExercises.firstWhere(
      (e) => e.id == widget.exerciseId,
      orElse: () => seedExercises.first,
    );
    final viewInstruction = exercise.cameraView.toLowerCase() == 'front' ? 'Front' : 'Side';

    return Scaffold(
      backgroundColor: RSColors.surfaceCamera,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Camera Feed ──────────────────────────────────────────
          const NativeCameraPreview(),

          // ── Real Skeleton Overlay ────────────────────────────────
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: SkeletonPainter(
                  landmarks: _landmarks,
                  mirrorX: _frontCamera ? kMirrorFrontCameraX : kMirrorRearCameraX,
                  flipY: _frontCamera ? false : kFlipRearCameraY,
                  skeletonColor: _bodyDetected ? kGoodColor : kTealColor,
                  angles: _angles,
                  speeds: _speeds,
                  showAngles: true,
                  showSpeed: false,
                ),
              ),
            ),
          ),

          // ── Top Glass Bar ────────────────────────────────────────
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    RSIconButton.glass(
                      icon: LucideIcons.chevronLeft,
                      onPressed: () {
                        _subscription?.cancel();
                        context.pop();
                      },
                      semanticLabel: 'Back',
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Position yourself',
                      style: RSText.headingH3.copyWith(color: RSColors.textOnDark),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _bodyDetected
                            ? RSColors.statusSuccess.withOpacity(0.85)
                            : Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(RSRadius.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _bodyDetected ? LucideIcons.checkCircle : LucideIcons.scan,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _bodyDetected ? 'Body detected' : 'Detecting body...',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom Instruction Card ──────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: RSColors.surfaceCard,
                borderRadius: RSRadius.sheetBR,
                boxShadow: RSShadows.sheet,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: RSColors.brandMint,
                          borderRadius: BorderRadius.circular(RSRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.camera, size: 14, color: RSColors.brandGreen),
                            const SizedBox(width: 6),
                            Text(
                              'Camera Angle: $viewInstruction',
                              style: RSText.captionStrong.copyWith(color: RSColors.brandGreen),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _bodyDetected
                              ? RSColors.statusSuccessTint
                              : RSColors.brandMint,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _bodyDetected ? LucideIcons.check : LucideIcons.info,
                          color: _bodyDetected ? RSColors.statusSuccess : RSColors.brandGreen,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _bodyDetected
                              ? 'Perfect! Stand straight and hold position.'
                              : 'Step back until your shoulders and knees are visible.',
                          style: RSText.bodyStrong,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RSButton.primary(
                    "I'm ready",
                    readyToStart ? _onReady : null,
                    disabled: !readyToStart,
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.push('/session/${widget.exerciseId}/tracking-error');
                      },
                      child: Text(
                        'Body not detected? View tips',
                        style: RSText.captionStrong.copyWith(color: RSColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
