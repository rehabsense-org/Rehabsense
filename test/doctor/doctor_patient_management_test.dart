import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shariq_skeleton/core/widgets/widgets.dart';
import 'package:shariq_skeleton/features/doctor/presentation/assignments/doctor_assign_wizard.dart';
import 'package:shariq_skeleton/features/doctor/presentation/dashboard/doctor_home_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/patients/doctor_patient_condition_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/patients/doctor_patient_detail_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/patients/doctor_patient_plan_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/patients/doctor_patient_sessions_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/patients/doctor_patients_list_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/requests/doctor_decline_sheet.dart';
import 'package:shariq_skeleton/features/doctor/presentation/requests/doctor_request_detail_screen.dart';
import 'package:shariq_skeleton/features/doctor/presentation/requests/doctor_requests_screen.dart';

void main() {
  group('Phase 6 Doctor Portal - Patient Management Tests', () {
    testWidgets('DoctorHomeScreen renders KPIs, priority pain alert and menu links', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorHomeScreen(),
        ),
      );

      expect(find.text('Good morning, Doctor'), findsOneWidget);
      expect(find.text('NEW REQUESTS'), findsOneWidget);
      expect(find.text('ACTIVE PATIENTS'), findsOneWidget);
      expect(find.textContaining('High Pain Alert: Marcus Vance'), findsOneWidget);
      expect(find.text('Review Patient Requests'), findsOneWidget);
      expect(find.text('My Patients Caseload'), findsOneWidget);
    });

    testWidgets('DoctorRequestsScreen renders tabs and request cards', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorRequestsScreen(),
        ),
      );

      expect(find.text('Patient Requests'), findsOneWidget);
      expect(find.text('Alex Mercer'), findsOneWidget);
      expect(find.text('Right Knee'), findsOneWidget);
      expect(find.text('Fatima Al-Sayed'), findsOneWidget);
    });

    testWidgets('DoctorRequestDetailScreen renders intake summary and actions', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorRequestDetailScreen(requestId: 'req_001'),
        ),
      );

      expect(find.text('Alex Mercer'), findsOneWidget);
      expect(find.text('REPORTED CONDITION'), findsOneWidget);
      expect(find.text('No Red Flags Reported'), findsOneWidget);
      expect(find.text('Accept patient'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
      expect(find.textContaining('RehabSense is a guidance tool'), findsOneWidget);
    });

    testWidgets('DoctorDeclineSheet selects reason and calls confirm', (tester) async {
      String? selectedReason;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DoctorDeclineSheet(
              patientName: 'Alex Mercer',
              onConfirm: (reason) => selectedReason = reason,
            ),
          ),
        ),
      );

      expect(find.text('Decline Request'), findsOneWidget);
      expect(find.text('Caseload full'), findsOneWidget);
      expect(find.text('Outside clinical specialty'), findsOneWidget);

      await tester.tap(find.text('Outside clinical specialty'));
      await tester.pump();

      await tester.tap(find.widgetWithText(RSButton, 'Decline request'));
      await tester.pump();

      expect(selectedReason, contains('Outside clinical specialty'));
    });

    testWidgets('DoctorPatientsListScreen searches and filters patients', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorPatientsListScreen(),
        ),
      );

      expect(find.text('My Patients'), findsOneWidget);
      expect(find.text('Alex Mercer'), findsOneWidget);
      expect(find.text('Chloe Bennett'), findsOneWidget);
      expect(find.text('Marcus Vance'), findsOneWidget);

      // Filter by needs attention
      await tester.tap(find.text('Needs Attention (1)'));
      await tester.pump();

      expect(find.text('Marcus Vance'), findsOneWidget);
      expect(find.text('Alex Mercer'), findsNothing);
    });

    testWidgets('DoctorPatientDetailScreen renders patient KPIs and sub-navigation', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorPatientDetailScreen(patientId: 'patient_001'),
        ),
      );

      expect(find.text('Alex Mercer'), findsOneWidget);
      expect(find.text('ADHERENCE'), findsOneWidget);
      expect(find.text('MOVEMENT SCORE'), findsOneWidget);
      expect(find.text('Prescribed Exercise Plan'), findsOneWidget);
      expect(find.text('Session History & Reviews'), findsOneWidget);
      expect(find.text('Condition Intake & Safety'), findsOneWidget);
      expect(find.text('Assign exercise'), findsOneWidget);
    });

    testWidgets('DoctorPatientPlanScreen lists prescriptions and assign action', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorPatientPlanScreen(patientId: 'patient_001'),
        ),
      );

      expect(find.text('Prescribed Plan'), findsOneWidget);
      expect(find.text('Mini Squat'), findsOneWidget);
      expect(find.text('Straight-Leg Raise'), findsOneWidget);
      expect(find.text('Wall Sit hold'), findsOneWidget);
      expect(find.text('Assign new exercise'), findsOneWidget);
    });

    testWidgets('DoctorPatientSessionsScreen lists sessions with scores', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorPatientSessionsScreen(patientId: 'patient_001'),
        ),
      );

      expect(find.text('Session History'), findsOneWidget);
      expect(find.text('Mini Squat'), findsNWidgets(2));
      expect(find.text('Movement score: 86'), findsOneWidget);
      expect(find.text('Review & add feedback'), findsOneWidget);
    });

    testWidgets('DoctorPatientConditionScreen renders intake form and end relationship dialog', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorPatientConditionScreen(patientId: 'patient_001'),
        ),
      );

      expect(find.text('Condition & Intake'), findsOneWidget);
      expect(find.text('PATIENT INTAKE FORM'), findsOneWidget);
      expect(find.text('Red Flags Screening Clear'), findsOneWidget);
      expect(find.text('End care relationship'), findsOneWidget);

      await tester.tap(find.text('End care relationship'));
      await tester.pumpAndSettle();

      expect(find.text('End Patient Care Relationship?'), findsOneWidget);
      expect(find.text('Keep patient in care'), findsOneWidget);
    });

    testWidgets('DoctorAssignWizard progresses through 3 steps to prescription', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: DoctorAssignWizard(patientId: 'patient_001'),
        ),
      );

      expect(find.text('Choose Exercise'), findsOneWidget);
      expect(find.text('Mini Squat'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Prescribe Dosage'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Schedule & Notes'), findsOneWidget);
      expect(find.text('Confirm & Prescribe'), findsOneWidget);
    });
  });
}

