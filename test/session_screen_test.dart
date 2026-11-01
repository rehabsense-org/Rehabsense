import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shariq_skeleton/features/session/camera_setup_screen.dart';
import 'package:shariq_skeleton/features/session/live_tracking_screen.dart';

void main() {
  testWidgets('CameraSetupScreen displays setup UI initially', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CameraSetupScreen(exerciseId: 'knee_mini_squat'),
      ),
    );

    expect(find.text('Position yourself'), findsOneWidget);
    expect(find.text('Start exercise'), findsOneWidget);
    expect(find.text('Detecting body...'), findsOneWidget);
  });

  testWidgets('LiveTrackingScreen displays exercise HUD directly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LiveTrackingScreen(exerciseId: 'knee_mini_squat'),
      ),
    );

    expect(find.text('REPS'), findsOneWidget);
    expect(find.text('End session'), findsOneWidget);
  });
}
