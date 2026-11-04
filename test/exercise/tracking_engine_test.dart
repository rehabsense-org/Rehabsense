import 'package:flutter/material.dart';
import 'package:flutter_mp_pose_landmarker/flutter_mp_pose_landmarker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shariq_skeleton/domain/models/models.dart';
import 'package:shariq_skeleton/domain/pose/pose_tracker.dart';
import 'package:shariq_skeleton/features/courses/presentation/prescribed_courses_screen.dart';
import 'package:shariq_skeleton/features/courses/presentation/prescribed_exercise_detail_screen.dart';
import 'package:shariq_skeleton/features/session/pain_alert_sheet.dart';

void main() {
  group('TrackingConfig Tests', () {
    test('Rep config validates properly and serializes to/from JSON', () {
      const config = TrackingConfig(
        joint: 'knee',
        type: TrackingType.rep,
        startAngle: 170.0,
        targetAngle: 120.0,
        tolerance: 15.0,
        leftLandmarks: [23, 25, 27],
        rightLandmarks: [24, 26, 28],
      );

      expect(config.isValid, isTrue);
      expect(config.type, equals(TrackingType.rep));

      final json = config.toJson();
      expect(json['joint'], equals('knee'));
      expect(json['type'], equals('rep'));
      expect(json['start_angle'], equals(170.0));
      expect(json['target_angle'], equals(120.0));

      final deserialized = TrackingConfig.fromJson(json);
      expect(deserialized.joint, equals('knee'));
      expect(deserialized.type, equals(TrackingType.rep));
      expect(deserialized.startAngle, equals(170.0));
      expect(deserialized.leftLandmarks, equals([23, 25, 27]));
    });

    test('Hold config validates properly and serializes to/from JSON', () {
      const config = TrackingConfig(
        joint: 'knee',
        type: TrackingType.hold,
        minAngle: 80.0,
        maxAngle: 100.0,
        holdSeconds: 30,
        graceSeconds: 2,
      );

      expect(config.isValid, isTrue);
      expect(config.type, equals(TrackingType.hold));

      final json = config.toJson();
      expect(json['type'], equals('hold'));
      expect(json['hold_seconds'], equals(30));

      final deserialized = TrackingConfig.fromJson(json);
      expect(deserialized.type, equals(TrackingType.hold));
      expect(deserialized.minAngle, equals(80.0));
      expect(deserialized.maxAngle, equals(100.0));
      expect(deserialized.holdSeconds, equals(30));
    });

    test('Detects invalid configs', () {
      const invalidRep = TrackingConfig(
        joint: 'knee',
        type: TrackingType.rep,
        startAngle: 100.0,
        targetAngle: 102.0, // difference < 10
      );
      expect(invalidRep.isValid, isFalse);

      const invalidHold = TrackingConfig(
        joint: 'knee',
        type: TrackingType.hold,
        minAngle: 100.0,
        maxAngle: 90.0, // min > max
      );
      expect(invalidHold.isValid, isFalse);
    });
  });

  group('TrackingEngine Logic Tests', () {
    test('Rep Tracking counts reps and marks outcome correct on good form', () {
      const config = TrackingConfig(
        joint: 'knee',
        type: TrackingType.rep,
        startAngle: 170.0,
        targetAngle: 120.0,
        tolerance: 15.0,
      );

      final engine = TrackingEngine(config: config, targetReps: 2);
      expect(engine.isReady, isTrue);
      expect(engine.currentReps, equals(0));

      // Standing straight (170)
      engine.processFrame(
        landmarks: _mockLandmarks,
        angles: {25: 170.0},
        isPostureGood: true,
        nowMs: 1000,
      );
      expect(engine.phase, equals('Ready'));

      // Moving down (140)
      engine.processFrame(
        landmarks: _mockLandmarks,
        angles: {25: 140.0},
        isPostureGood: true,
        nowMs: 1500,
      );
      expect(engine.phase, equals('Moving'));

      // Bottom depth reached (115)
      engine.processFrame(
        landmarks: _mockLandmarks,
        angles: {25: 115.0},
        isPostureGood: true,
        nowMs: 2000,
      );
      expect(engine.phase, equals('Hold'));

      // Returning to standing (170) after cooldown
      engine.processFrame(
        landmarks: _mockLandmarks,
        angles: {25: 170.0},
        isPostureGood: true,
        nowMs: 3500,
      );

      expect(engine.currentReps, equals(1));
      expect(engine.completedReps.length, equals(1));
      expect(engine.completedReps.first.outcome, equals(RepOutcome.correct));
    });

    test('Hold Tracking accumulates hold time and completes rep', () {
      const config = TrackingConfig(
        joint: 'knee',
        type: TrackingType.hold,
        minAngle: 80.0,
        maxAngle: 100.0,
        holdSeconds: 3,
        graceSeconds: 1,
      );

      final engine = TrackingEngine(config: config, targetReps: 1);
      expect(engine.isReady, isTrue);

      // Frame 1: inside hold zone at 90 deg
      engine.processFrame(
        landmarks: _mockLandmarks,
        angles: {25: 90.0},
        isPostureGood: true,
        nowMs: 1000,
      );
      expect(engine.phase, equals('Ready')); // First frame initializes time

      // Frame 2: after 1.5 seconds in range
      engine.processFrame(
        landmarks: _mockLandmarks,
        angles: {25: 90.0},
        isPostureGood: true,
        nowMs: 2500,
      );
      expect(engine.phase, equals('Holding'));
      expect(engine.currentReps, equals(0));

      // Frame 3: after total 3.2 seconds in range
      engine.processFrame(
        landmarks: _mockLandmarks,
        angles: {25: 90.0},
        isPostureGood: true,
        nowMs: 4200,
      );

      expect(engine.currentReps, equals(1));
      expect(engine.isCompleted, isTrue);
      expect(engine.completedReps.first.outcome, equals(RepOutcome.correct));
    });

    test('Invalid config sets warning feedback', () {
      const invalidConfig = TrackingConfig(
        joint: '',
        type: TrackingType.rep,
      );

      final engine = TrackingEngine(config: invalidConfig);
      expect(engine.isReady, isFalse);
      expect(engine.feedbackLine, equals('This exercise is not ready for tracking'));
    });
  });

  group('Prescribed Container & Pain UI Tests', () {
    testWidgets('PainAlertSheet displays warning, disclaimer and handles dismiss', (tester) async {
      bool acknowledged = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PainAlertSheet(
              painLevel: 8,
              onAcknowledge: () => acknowledged = true,
            ),
          ),
        ),
      );

      expect(find.text('High pain reported (8 / 10)'), findsOneWidget);
      expect(find.textContaining('RehabSense is a guidance tool'), findsOneWidget);
      expect(find.text('I understand'), findsOneWidget);

      await tester.tap(find.text('I understand'));
      await tester.pump();
      expect(acknowledged, isTrue);
    });

    testWidgets('PrescribedCoursesScreen renders exercise list and prescription header', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PrescribedCoursesScreen(),
        ),
      );

      expect(find.text('Prescribed Exercises'), findsOneWidget);
      expect(find.text('Prescribed by Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Mini Squat'), findsOneWidget);
      expect(find.text('Straight-Leg Raise'), findsOneWidget);
      expect(find.text('Wall Sit hold'), findsOneWidget);
    });

    testWidgets('PrescribedExerciseDetailScreen renders targets and clinical disclaimer', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: PrescribedExerciseDetailScreen(assignmentId: 'assign_001'),
        ),
      );

      expect(find.text('Prescribed by Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Start exercise'), findsOneWidget);
      expect(find.text('HOW TO PERFORM'), findsOneWidget);
      expect(find.textContaining('RehabSense is a guidance tool'), findsOneWidget);
    });
  });
}

// Simple mock landmark list to avoid crashing presence check
final List<PoseLandmarkPoint> _mockLandmarks = List.generate(
  33,
  (i) => PoseLandmarkPoint(
    x: 0.5,
    y: 0.5,
    z: 0.0,
    presence: 0.9,
    visibility: 0.9,
  ),
);
