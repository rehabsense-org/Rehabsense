import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shariq_skeleton/core/widgets/widgets.dart';
import 'package:shariq_skeleton/features/doctor/presentation/auth/doctor_application_rejected_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/auth/doctor_documents_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/auth/doctor_forgot_password_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/auth/doctor_inactive_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/auth/doctor_login_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/auth/doctor_otp_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/auth/doctor_register_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/auth/doctor_reset_password_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/auth/doctor_resume_application_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/auth/doctor_submit_review_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/onboarding/doctor_go_live_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/onboarding/doctor_profile_wizard.dart';

void main() {
  group('Phase 5 Doctor Portal Onboarding Tests', () {
    testWidgets('DoctorLoginScreen renders email, password and actions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorLoginScreen(),
        ),
      );

      expect(find.text('Doctor login'), findsOneWidget);
      expect(find.text('Work email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Create doctor account'), findsOneWidget);
    });

    testWidgets('DoctorRegisterScreen renders fields and title choice chips', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorRegisterScreen(),
        ),
      );

      expect(find.text('Doctor Registration'), findsOneWidget);
      expect(find.text('Full Name *'), findsOneWidget);
      expect(find.text('Physiotherapist'), findsOneWidget);
      expect(find.text('Orthopedic Doctor'), findsOneWidget);
      expect(find.text('Continue to verification'), findsOneWidget);
    });

    testWidgets('DoctorOtpScreen renders RSOtpField and verify button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorOtpScreen(email: 'test.doctor@clinic.com'),
        ),
      );

      expect(find.text('Verify your email'), findsOneWidget);
      expect(find.byType(RSOtpField), findsOneWidget);
      expect(find.text('Verify & continue'), findsOneWidget);
    });

    testWidgets('DoctorDocumentsScreen renders step header and credential tiles', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorDocumentsScreen(),
        ),
      );

      expect(find.text('Upload Credentials'), findsOneWidget);
      expect(find.byType(RSDocumentTile), findsNWidgets(2));
      expect(find.text('Review application'), findsOneWidget);
    });

    testWidgets('DoctorSubmitReviewScreen enables submit only when declaration checked', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorSubmitReviewScreen(),
        ),
      );

      expect(find.text('Review & Submit'), findsOneWidget);
      expect(find.text('PRACTITIONER DETAILS'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);

      final submitBtn = tester.widget<RSButton>(find.widgetWithText(RSButton, 'Submit application'));
      expect(submitBtn.disabled, isTrue);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      final activeSubmitBtn = tester.widget<RSButton>(find.widgetWithText(RSButton, 'Submit application'));
      expect(activeSubmitBtn.disabled, isFalse);
    });

    testWidgets('DoctorResumeApplicationScreen renders progress checklist and resume button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorResumeApplicationScreen(),
        ),
      );

      expect(find.text('Finish your registration'), findsOneWidget);
      expect(find.text('REGISTRATION PROGRESS'), findsOneWidget);
      expect(find.text('Resume application'), findsOneWidget);
    });

    testWidgets('DoctorApplicationRejectedScreen renders reviewer reason and resubmit CTA', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorApplicationRejectedScreen(
            rejectionReason: 'License number is blurry.',
          ),
        ),
      );

      expect(find.text('Application needs attention'), findsOneWidget);
      expect(find.text('License number is blurry.'), findsOneWidget);
      expect(find.text('Update documents & resubmit'), findsOneWidget);
    });

    testWidgets('DoctorInactiveScreen renders suspended notice and sign out', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorInactiveScreen(),
        ),
      );

      expect(find.text('Doctor Account Suspended'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);
    });

    testWidgets('DoctorForgotPasswordScreen & ResetPasswordScreen render correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorForgotPasswordScreen(),
        ),
      );

      expect(find.text('Reset Doctor Password'), findsOneWidget);
      expect(find.text('Send reset link'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorResetPasswordScreen(),
        ),
      );

      expect(find.text('Create new password'), findsOneWidget);
      expect(find.text('Save new password'), findsOneWidget);
    });

    testWidgets('DoctorProfileWizard advances through setup steps', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorProfileWizard(),
        ),
      );

      expect(find.text('Professional Basics'), findsOneWidget);
      expect(find.text('Next step'), findsOneWidget);

      await tester.tap(find.text('Next step'));
      await tester.pumpAndSettle();
      expect(find.text('Clinical Expertise'), findsOneWidget);

      await tester.tap(find.text('Next step'));
      await tester.pumpAndSettle();
      expect(find.text('About & Bio'), findsOneWidget);

      await tester.tap(find.text('Next step'));
      await tester.pumpAndSettle();
      expect(find.text('Practice Availability'), findsOneWidget);
      expect(find.text('Preview profile'), findsOneWidget);
    });

    testWidgets('DoctorGoLiveScreen renders doctor card preview and listing criteria', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorGoLiveScreen(),
        ),
      );

      expect(find.text('Patient View Preview'), findsOneWidget);
      expect(find.byType(RSDoctorCard), findsOneWidget);
      expect(find.text('DIRECTORY LISTING CRITERIA'), findsOneWidget);
      expect(find.text('Go live (Publish profile)'), findsOneWidget);
    });
  });
}
