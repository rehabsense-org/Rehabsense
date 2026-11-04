// ---------------------------------------------------------------------------
// ROUTER — RehabSense
// Single source of truth for routing across Patient, Doctor, and Admin portals.
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_notifier.dart';
import 'shell_scaffold.dart';

// Auth & Onboarding
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/inactive_account_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/reset_password_screen.dart';
import '../features/auth/splash_screen.dart';
import '../features/auth/verify_email_screen.dart';
import '../features/auth/welcome_screen.dart';
import '../features/onboarding/app_onboarding_screen.dart';
import '../features/onboarding/camera_help_screen.dart';
import '../features/onboarding/profile_setup_screen.dart';
import '../features/onboarding/safety_consent_screen.dart';

// Doctor Portal
import '../features/doctor/presentation/auth/doctor_application_rejected_screen.dart';
import '../features/doctor/presentation/auth/doctor_application_submitted_screen.dart';
import '../features/doctor/presentation/auth/doctor_documents_screen.dart';
import '../features/doctor/presentation/auth/doctor_forgot_password_screen.dart';
import '../features/doctor/presentation/auth/doctor_inactive_screen.dart';
import '../features/doctor/presentation/auth/doctor_login_screen.dart';
import '../features/doctor/presentation/auth/doctor_otp_screen.dart';
import '../features/doctor/presentation/auth/doctor_register_screen.dart';
import '../features/doctor/presentation/auth/doctor_reset_password_screen.dart';
import '../features/doctor/presentation/auth/doctor_resume_application_screen.dart';
import '../features/doctor/presentation/auth/doctor_submit_review_screen.dart';
import '../features/doctor/presentation/assignments/doctor_assign_wizard.dart';
import '../features/doctor/presentation/dashboard/doctor_home_screen.dart';
import '../features/doctor/presentation/onboarding/doctor_go_live_screen.dart';
import '../features/doctor/presentation/onboarding/doctor_profile_wizard.dart';
import '../features/doctor/presentation/patients/doctor_patient_condition_screen.dart';
import '../features/doctor/presentation/patients/doctor_patient_detail_screen.dart';
import '../features/doctor/presentation/patients/doctor_patient_plan_screen.dart';
import '../features/doctor/presentation/patients/doctor_patient_sessions_screen.dart';
import '../features/doctor/presentation/patients/doctor_patients_list_screen.dart';
import '../features/doctor/presentation/requests/doctor_request_detail_screen.dart';
import '../features/doctor/presentation/requests/doctor_requests_screen.dart';
import '../features/doctor/presentation/exercises/doctor_exercise_library_screen.dart';
import '../features/doctor/presentation/exercises/doctor_exercise_builder_wizard.dart';
import '../features/doctor/presentation/exercises/doctor_test_camera_screen.dart';
import '../features/doctor/presentation/feedback/doctor_session_review_screen.dart';
import '../features/doctor/presentation/notifications/doctor_notifications_screen.dart';
import '../features/doctor/presentation/profile/doctor_profile_screen.dart';
import '../features/doctor/presentation/profile/doctor_edit_profile_screen.dart';
import '../features/doctor/presentation/profile/doctor_update_credentials_screen.dart';
import '../features/doctor/presentation/settings/doctor_settings_screen.dart';

// Admin Portal
import '../features/admin/presentation/auth/admin_login_screen.dart';
import '../features/admin/presentation/auth/admin_forgot_password_screen.dart';
import '../features/admin/presentation/auth/admin_reset_password_screen.dart';
import '../features/admin/presentation/auth/admin_blocked_screen.dart';
import '../features/admin/presentation/dashboard/admin_dashboard_screen.dart';
import '../features/admin/presentation/applications/admin_applications_screen.dart';
import '../features/admin/presentation/applications/admin_application_detail_screen.dart';
import '../features/admin/presentation/applications/admin_document_viewer_screen.dart';
import '../features/admin/presentation/doctors/admin_doctors_list_screen.dart';
import '../features/admin/presentation/doctors/admin_doctor_detail_screen.dart';
import '../features/admin/presentation/doctors/admin_edit_doctor_screen.dart';
import '../features/admin/presentation/doctors/admin_add_doctor_screen.dart';
import '../features/admin/presentation/patients/admin_patients_list_screen.dart';
import '../features/admin/presentation/patients/admin_patient_detail_screen.dart';
import '../features/admin/presentation/exercises/admin_exercise_library_screen.dart';
import '../features/admin/presentation/exercises/admin_exercise_builder_screen.dart';
import '../features/admin/presentation/exercises/admin_test_camera_screen.dart';
import '../features/admin/presentation/audit/admin_audit_log_screen.dart';
import '../features/admin/presentation/notifications/admin_notifications_screen.dart';
import '../features/admin/presentation/profile/admin_profile_screen.dart';
import '../features/admin/presentation/profile/admin_change_password_screen.dart';

// Connect with Doctor
import '../features/connect/presentation/condition_form_wizard.dart';
import '../features/connect/presentation/connect_hub_screen.dart';
import '../features/connect/presentation/connected_celebration_screen.dart';
import '../features/connect/presentation/doctor_profile_public_screen.dart';
import '../features/connect/presentation/find_doctors_screen.dart';
import '../features/connect/presentation/my_condition_screen.dart';
import '../features/connect/presentation/my_doctor_screen.dart';
import '../features/connect/presentation/request_declined_screen.dart';
import '../features/connect/presentation/request_status_screen.dart';
import '../features/connect/presentation/send_request_screen.dart';

// Home
import '../features/home/home_screen.dart';
import '../features/home/notification_inbox_screen.dart';

// Courses
import '../features/courses/course_detail_screen.dart';
import '../features/courses/courses_screen.dart';
import '../features/courses/exercise_detail_screen.dart';
import '../features/courses/presentation/prescribed_courses_screen.dart';
import '../features/courses/presentation/prescribed_exercise_detail_screen.dart';

// Progress
import '../features/progress/exercise_progress_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/progress/session_details_screen.dart';
import '../features/progress/session_history_screen.dart';

// Profile
import '../features/profile/about_screen.dart';
import '../features/profile/change_password_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/profile/help_faq_screen.dart';
import '../features/profile/notification_prefs_screen.dart';
import '../features/profile/privacy_data_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/settings_screen.dart';

// Session
import '../features/session/camera_error_screen.dart';
import '../features/session/camera_setup_screen.dart';
import '../features/session/checklist_screen.dart';
import '../features/session/live_tracking_screen.dart';
import '../features/session/pause_screen.dart';
import '../features/session/saved_screen.dart';
import '../features/session/session_summary_screen.dart';
import '../features/session/sync_error_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _homeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'homeNav');
final GlobalKey<NavigatorState> _coursesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'coursesNav');
final GlobalKey<NavigatorState> _progressNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'progressNav');
final GlobalKey<NavigatorState> _profileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'profileNav');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  refreshListenable: AuthNotifier.instance,
  routes: [
    // ── Auth & Onboarding (Root navigator, no shell) ─────────────────────
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const AppOnboardingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final email = state.extra as String?;
        return VerifyEmailScreen(email: email);
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/setup/profile',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/setup/safety',
      builder: (context, state) => const SafetyConsentScreen(),
    ),
    GoRoute(
      path: '/setup/camera-help',
      builder: (context, state) => const CameraHelpScreen(),
    ),
    GoRoute(
      path: '/account-inactive',
      builder: (context, state) => const InactiveAccountScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/prescribed/:assignmentId',
      builder: (context, state) {
        final aid = state.pathParameters['assignmentId'] ?? 'assign_001';
        return PrescribedExerciseDetailScreen(assignmentId: aid);
      },
    ),

    // ── Connect with Doctor & Care (Root Navigator, no shell) ────────────
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/connect',
      builder: (context, state) => const ConnectHubScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/connect/condition',
      builder: (context, state) => const ConditionFormWizard(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/connect/doctors',
      builder: (context, state) => const FindDoctorsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/connect/doctors/:did',
      builder: (context, state) {
        final did = state.pathParameters['did'] ?? 'doc_001';
        return DoctorProfilePublicScreen(doctorId: did);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/connect/doctors/:did/request',
      builder: (context, state) {
        final did = state.pathParameters['did'] ?? 'doc_001';
        return SendRequestScreen(doctorId: did);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/connect/status',
      builder: (context, state) => const RequestStatusScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/connect/success',
      builder: (context, state) => const ConnectedCelebrationScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/connect/declined',
      builder: (context, state) => const RequestDeclinedScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/my-doctor',
      builder: (context, state) => const MyDoctorScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/my-condition',
      builder: (context, state) => const MyConditionScreen(),
    ),

    // ── Doctor Portal Entry Routes ───────────────────────────────────────
    GoRoute(
      path: '/doctor/login',
      builder: (context, state) => const DoctorLoginScreen(),
    ),
    GoRoute(
      path: '/doctor/register',
      builder: (context, state) => const DoctorRegisterScreen(),
    ),
    GoRoute(
      path: '/doctor/verify-email',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final email = extra?['email'] as String? ?? 'doctor@clinic.com';
        return DoctorOtpScreen(email: email);
      },
    ),
    GoRoute(
      path: '/doctor/onboarding/documents',
      builder: (context, state) => const DoctorDocumentsScreen(),
    ),
    GoRoute(
      path: '/doctor/documents',
      builder: (context, state) => const DoctorDocumentsScreen(),
    ),
    GoRoute(
      path: '/doctor/onboarding/review',
      builder: (context, state) => const DoctorSubmitReviewScreen(),
    ),
    GoRoute(
      path: '/doctor/submit',
      builder: (context, state) => const DoctorSubmitReviewScreen(),
    ),
    GoRoute(
      path: '/doctor/application-status',
      builder: (context, state) => const DoctorApplicationSubmittedScreen(),
    ),
    GoRoute(
      path: '/doctor/submitted',
      builder: (context, state) => const DoctorApplicationSubmittedScreen(),
    ),
    GoRoute(
      path: '/doctor/application/resume',
      builder: (context, state) => const DoctorResumeApplicationScreen(),
    ),
    GoRoute(
      path: '/doctor/resume',
      builder: (context, state) => const DoctorResumeApplicationScreen(),
    ),
    GoRoute(
      path: '/doctor/application/rejected',
      builder: (context, state) => const DoctorApplicationRejectedScreen(),
    ),
    GoRoute(
      path: '/doctor/rejected',
      builder: (context, state) => const DoctorApplicationRejectedScreen(),
    ),
    GoRoute(
      path: '/doctor/blocked',
      builder: (context, state) => const DoctorInactiveScreen(),
    ),
    GoRoute(
      path: '/doctor/inactive',
      builder: (context, state) => const DoctorInactiveScreen(),
    ),
    GoRoute(
      path: '/doctor/forgot-password',
      builder: (context, state) => const DoctorForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/doctor/reset-password',
      builder: (context, state) => const DoctorResetPasswordScreen(),
    ),
    GoRoute(
      path: '/doctor/onboarding/profile',
      builder: (context, state) => const DoctorProfileWizard(),
    ),
    GoRoute(
      path: '/doctor/setup',
      builder: (context, state) => const DoctorProfileWizard(),
    ),
    GoRoute(
      path: '/doctor/onboarding/preview',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return DoctorGoLiveScreen(profileData: data);
      },
    ),
    GoRoute(
      path: '/doctor/setup/preview',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return DoctorGoLiveScreen(profileData: data);
      },
    ),
    GoRoute(
      path: '/doctor/home',
      builder: (context, state) => const DoctorHomeScreen(),
    ),
    GoRoute(
      path: '/doctor/requests',
      builder: (context, state) => const DoctorRequestsScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? 'req_001';
            return DoctorRequestDetailScreen(requestId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/doctor/patients',
      builder: (context, state) => const DoctorPatientsListScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? 'patient_001';
            return DoctorPatientDetailScreen(patientId: id);
          },
          routes: [
            GoRoute(
              path: 'plan',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? 'patient_001';
                return DoctorPatientPlanScreen(patientId: id);
              },
            ),
            GoRoute(
              path: 'sessions',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? 'patient_001';
                return DoctorPatientSessionsScreen(patientId: id);
              },
            ),
            GoRoute(
              path: 'condition',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? 'patient_001';
                return DoctorPatientConditionScreen(patientId: id);
              },
            ),
            GoRoute(
              path: 'assign',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? 'patient_001';
                return DoctorAssignWizard(patientId: id);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/doctor/exercises',
      builder: (context, state) => const DoctorExerciseLibraryScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const DoctorExerciseBuilderWizard(),
          routes: [
            GoRoute(
              path: 'test',
              builder: (context, state) => const DoctorTestCameraScreen(exerciseId: 'new'),
            ),
          ],
        ),
        GoRoute(
          path: ':id/test',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? 'knee_mini_squat';
            return DoctorTestCameraScreen(exerciseId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/doctor/sessions/:sessionId/review',
      builder: (context, state) {
        final sessionId = state.pathParameters['sessionId'] ?? 'sess_001';
        return DoctorSessionReviewScreen(sessionId: sessionId);
      },
    ),
    GoRoute(
      path: '/doctor/patients/:pid/sessions/:sid',
      builder: (context, state) {
        final sid = state.pathParameters['sid'] ?? 'sess_001';
        final pid = state.pathParameters['pid'];
        return DoctorSessionReviewScreen(sessionId: sid, patientId: pid);
      },
    ),
    GoRoute(
      path: '/doctor/notifications',
      builder: (context, state) => const DoctorNotificationsScreen(),
    ),
    GoRoute(
      path: '/doctor/profile',
      builder: (context, state) => const DoctorProfileScreen(),
      routes: [
        GoRoute(
          path: 'edit',
          builder: (context, state) => const DoctorEditProfileScreen(),
        ),
        GoRoute(
          path: 'credentials',
          builder: (context, state) => const DoctorUpdateCredentialsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/doctor/settings',
      builder: (context, state) => const DoctorSettingsScreen(),
    ),

    // ── Admin Portal Entry Routes ────────────────────────────────────────
    GoRoute(
      path: '/admin/login',
      builder: (context, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: '/admin/forgot-password',
      builder: (context, state) => const AdminForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/admin/reset-password',
      builder: (context, state) => const AdminResetPasswordScreen(),
    ),
    GoRoute(
      path: '/admin/blocked',
      builder: (context, state) => const AdminBlockedScreen(),
    ),
    GoRoute(
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/applications',
      builder: (context, state) => const AdminApplicationsScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? 'app_001';
            return AdminApplicationDetailScreen(applicationId: id);
          },
          routes: [
            GoRoute(
              path: 'doc/:docId',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? 'app_001';
                final docId = state.pathParameters['docId'] ?? 'license';
                return AdminDocumentViewerScreen(applicationId: id, docId: docId);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/admin/doctors',
      builder: (context, state) => const AdminDoctorsListScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const AdminAddDoctorScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? 'doc_001';
            return AdminDoctorDetailScreen(doctorId: id);
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? 'doc_001';
                return AdminEditDoctorScreen(doctorId: id);
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/admin/patients',
      builder: (context, state) => const AdminPatientsListScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? 'pat_001';
            return AdminPatientDetailScreen(patientId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/admin/exercises',
      builder: (context, state) => const AdminExerciseLibraryScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const AdminExerciseBuilderScreen(),
          routes: [
            GoRoute(
              path: 'test',
              builder: (context, state) => const AdminTestCameraScreen(exerciseId: 'new'),
            ),
          ],
        ),
        GoRoute(
          path: ':id/test',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? 'knee_mini_squat';
            return AdminTestCameraScreen(exerciseId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/admin/notifications',
      builder: (context, state) => const AdminNotificationsScreen(),
    ),
    GoRoute(
      path: '/admin/audit',
      builder: (context, state) => const AdminAuditLogScreen(),
    ),
    GoRoute(
      path: '/admin/profile',
      builder: (context, state) => const AdminProfileScreen(),
    ),
    GoRoute(
      path: '/admin/change-password',
      builder: (context, state) => const AdminChangePasswordScreen(),
    ),

    // ── Shell Routes (Patient 4 Branches) ─────────────────────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: HOME
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) => const NotificationInboxScreen(),
                ),
              ],
            ),
          ],
        ),

        // Branch 1: COURSES
        StatefulShellBranch(
          navigatorKey: _coursesNavigatorKey,
          routes: [
            GoRoute(
              path: '/courses',
              builder: (context, state) => const CoursesScreen(),
              routes: [
                // RULE 11: Declare /courses/prescribed BEFORE /courses/:cid
                GoRoute(
                  path: 'prescribed',
                  builder: (context, state) => const PrescribedCoursesScreen(),
                  routes: [
                    GoRoute(
                      path: ':assignmentId',
                      builder: (context, state) {
                        final aid = state.pathParameters['assignmentId'] ?? 'assign_001';
                        return PrescribedExerciseDetailScreen(assignmentId: aid);
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: ':cid',
                  builder: (context, state) {
                    final cid = state.pathParameters['cid'] ?? 'knee_rehab';
                    return CourseDetailScreen(courseId: cid);
                  },
                  routes: [
                    GoRoute(
                      path: 'exercise/:eid',
                      builder: (context, state) {
                        final cid = state.pathParameters['cid'] ?? 'knee_rehab';
                        final eid = state.pathParameters['eid'] ?? 'knee_mini_squat';
                        return ExerciseDetailScreen(courseId: cid, exerciseId: eid);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Branch 2: PROGRESS
        StatefulShellBranch(
          navigatorKey: _progressNavigatorKey,
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressScreen(),
              routes: [
                GoRoute(
                  path: 'exercise/:eid',
                  builder: (context, state) {
                    final eid = state.pathParameters['eid'] ?? 'knee_mini_squat';
                    return ExerciseProgressScreen(exerciseId: eid);
                  },
                ),
                GoRoute(
                  path: 'history',
                  builder: (context, state) => const SessionHistoryScreen(),
                ),
                GoRoute(
                  path: 'session/:sid',
                  builder: (context, state) {
                    final sid = state.pathParameters['sid'] ?? 'sess_001';
                    return SessionDetailsScreen(sessionId: sid);
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 3: PROFILE
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                  routes: [
                    GoRoute(
                      path: 'password',
                      builder: (context, state) => const ChangePasswordScreen(),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) => const NotificationPrefsScreen(),
                ),
                GoRoute(
                  path: 'help',
                  builder: (context, state) => const HelpFaqScreen(),
                ),
                GoRoute(
                  path: 'privacy',
                  builder: (context, state) => const PrivacyDataScreen(),
                ),
                GoRoute(
                  path: 'about',
                  builder: (context, state) => const AboutScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // ── Session Flow (Full-screen, covers shell) ─────────────────────────
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/session/:eid/checklist',
      builder: (context, state) {
        final eid = state.pathParameters['eid'] ?? 'knee_mini_squat';
        return ChecklistScreen(exerciseId: eid);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/session/:eid/camera',
      builder: (context, state) {
        final eid = state.pathParameters['eid'] ?? 'knee_mini_squat';
        return CameraSetupScreen(exerciseId: eid);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/session/:eid/live',
      builder: (context, state) {
        final eid = state.pathParameters['eid'] ?? 'knee_mini_squat';
        return LiveTrackingScreen(exerciseId: eid);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/session/:eid/paused',
      builder: (context, state) {
        final eid = state.pathParameters['eid'] ?? 'knee_mini_squat';
        return PauseScreen(exerciseId: eid);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/session/:eid/summary',
      builder: (context, state) {
        final eid = state.pathParameters['eid'] ?? 'knee_mini_squat';
        return SessionSummaryScreen(exerciseId: eid);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/session/:eid/saved',
      builder: (context, state) {
        final eid = state.pathParameters['eid'] ?? 'knee_mini_squat';
        return SavedScreen(exerciseId: eid);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/session/:eid/tracking-error',
      builder: (context, state) {
        final eid = state.pathParameters['eid'] ?? 'knee_mini_squat';
        return CameraErrorScreen(exerciseId: eid);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/session/:eid/sync-error',
      builder: (context, state) {
        final eid = state.pathParameters['eid'] ?? 'knee_mini_squat';
        return SyncErrorScreen(exerciseId: eid);
      },
    ),
  ],
);
