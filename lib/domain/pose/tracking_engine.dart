import 'package:flutter/material.dart';
import 'package:flutter_mp_pose_landmarker/flutter_mp_pose_landmarker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../models/models.dart';
import 'pose_tracker.dart';

class TrackingEngine {
  final TrackingConfig config;
  final int targetReps;

  int currentReps = 0;
  String phase = 'Ready';
  String feedbackLine = 'Position yourself in front of the camera';
  Color feedbackColor = RSColors.statusSuccess;
  IconData feedbackIcon = LucideIcons.checkCircle;

  final List<RSRep> completedReps = [];

  // State variables for rep tracking
  bool _isInMovement = false;
  int _lastRepTimestamp = 0;
  double? _peakAngle;
  int _repStartTime = 0;

  // State variables for hold tracking
  int _heldMs = 0;
  int _lastFrameMs = 0;
  int _outOfRangeStartMs = 0;
  int holdRemainingSeconds = 0;

  double? currentAngle;
  bool isCompleted = false;

  TrackingEngine({
    required this.config,
    this.targetReps = 10,
  }) {
    if (!config.isValid) {
      feedbackLine = 'This exercise is not ready for tracking';
      feedbackColor = RSColors.statusWarningInk;
      feedbackIcon = LucideIcons.alertTriangle;
      phase = 'Configuration Error';
    } else {
      holdRemainingSeconds = config.holdSeconds;
    }
  }

  bool get isReady => config.isValid;

  /// Resolve the active joint angle from landmarks or computed angles
  double? extractJointAngle(
    List<PoseLandmarkPoint> landmarks,
    Map<int, double?> angles,
  ) {
    if (landmarks.isEmpty) return null;

    // 1. Try explicit landmark triplets if defined in config
    if (config.leftLandmarks != null && config.leftLandmarks!.length == 3) {
      final leftAngle = JointAngleCalculator.angle(
        landmarks,
        config.leftLandmarks![0],
        config.leftLandmarks![1],
        config.leftLandmarks![2],
      );
      if (leftAngle != null) return leftAngle;
    }

    if (config.rightLandmarks != null && config.rightLandmarks!.length == 3) {
      final rightAngle = JointAngleCalculator.angle(
        landmarks,
        config.rightLandmarks![0],
        config.rightLandmarks![1],
        config.rightLandmarks![2],
      );
      if (rightAngle != null) return rightAngle;
    }

    // 2. Fallback based on joint name
    switch (config.joint.toLowerCase()) {
      case 'knee':
        return angles[25] ?? angles[26];
      case 'elbow':
        return angles[13] ?? angles[14];
      case 'shoulder':
        return angles[11] ?? angles[12];
      case 'hip':
        return angles[23] ?? angles[24];
      default:
        // Default to knee indices if available
        return angles[25] ?? angles[26] ?? angles.values.firstWhere((a) => a != null, orElse: () => null);
    }
  }

  /// Process each incoming video frame
  void processFrame({
    required List<PoseLandmarkPoint> landmarks,
    required Map<int, double?> angles,
    required bool isPostureGood,
    required int nowMs,
  }) {
    if (!config.isValid || isCompleted) return;

    final angle = extractJointAngle(landmarks, angles);
    currentAngle = angle;
    if (angle == null) return;

    if (config.type == TrackingType.rep) {
      _processRep(angle, isPostureGood, nowMs);
    } else {
      _processHold(angle, isPostureGood, nowMs);
    }
  }

  void _processRep(double angle, bool isPostureGood, int nowMs) {
    final start = config.startAngle;
    final target = config.targetAngle;
    final movingTowardsSmaller = target < start;

    // Track peak angle achieved during this rep movement
    if (_isInMovement) {
      if (_peakAngle == null) {
        _peakAngle = angle;
      } else {
        if (movingTowardsSmaller) {
          if (angle < _peakAngle!) _peakAngle = angle;
        } else {
          if (angle > _peakAngle!) _peakAngle = angle;
        }
      }
    }

    // Transition 1: Initiating movement towards target
    final hasStartedMovement = movingTowardsSmaller
        ? (angle < start - config.tolerance)
        : (angle > start + config.tolerance);

    if (hasStartedMovement && !_isInMovement) {
      _isInMovement = true;
      _repStartTime = nowMs;
      _peakAngle = angle;
      phase = 'Moving';
      feedbackLine = 'Keep your back straight and control the motion';
      feedbackColor = RSColors.statusSuccess;
      feedbackIcon = LucideIcons.activity;
    }

    // Transition 2: In target depth zone
    final inTargetZone = movingTowardsSmaller
        ? (angle <= target + config.tolerance)
        : (angle >= target - config.tolerance);

    if (inTargetZone && _isInMovement) {
      phase = 'Hold';
      feedbackLine = 'Good depth, now return steadily';
    }

    // Transition 3: Returning back near start angle completes the rep
    final returnedToStart = movingTowardsSmaller
        ? (angle >= start - config.tolerance)
        : (angle <= start + config.tolerance);

    if (returnedToStart && _isInMovement && (nowMs - _lastRepTimestamp > 1200)) {
      _isInMovement = false;
      _lastRepTimestamp = nowMs;
      currentReps++;

      final reachedTarget = movingTowardsSmaller
          ? (_peakAngle != null && _peakAngle! <= target + config.tolerance)
          : (_peakAngle != null && _peakAngle! >= target - config.tolerance);

      final outcome = (!reachedTarget)
          ? RepOutcome.incomplete
          : (isPostureGood ? RepOutcome.correct : RepOutcome.incorrect);

      final duration = nowMs - _repStartTime;
      completedReps.add(
        RSRep(
          index: currentReps,
          outcome: outcome,
          peakAngle: _peakAngle ?? angle,
          durationMs: duration > 0 ? duration : 2000,
          feedbackKey: outcome == RepOutcome.correct
              ? 'good_form'
              : (outcome == RepOutcome.incomplete ? 'incomplete_rom' : 'posture_issue'),
        ),
      );

      _peakAngle = null;
      phase = 'Ready';

      if (outcome == RepOutcome.correct) {
        feedbackLine = 'Rep $currentReps: Great form!';
        feedbackColor = RSColors.statusSuccess;
        feedbackIcon = LucideIcons.checkCircle;
      } else if (outcome == RepOutcome.incomplete) {
        feedbackLine = 'Rep $currentReps: Try to reach full depth';
        feedbackColor = RSColors.statusWarningInk;
        feedbackIcon = LucideIcons.minusCircle;
      } else {
        feedbackLine = 'Rep $currentReps: Watch your posture alignment';
        feedbackColor = RSColors.statusError;
        feedbackIcon = LucideIcons.alertTriangle;
      }

      if (currentReps >= targetReps) {
        isCompleted = true;
      }
    }
  }

  void _processHold(double angle, bool isPostureGood, int nowMs) {
    if (_lastFrameMs == 0) {
      _lastFrameMs = nowMs;
      return;
    }
    final dt = nowMs - _lastFrameMs;
    _lastFrameMs = nowMs;

    final inRange = angle >= config.minAngle && angle <= config.maxAngle;

    if (inRange) {
      _outOfRangeStartMs = 0;
      _heldMs += dt;
      phase = 'Holding';

      final totalHoldMs = config.holdSeconds * 1000;
      final remainingMs = (totalHoldMs - _heldMs).clamp(0, totalHoldMs);
      holdRemainingSeconds = (remainingMs / 1000).ceil();

      feedbackLine = 'Holding steady... ${holdRemainingSeconds}s remaining';
      feedbackColor = RSColors.statusSuccess;
      feedbackIcon = LucideIcons.clock;

      if (_heldMs >= totalHoldMs) {
        currentReps++;
        completedReps.add(
          RSRep(
            index: currentReps,
            outcome: isPostureGood ? RepOutcome.correct : RepOutcome.incorrect,
            peakAngle: angle,
            durationMs: _heldMs,
            holdSeconds: config.holdSeconds,
            feedbackKey: isPostureGood ? 'hold_success' : 'hold_posture_issue',
          ),
        );

        _heldMs = 0;
        holdRemainingSeconds = config.holdSeconds;

        if (currentReps >= targetReps) {
          isCompleted = true;
          phase = 'Completed';
          feedbackLine = 'Hold completed! Well done!';
          feedbackColor = RSColors.statusSuccess;
          feedbackIcon = LucideIcons.checkCircle;
        } else {
          phase = 'Rest';
          feedbackLine = 'Set $currentReps completed. Get ready for next hold.';
        }
      }
    } else {
      if (_outOfRangeStartMs == 0) {
        _outOfRangeStartMs = nowMs;
      }
      final outDurationMs = nowMs - _outOfRangeStartMs;
      final graceMs = config.graceSeconds * 1000;

      if (outDurationMs > graceMs) {
        phase = 'Adjust';
        feedbackLine = angle < config.minAngle
            ? 'Open your joint angle slightly'
            : 'Bend further into the target range';
        feedbackColor = RSColors.statusWarningInk;
        feedbackIcon = LucideIcons.alertTriangle;
      } else {
        feedbackLine = 'Stay in the target zone (${config.minAngle.toInt()}° - ${config.maxAngle.toInt()}°)';
        feedbackColor = RSColors.statusWarningInk;
      }
    }
  }

  void reset() {
    currentReps = 0;
    phase = 'Ready';
    feedbackLine = 'Ready to begin';
    feedbackColor = RSColors.statusSuccess;
    feedbackIcon = LucideIcons.checkCircle;
    completedReps.clear();
    _isInMovement = false;
    _lastRepTimestamp = 0;
    _peakAngle = null;
    _heldMs = 0;
    _lastFrameMs = 0;
    _outOfRangeStartMs = 0;
    holdRemainingSeconds = config.holdSeconds;
    currentAngle = null;
    isCompleted = false;
  }
}

