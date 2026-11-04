import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mp_pose_landmarker/flutter_mp_pose_landmarker.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/seed/seed_data.dart';
import '../../domain/models/models.dart';
import '../../domain/pose/pose_tracker.dart';

class LiveTrackingScreen extends StatefulWidget {
  final String exerciseId;

  const LiveTrackingScreen({super.key, required this.exerciseId});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  StreamSubscription<PoseLandMarker>? _subscription;
  final Stopwatch _sessionStopwatch = Stopwatch()..start();
  final Stopwatch _clock = Stopwatch()..start();

  final MotionTracker _motion = MotionTracker();
  final PostureChecker _posture = PostureChecker();

  late final RSExercise _exercise;
  late final TrackingEngine _engine;

  List<PoseLandmarkPoint> _landmarks = [];
  Map<int, double?> _angles = {};
  Map<int, double> _speeds = {};

  bool _frontCamera = true;
  bool _audioEnabled = true;

  Timer? _uiTimer;

  @override
  void initState() {
    super.initState();
    _exercise = seedExercises.firstWhere(
      (e) => e.id == widget.exerciseId,
      orElse: () => seedExercises.first,
    );
    final config = _exercise.trackingConfig ?? TrackingConfig.defaultSquat;
    _engine = TrackingEngine(
      config: config,
      targetReps: _exercise.targetReps,
    );

    _startTracking();
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
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
            _angles = {};
            _speeds = {};
            _posture.reset();
            return;
          }

          _landmarks = incoming;
          _angles = JointAngleCalculator.all(_landmarks);
          _motion.update(_angles, now);
          _speeds = Map<int, double>.from(_motion.speed);
          _posture.update(_landmarks, now);

          final prevCount = _engine.currentReps;
          _engine.processFrame(
            landmarks: _landmarks,
            angles: _angles,
            isPostureGood: _posture.status != PostureStatus.bad,
            nowMs: now,
          );

          if (_engine.currentReps > prevCount) {
            HapticFeedback.mediumImpact();
          }

          if (_engine.isCompleted) {
            _finishSession();
          }
        });
      },
      onError: (Object error) {
        debugPrint('Live tracking error: $error');
      },
    );
  }

  void _finishSession() {
    _subscription?.cancel();
    _uiTimer?.cancel();
    _sessionStopwatch.stop();

    // Navigate to Summary (19)
    context.pushReplacement('/session/${widget.exerciseId}/summary');
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      barrierColor: RSColors.overlayScrim,
      builder: (ctx) => RSDialog(
        icon: LucideIcons.alertCircle,
        iconBgColor: RSColors.statusWarningTint,
        iconColor: RSColors.statusWarningInk,
        title: 'End this session?',
        body:
            "You've completed ${_engine.currentReps} of ${_engine.targetReps} reps. The remaining reps will be recorded as incomplete.",
        primaryButtonLabel: 'Continue exercise',
        onPrimaryPressed: () {},
        secondaryButtonLabel: 'Finish session',
        isSecondaryDestructive: true,
        onSecondaryPressed: () => _finishSession(),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _uiTimer?.cancel();
    _sessionStopwatch.stop();
    super.dispose();
  }

  String get _formattedTime {
    final s = _sessionStopwatch.elapsed.inSeconds;
    final m = s ~/ 60;
    final remS = s % 60;
    return '${m.toString().padLeft(2, '0')}:${remS.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final exercise = seedExercises.firstWhere(
      (e) => e.id == widget.exerciseId,
      orElse: () => seedExercises.first,
    );

    final trackedAngle = _angles[25] ?? _angles[26];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showEndDialog();
        }
      },
      child: Scaffold(
        backgroundColor: RSColors.surfaceCamera,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── Camera Feed ────────────────────────────────────────
            const NativeCameraPreview(),

            // ── Skeleton Overlay ───────────────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: SkeletonPainter(
                    landmarks: _landmarks,
                    mirrorX: _frontCamera ? kMirrorFrontCameraX : kMirrorRearCameraX,
                    flipY: _frontCamera ? false : kFlipRearCameraY,
                    skeletonColor: _posture.status == PostureStatus.bad ? kBadColor : kGoodColor,
                    angles: _angles,
                    speeds: _speeds,
                    showAngles: true,
                    showSpeed: false,
                  ),
                ),
              ),
            ),

            // ── Top Bar: Exercise name, timer pill, audio toggle ───
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            exercise.name,
                            style: RSText.bodyStrong.copyWith(color: RSColors.textOnDark),
                          ),
                          Text(
                            'Set 1 of ${exercise.targetSets}',
                            style: RSText.caption.copyWith(color: RSColors.textOnDarkSoft),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Glass timer pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(RSRadius.pill),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.clock, size: 14, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              _formattedTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Audio toggle
                      RSIconButton.glass(
                        icon: _audioEnabled ? LucideIcons.volume2 : LucideIcons.volumeX,
                        onPressed: () {
                          setState(() => _audioEnabled = !_audioEnabled);
                        },
                        semanticLabel: 'Toggle audio',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Floating angle indicator near tracked joint ────────
            if (trackedAngle != null)
              Positioned(
                top: 100,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(RSRadius.pill),
                    border: Border.all(color: RSColors.brandMint.withOpacity(0.6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: RSColors.brandMint,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_engine.config.joint.toUpperCase()}: ${trackedAngle.round()}° • '
                        '${_engine.config.type == TrackingType.hold ? 'Target: ${_engine.config.minAngle.toInt()}-${_engine.config.maxAngle.toInt()}°' : 'Target: ${_engine.config.targetAngle.toInt()}°'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Not Ready Banner if config is invalid ──────────────
            if (!_engine.isReady)
              Positioned(
                top: 140,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: RSColors.statusWarningTint,
                    borderRadius: BorderRadius.circular(RSRadius.card),
                    border: Border.all(color: RSColors.statusWarningInk),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.alertTriangle, color: RSColors.statusWarningInk),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This exercise is not ready for tracking.',
                          style: RSText.bodySmallStrong.copyWith(color: RSColors.statusWarningInk),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Bottom Panel (Rule 1: skeleton, reps, 1 feedback, audio, pause, end)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: RSColors.surfaceCard,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: RSShadows.sheet,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _engine.config.type == TrackingType.hold ? 'HOLD SETS' : 'REPS',
                                style: RSText.labelOverline.copyWith(color: RSColors.textSecondary),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${_engine.currentReps}',
                                    style: RSText.displayMetric.copyWith(color: RSColors.brandAction),
                                  ),
                                  Text(
                                    ' / ${_engine.targetReps}',
                                    style: RSText.headingH2.copyWith(color: RSColors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Phase chip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: RSColors.brandMint,
                              borderRadius: BorderRadius.circular(RSRadius.pill),
                            ),
                            child: Text(
                              _engine.phase,
                              style: RSText.captionStrong.copyWith(color: RSColors.brandGreen),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RSProgressBar(
                        value: _engine.targetReps > 0
                            ? (_engine.currentReps / _engine.targetReps).clamp(0.0, 1.0)
                            : 0.0,
                        height: 6,
                        fillColor: RSColors.brandAction,
                      ),
                      const SizedBox(height: 14),

                      // One line of live feedback
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: RSColors.surfaceCeramic,
                          borderRadius: BorderRadius.circular(RSRadius.card),
                        ),
                        child: Row(
                          children: [
                            Icon(_engine.feedbackIcon, size: 18, color: _engine.feedbackColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _engine.feedbackLine,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: RSText.bodySmallStrong.copyWith(color: _engine.feedbackColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Controls row: Pause IconButton (52, filled) + End session (Secondary Large)
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: RSColors.brandDeep,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(LucideIcons.pause, color: Colors.white, size: 24),
                              onPressed: () {
                                context.push('/session/${widget.exerciseId}/paused');
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RSButton.secondary(
                              'End session',
                              _showEndDialog,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
