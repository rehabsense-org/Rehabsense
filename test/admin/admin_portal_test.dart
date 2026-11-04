import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shariq_skeleton/core/widgets/widgets.dart';
import 'package:shariq_skeleton/features/admin/presentation/applications/admin_application_detail_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/applications/admin_applications_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/applications/admin_approve_dialog.dart';
import 'package:shariq_skeleton/features/admin/presentation/applications/admin_document_viewer_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/applications/admin_reject_sheet.dart';
import 'package:shariq_skeleton/features/admin/presentation/audit/admin_audit_log_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/auth/admin_blocked_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/auth/admin_forgot_password_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/auth/admin_reset_password_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/dashboard/admin_dashboard_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/doctors/admin_add_doctor_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/doctors/admin_doctor_detail_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/doctors/admin_doctors_list_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/doctors/admin_edit_doctor_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/doctors/admin_suspend_dialog.dart';
import 'package:shariq_skeleton/features/admin/presentation/exercises/admin_exercise_builder_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/exercises/admin_exercise_library_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/exercises/admin_test_camera_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/notifications/admin_notifications_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/patients/admin_patient_detail_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/patients/admin_patients_list_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/profile/admin_change_password_screen.dart';
import 'package:shariq_skeleton/features/admin/presentation/profile/admin_logout_dialog.dart';
import 'package:shariq_skeleton/features/admin/presentation/profile/admin_profile_screen.dart';

void main() {
  group('Phase 8 Admin Portal Tests', () {
    testWidgets('AdminForgotPasswordScreen and AdminResetPasswordScreen render inputs', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminForgotPasswordScreen(),
        ),
      );

      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.text('Send reset link'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminResetPasswordScreen(),
        ),
      );

      expect(find.text('Create new password'), findsOneWidget);
      expect(find.text('Update password'), findsOneWidget);
    });

    testWidgets('AdminBlockedScreen renders no access message and back buttons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminBlockedScreen(),
        ),
      );

      expect(find.text('No access'), findsOneWidget);
      expect(find.text('Back to welcome'), findsOneWidget);
      expect(find.text('Try another account'), findsOneWidget);
    });

    testWidgets('AdminDashboardScreen renders KPIs, privacy banner and pending apps', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminDashboardScreen(),
        ),
      );

      expect(find.text('Staff Console'), findsOneWidget);
      expect(find.text('PENDING APPS'), findsOneWidget);
      expect(find.text('ACTIVE DOCTORS'), findsOneWidget);
      expect(find.text('Privacy Boundary Enforced'), findsOneWidget);
      expect(find.text('PENDING APPLICATIONS'), findsOneWidget);
      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Manage doctors'), findsOneWidget);
      expect(find.text('Manage patients'), findsOneWidget);
    });

    testWidgets('AdminApplicationsScreen renders tabs and doctor application items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminApplicationsScreen(),
        ),
      );

      expect(find.text('Doctor Applications'), findsOneWidget);
      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Dr. Omar Sheikh'), findsOneWidget);
      expect(find.text('Pending'), findsWidgets);
    });

    testWidgets('AdminApplicationDetailScreen renders doctor metadata and documents', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminApplicationDetailScreen(applicationId: 'app_001'),
        ),
      );

      expect(find.text('Doctor Application'), findsOneWidget);
      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Medical License'), findsOneWidget);
      expect(find.text('Medical Practice License'), findsOneWidget);
      expect(find.text('Degree Certificate'), findsOneWidget);
      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Reject'), findsOneWidget);
    });

    testWidgets('AdminApproveDialog and AdminRejectSheet render actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdminApproveDialog(
              doctorName: 'Dr. Sara Khan',
              onApproved: () {},
            ),
          ),
        ),
      );

      expect(find.text('Approve Dr. Sara Khan?'), findsOneWidget);
      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdminRejectSheet(
              doctorName: 'Dr. Sara Khan',
              onConfirm: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Reject Application'), findsOneWidget);
      expect(find.text('Unreadable document'), findsOneWidget);
      expect(find.text('Reject application'), findsOneWidget);
    });

    testWidgets('AdminDocumentViewerScreen displays secure document card and timeout banner', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminDocumentViewerScreen(applicationId: 'app_001', docId: 'license'),
        ),
      );

      expect(find.text('Verification Document'), findsOneWidget);
      expect(find.textContaining('This secure signed URL expires in 60 seconds'), findsOneWidget);
      expect(find.text('OFFICIAL CREDENTIAL'), findsOneWidget);
      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Reopen secure link'), findsOneWidget);
    });

    testWidgets('AdminDoctorsListScreen and AdminDoctorDetailScreen render details and privacy', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminDoctorsListScreen(),
        ),
      );

      expect(find.text('Doctors Directory'), findsOneWidget);
      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Dr. Omar Sheikh'), findsOneWidget);
      expect(find.text('Add doctor'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminDoctorDetailScreen(doctorId: 'doc_001'),
        ),
      );

      expect(find.text('Doctor Profile'), findsOneWidget);
      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('PATIENTS'), findsOneWidget);
      expect(find.text('EXERCISES'), findsOneWidget);
      expect(find.textContaining('Privacy Boundary'), findsOneWidget);
      expect(find.text('Edit doctor'), findsOneWidget);
    });

    testWidgets('AdminEditDoctorScreen, AdminSuspendDialog and AdminAddDoctorScreen render forms', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminEditDoctorScreen(doctorId: 'doc_001'),
        ),
      );

      expect(find.text('Edit Doctor Profile'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Listed to patients'), findsOneWidget);
      expect(find.text('Save changes'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdminSuspendDialog(
              doctorName: 'Dr. Sara Khan',
              onConfirm: () {},
            ),
          ),
        ),
      );

      expect(find.text('Suspend Dr. Sara Khan?'), findsOneWidget);
      expect(find.text('Suspend doctor'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminAddDoctorScreen(),
        ),
      );

      expect(find.text('Add Doctor'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Work Email'), findsOneWidget);
      expect(find.text('Create doctor'), findsOneWidget);
    });

    testWidgets('AdminPatientsListScreen and AdminPatientDetailScreen maintain strict clinical boundary', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminPatientsListScreen(),
        ),
      );

      expect(find.text('Patients'), findsOneWidget);
      expect(find.text('Alex Morgan'), findsOneWidget);
      expect(find.text('Ali Raza'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminPatientDetailScreen(patientId: 'pat_001'),
        ),
      );

      expect(find.text('Patient Account'), findsOneWidget);
      expect(find.text('Alex Morgan'), findsOneWidget);
      expect(find.text('Account Created'), findsOneWidget);
      expect(find.textContaining('Account info only. Individual exercise sessions, movement scores, pain logs'), findsOneWidget);
      expect(find.text('Disable account'), findsOneWidget);
    });

    testWidgets('AdminExerciseLibraryScreen, Builder, and TestCameraScreen work properly', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminExerciseLibraryScreen(),
        ),
      );

      expect(find.text('Exercise Management'), findsOneWidget);
      expect(find.text('Mini Squat'), findsOneWidget);
      expect(find.text('Warrior II hold'), findsOneWidget);
      expect(find.text('New'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminExerciseBuilderScreen(),
        ),
      );

      expect(find.text('Exercise Builder (Admin)'), findsOneWidget);
      expect(find.text('Exercise Name'), findsOneWidget);
      expect(find.text('Visibility'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminTestCameraScreen(exerciseId: 'tree_pose_hold'),
        ),
      );

      expect(find.text('Staff Camera Simulator'), findsOneWidget);
      expect(find.text('TEST MODE · nothing is saved'), findsOneWidget);
      expect(find.text('Mark as tested'), findsOneWidget);
    });

    testWidgets('AdminNotificationsScreen and AdminAuditLogScreen render records', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminNotificationsScreen(),
        ),
      );

      expect(find.text('Staff Notifications'), findsOneWidget);
      expect(find.text('New doctor application'), findsOneWidget);
      expect(find.text('Application resubmission'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminAuditLogScreen(),
        ),
      );

      expect(find.text('Audit Log'), findsOneWidget);
      expect(find.text('Approved doctor application'), findsOneWidget);
      expect(find.text('Published public exercise'), findsOneWidget);
      expect(find.text('Suspended doctor account'), findsOneWidget);
    });

    testWidgets('AdminProfileScreen, ChangePassword and LogoutDialog function', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminProfileScreen(),
        ),
      );

      expect(find.text('Staff Profile'), findsOneWidget);
      expect(find.text('Operations Administrator'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Audit log'), findsOneWidget);
      expect(find.text('Change password'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: AdminChangePasswordScreen(),
        ),
      );

      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Current Password'), findsOneWidget);
      expect(find.text('Update password'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdminLogoutDialog(),
          ),
        ),
      );

      expect(find.text('Log out?'), findsOneWidget);
      expect(find.widgetWithText(RSButton, 'Log out'), findsOneWidget);
    });
  });
}

