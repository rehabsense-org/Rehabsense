import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shariq_skeleton/core/widgets/widgets.dart';
import 'package:shariq_skeleton/features/doctor/presentation/exercises/doctor_exercise_builder_wizard.dart';
import 'package:shariq_skeleton/features/doctor/presentation/exercises/doctor_exercise_library_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/exercises/doctor_test_camera_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/feedback/doctor_session_review_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/notifications/doctor_notifications_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/profile/doctor_edit_profile_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/profile/doctor_profile_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/profile/doctor_update_credentials_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/settings/doctor_logout_dialog.dart';
import 'package:shariq_skeleton/features/doctor/presentation/settings/doctor_settings_screen.dart';

void main() {
  group('Phase 7 Doctor Portal - Exercise Builder, Reviews & Profile Tests', () {
    testWidgets('DoctorExerciseLibraryScreen renders exercise list and category filters', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorExerciseLibraryScreen(),
        ),
      );

      expect(find.text('Exercise Library'), findsOneWidget);
      expect(find.text('Mini Squat'), findsOneWidget);
      expect(find.text('Wall Sit hold'), findsOneWidget);
      expect(find.text('Warrior II hold'), findsOneWidget);
      expect(find.text('New'), findsOneWidget);

      // Filter by category Yoga
      await tester.tap(find.text('Yoga'));
      await tester.pump();

      expect(find.text('Warrior II hold'), findsOneWidget);
      expect(find.text('Wall Sit hold'), findsNothing);
    });

    testWidgets('DoctorExerciseBuilderWizard advances through 4 steps to review', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorExerciseBuilderWizard(),
        ),
      );

      // Step 1: Basics
      expect(find.text('Basics'), findsWidgets);
      expect(find.text('Exercise Name'), findsOneWidget);
      expect(find.textContaining('Visibility: Private'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 2: Camera & Kind
      expect(find.text('Camera & Kind'), findsWidgets);
      expect(find.text('Tracking Type'), findsOneWidget);
      expect(find.text('Side View'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 3: Tracking Config
      expect(find.text('Tracking Configuration'), findsWidgets);
      expect(find.text('Primary Joint'), findsOneWidget);
      expect(find.text('Test on camera'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Step 4: Review
      expect(find.text('Review & Save'), findsWidgets);
      expect(find.text('Save exercise'), findsOneWidget);
      expect(find.textContaining('Untested'), findsOneWidget);
    });

    testWidgets('DoctorTestCameraScreen renders test mode overlay and actions', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorTestCameraScreen(exerciseId: 'wall_sit_hold'),
        ),
      );

      expect(find.text('TEST MODE · nothing is saved'), findsOneWidget);
      expect(find.text('Camera Feed Preview'), findsOneWidget);
      expect(find.text('Mark as tested'), findsOneWidget);
      expect(find.text('Back to builder'), findsOneWidget);
    });

    testWidgets('DoctorSessionReviewScreen renders movement score, pain alert, and feedback area', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorSessionReviewScreen(sessionId: 'sess_001'),
        ),
      );

      expect(find.text('Session Review'), findsOneWidget);
      expect(find.text('Mini Squat'), findsOneWidget);
      expect(find.text('78'), findsOneWidget); // Movement score
      expect(find.text('High Pain Level: 8 / 10'), findsOneWidget);
      expect(find.text('REP BY REP BREAKDOWN'), findsOneWidget);
      expect(find.text('Send feedback'), findsOneWidget);
      expect(find.textContaining('RehabSense is a guidance tool'), findsOneWidget);
    });

    testWidgets('DoctorNotificationsScreen renders clinical notification items', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorNotificationsScreen(),
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('New request'), findsOneWidget);
      expect(find.text('Pain alert'), findsOneWidget);
      expect(find.text('Request expiring'), findsOneWidget);
      expect(find.text('Patient inactive'), findsOneWidget);
    });

    testWidgets('DoctorProfileScreen renders doctor info and navigation cards', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorProfileScreen(),
        ),
      );

      expect(find.text('Doctor Profile'), findsOneWidget);
      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Edit profile and expertise'), findsOneWidget);
      expect(find.text('Update credentials'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });

    testWidgets('DoctorEditProfileScreen modifies profile and capacity', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorEditProfileScreen(),
        ),
      );

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Professional Title'), findsOneWidget);
      expect(find.text('CLINICAL EXPERTISE'), findsOneWidget);
      expect(find.text('Accepting new patients'), findsOneWidget);
      expect(find.text('Save changes'), findsOneWidget);
    });

    testWidgets('DoctorUpdateCredentialsScreen renders license inputs and documents', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorUpdateCredentialsScreen(),
        ),
      );

      expect(find.text('Credentials & Verification'), findsOneWidget);
      expect(find.textContaining('Updating credentials requires admin re-review'), findsOneWidget);
      expect(find.text('Medical License Number'), findsOneWidget);
      expect(find.text('Medical Practice License'), findsOneWidget);
      expect(find.text('Degree Certificate'), findsOneWidget);
      expect(find.text('Submit for review'), findsOneWidget);
    });

    testWidgets('DoctorSettingsScreen renders security and preference toggles', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorSettingsScreen(),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Change password'), findsOneWidget);
      expect(find.text('Email alerts for requests'), findsOneWidget);
      expect(find.text('High pain alerts'), findsOneWidget);
      expect(find.text('Inactive patient alerts'), findsOneWidget);
    });

    testWidgets('DoctorLogoutDialog renders confirmation and cancel', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DoctorLogoutDialog(),
          ),
        ),
      );

      expect(find.text('Log out?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.widgetWithText(RSButton, 'Log out'), findsOneWidget);
    });
  });
}

