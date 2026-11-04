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

class CameraSetupScreen extends StatefulWidget {
  final String exerciseId;
  final bool initialIsExercising;

  const CameraSetupScreen({
    super.key,
    required this.exerciseId,
    this.initialIsExercising = false,
  });

  @override
  State<CameraSetupScreen> createState() => _CameraSetupScreenState();
}

class _CameraSetupScreenState extends State<CameraSetupScreen> {
  late bool _isExercising;
  StreamSubscription<PoseLandMarker>? _subscription;
  final Stopwatch _sessionStopwatch = Stopwatch();
  final Stopwatch _clock = Stopwatch()..start();

  final MotionTracker _motion = MotionTracker();
  final PostureChecker _posture = PostureChecker();

  List<PoseLandmarkPoint> _landmarks = [];
  Map<int, double?> _angles = {};
  Map<int, double> _speeds = {};

  final bool _frontCamera = true;
  bool _audioEnabled = true;
  bool _bodyDetected = false;
  int _bodyDetectedSince = 0;
  Timer? _undetectedTimer;
  Timer? _uiTimer;

  // Rep tracking state
  int _currentReps = 0;
  final int _targetReps = 10;
  String _phase = 'Ready';
  String _feedbackLine = 'Keep your shoulders level and chest up';
  Color _feedbackColor = RSColors.statusSuccess;
  IconData _feedbackIcon = LucideIcons.checkCircle;

  final List<RSRep> _completedReps = [];
  bool _isDown = false;
  int _lastRepTime = 0;

  @override
  void initState() {
    super.initState();
    _isExercising = widget.initialIsExercising;
    if (_isExercising) {
      _sessionStopwatch.start();
    }
    _startTracking();
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    _undetectedTimer = Timer(const Duration(seconds: 12), () {
      if (!mounted) return;
      if (!_bodyDetected && !_isExercising) {
        // tips can be shown or offered
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

          if (_isExercising) {
            _processRepStateMachine(now);
          }
        });
      },
      onError: (Object error) {
        debugPrint('Pose tracking error: $error');
      },
    );
  }

  void _onStartExercise() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isExercising = true;
      if (!_sessionStopwatch.isRunning) {
        _sessionStopwatch.start();
      }
    });
  }

  void _processRepStateMachine(int now) {
    final kneeAngle = _angles[25] ?? _angles[26];
    if (kneeAngle == null) return;

    if (kneeAngle < 120 && !_isDown) {
      _isDown = true;
      _phase = 'Moving down';
      _feedbackLine = 'Good depth, keep your back straight';
      _feedbackColor = RSColors.statusSuccess;
      _feedbackIcon = LucideIcons.checkCircle;
    } else if (kneeAngle < 100 && _isDown && _phase == 'Moving down') {
      _phase = 'Hold';
      _feedbackLine = 'Hold steady...';
    } else if (kneeAngle > 155 && _isDown && now - _lastRepTime > 1500) {
      _isDown = false;
      _phase = 'Ready';
      _currentReps++;
      _lastRepTime = now;

      final isPostureGood = _posture.status != PostureStatus.bad;
      final outcome = isPostureGood ? RepOutcome.correct : RepOutcome.incorrect;

      _completedReps.add(
        RSRep(
          index: _currentReps,
          outcome: outcome,
          peakAngle: kneeAngle,
          durationMs: 2200,
          feedbackKey: isPostureGood ? 'good_form' : 'knee_valgus',
        ),
      );

      HapticFeedback.mediumImpact();

      if (isPostureGood) {
        _feedbackLine = 'Rep $_currentReps: Great form!';
        _feedbackColor = RSColors.statusSuccess;
        _feedbackIcon = LucideIcons.checkCircle;
      } else {
        _feedbackLine = 'Rep $_currentReps: Watch your knee alignment';
        _feedbackColor = RSColors.statusWarningInk;
        _feedbackIcon = LucideIcons.alertTriangle;
      }

      if (_currentReps >= _targetReps) {
        _finishSession();
      }
    }
  }

  void _finishSession() {
    _subscription?.cancel();
    _uiTimer?.cancel();
    _sessionStopwatch.stop();
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
            "You've completed $_currentReps of $_targetReps reps. The remaining reps will be recorded as incomplete.",
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
    _undetectedTimer?.cancel();
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
    final readyToStart = _bodyDetected;

    return PopScope(
      canPop: !_isExercising,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isExercising) {
          _showEndDialog();
        }
      },
      child: Scaffold(
        backgroundColor: RSColors.surfaceCamera,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── Camera Feed (Always preserved, continuous) ──────────
            const NativeCameraPreview(),

            // ── Real Skeleton Overlay ────────────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: SkeletonPainter(
                    landmarks: _landmarks,
                    mirrorX: _frontCamera ? kMirrorFrontCameraX : kMirrorRearCameraX,
                    flipY: _frontCamera ? false : kFlipRearCameraY,
                    skeletonColor: _isExercising
                        ? (_posture.status == PostureStatus.bad ? kBadColor : kGoodColor)
                        : (_bodyDetected ? kGoodColor : kTealColor),
                    angles: _angles,
                    speeds: _speeds,
                    showAngles: true,
                    showSpeed: false,
                  ),
                ),
              ),
            ),

            // ── Top Bar ──────────────────────────────────────────
            if (!_isExercising)
              // Setup Top Bar
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // Live Tracking Top Bar
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

            // ── Floating angle indicator near tracked joint (Live) ──
            if (_isExercising && trackedAngle != null)
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
                        'Knee: ${trackedAngle.round()}° • Target: 90°',
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

            // ── Bottom Panel ─────────────────────────────────────
            if (!_isExercising)
              // Setup Instruction Card
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
                              color: _bodyDetected
                                  ? RSColors.statusSuccess
                                  : RSColors.brandGreen,
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
                        'Start exercise',
                        readyToStart ? _onStartExercise : null,
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
              )
            else
              // Live Tracking Bottom Panel
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
                                  'REPS',
                                  style: RSText.labelOverline.copyWith(color: RSColors.textSecondary),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '$_currentReps',
                                      style: RSText.displayMetric.copyWith(color: RSColors.brandAction),
                                    ),
                                    Text(
                                      ' / $_targetReps',
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
                                _phase,
                                style: RSText.captionStrong.copyWith(color: RSColors.brandGreen),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        RSProgressBar(
                          value: _currentReps / _targetReps,
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
                              Icon(_feedbackIcon, size: 18, color: _feedbackColor),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _feedbackLine,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: RSText.bodySmallStrong.copyWith(color: _feedbackColor),
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
