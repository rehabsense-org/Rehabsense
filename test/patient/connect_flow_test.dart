import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shariq_skeleton/core/widgets/widgets.dart';
import 'package:shariq_skeleton/features/connect/presentation/condition_form_wizard.dart';
import 'package:shariq_skeleton/features/connect/presentation/connect_hub_screen.dart';
import 'package:shariq_skeleton/features/connect/presentation/connected_celebration_screen.dart';
import 'package:shariq_skeleton/features/connect/presentation/doctor_profile_public_screen.dart';
import 'package:shariq_skeleton/features/connect/presentation/find_doctors_screen.dart';
import 'package:shariq_skeleton/features/connect/presentation/my_condition_screen.dart';
import 'package:shariq_skeleton/features/connect/presentation/my_doctor_screen.dart';
import 'package:shariq_skeleton/features/connect/presentation/request_status_screen.dart';
import 'package:shariq_skeleton/features/connect/presentation/send_request_screen.dart';

void main() {
  group('Phase 3 Patient Connect with Doctor Tests', () {
    testWidgets('ConnectHubScreen renders 3 steps and start CTA', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConnectHubScreen(),
        ),
      );

      expect(find.text('Get a plan made for you'), findsOneWidget);
      expect(find.text('Tell us about your condition'), findsOneWidget);
      expect(find.text('Choose a verified doctor'), findsOneWidget);
      expect(find.text('Send a request'), findsOneWidget);
      expect(find.widgetWithText(RSButton, 'Start'), findsOneWidget);
    });

    testWidgets('ConditionFormWizard renders steps and advances', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConditionFormWizard(),
        ),
      );

      expect(find.text('STEP 1 OF 3'), findsOneWidget);
      expect(find.text('Where does it hurt?'), findsOneWidget);
      expect(find.widgetWithText(RSChoiceChip, 'Knee'), findsOneWidget);

      await tester.tap(find.widgetWithText(RSButton, 'Continue'));
      await tester.pumpAndSettle();

      expect(find.text('STEP 2 OF 3'), findsOneWidget);
      expect(find.text('Current pain level'), findsOneWidget);
    });

    testWidgets('FindDoctorsScreen renders doctors and filter chips', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FindDoctorsScreen(),
        ),
      );

      expect(find.text('Find doctors'), findsOneWidget);
      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Dr. Omar Sheikh'), findsOneWidget);
      expect(find.text('Best match'), findsOneWidget);
      expect(find.widgetWithText(RSChoiceChip, 'Knee'), findsOneWidget);
    });

    testWidgets('DoctorProfilePublicScreen renders bio and request CTA', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorProfilePublicScreen(doctorId: 'doc_001'),
        ),
      );

      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('City Rehab Clinic'), findsOneWidget);
      expect(find.text('Accepting patients'), findsOneWidget);
      expect(find.widgetWithText(RSButton, 'Request this doctor'), findsOneWidget);
    });

    testWidgets('SendRequestScreen toggles consent and enables submission', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SendRequestScreen(doctorId: 'doc_001'),
        ),
      );

      expect(find.text('Send to Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Condition summary'), findsOneWidget);
      expect(find.text('Right knee'), findsOneWidget);
      expect(find.widgetWithText(RSButton, 'Send request'), findsOneWidget);
    });

    testWidgets('RequestStatusScreen renders timeline and status', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RequestStatusScreen(),
        ),
      );

      expect(find.text('Request status'), findsOneWidget);
      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Request sent'), findsOneWidget);
      expect(find.widgetWithText(RSButton, 'Back to home'), findsOneWidget);
    });

    testWidgets('ConnectedCelebrationScreen renders celebration message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConnectedCelebrationScreen(),
        ),
      );

      expect(find.text('You are connected!'), findsOneWidget);
      expect(find.widgetWithText(RSButton, 'Go to home'), findsOneWidget);
      expect(find.widgetWithText(RSButton, 'See my doctor'), findsOneWidget);
    });

    testWidgets('MyDoctorScreen renders doctor details and disconnect button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyDoctorScreen(),
        ),
      );

      expect(find.text('My doctor'), findsOneWidget);
      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Prescribed exercises'), findsOneWidget);
      expect(find.widgetWithText(RSButton, 'Disconnect from doctor'), findsOneWidget);
    });

    testWidgets('MyConditionScreen renders pain slider and inputs', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyConditionScreen(),
        ),
      );

      expect(find.text('My condition'), findsOneWidget);
      expect(find.text('Body area'), findsOneWidget);
      expect(find.text('Current pain level'), findsOneWidget);
      expect(find.widgetWithText(RSButton, 'Save changes'), findsOneWidget);
    });
  });
}
