// ---------------------------------------------------------------------------
// ROUTER — RehabSense
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'shell_scaffold.dart';

// Auth & Onboarding
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/reset_password_screen.dart';
import '../features/auth/splash_screen.dart';
import '../features/auth/verify_email_screen.dart';
import '../features/auth/welcome_screen.dart';
import '../features/onboarding/camera_help_screen.dart';
import '../features/onboarding/profile_setup_screen.dart';
import '../features/onboarding/safety_consent_screen.dart';

// Home
import '../features/home/home_screen.dart';
import '../features/home/notification_inbox_screen.dart';

// Courses
import '../features/courses/course_detail_screen.dart';
import '../features/courses/courses_screen.dart';
import '../features/courses/exercise_detail_screen.dart';

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
  routes: [
    // ── Auth & Onboarding (Root navigator, no shell) ─────────────────────
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
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

    // ── Shell Routes (4 Branches) ────────────────────────────────────────
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
