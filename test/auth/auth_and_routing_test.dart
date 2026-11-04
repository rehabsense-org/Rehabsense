import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shariq_skeleton/app/auth_notifier.dart';
import 'package:shariq_skeleton/app/router.dart';
import 'package:shariq_skeleton/features/auth/inactive_account_screen.dart';
import 'package:shariq_skeleton/features/auth/welcome_screen.dart';
import 'package:shariq_skeleton/features/onboarding/app_onboarding_screen.dart';

void main() {
  group('Phase 2 Auth and Routing Tests', () {
    test('AuthNotifier handles roles and account statuses correctly', () {
      final auth = AuthNotifier.instance;

      // Default mock state
      auth.setMockState(role: UserRole.patient, status: AccountStatus.active);
      expect(auth.role, equals(UserRole.patient));
      expect(auth.accountStatus, equals(AccountStatus.active));
      expect(auth.isAccountDisabled, isFalse);

      // Doctor role
      auth.setMockState(role: UserRole.doctor, status: AccountStatus.pendingVerification);
      expect(auth.role, equals(UserRole.doctor));
      expect(auth.accountStatus, equals(AccountStatus.pendingVerification));

      // Admin role
      auth.setMockState(role: UserRole.admin, status: AccountStatus.active);
      expect(auth.role, equals(UserRole.admin));

      // Disabled account
      auth.setMockState(role: UserRole.patient, status: AccountStatus.disabled);
      expect(auth.isAccountDisabled, isTrue);
    });

    test('UserRole and AccountStatus parse string representations safely', () {
      expect(UserRole.fromString('doctor'), equals(UserRole.doctor));
      expect(UserRole.fromString('ADMIN'), equals(UserRole.admin));
      expect(UserRole.fromString('patient'), equals(UserRole.patient));
      expect(UserRole.fromString(null), equals(UserRole.patient));
      expect(UserRole.fromString('unknown'), equals(UserRole.patient));

      expect(AccountStatus.fromString('disabled'), equals(AccountStatus.disabled));
      expect(AccountStatus.fromString('pending_verification'), equals(AccountStatus.pendingVerification));
      expect(AccountStatus.fromString('active'), equals(AccountStatus.active));
      expect(AccountStatus.fromString(null), equals(AccountStatus.active));
    });

    testWidgets('WelcomeScreen renders all elements with no overflow on small screen', (tester) async {
      // Simulate a compact phone: 360 × 640 logical pixels
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomeScreen(),
        ),
      );
      await tester.pump(); // settle layout

      expect(find.text('Rehab, guided\nby your camera'), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
      expect(find.text('I already have an account'), findsOneWidget);
      expect(find.text('I am a Doctor'), findsOneWidget);
      expect(find.text('Staff login'), findsOneWidget);
      // No layout exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets('WelcomeScreen renders all elements with no overflow on large screen', (tester) async {
      // Simulate a large phone: 412 × 892 logical pixels
      tester.view.physicalSize = const Size(412, 892);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomeScreen(),
        ),
      );
      await tester.pump();

      expect(find.text('Rehab, guided\nby your camera'), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
      expect(find.text('I already have an account'), findsOneWidget);
      expect(find.text('I am a Doctor'), findsOneWidget);
      expect(find.text('Staff login'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('InactiveAccountScreen displays suspended message and buttons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InactiveAccountScreen(),
        ),
      );

      expect(find.text('Account inactive'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
      expect(find.text('Contact support'), findsOneWidget);
    });

    testWidgets('AppOnboardingScreen renders slides and advances with continue', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppOnboardingScreen(),
        ),
      );
      await tester.pump();

      expect(find.text('AI MOTION TRACKING'), findsOneWidget);
      expect(find.text('Rehab guided by\nyour camera'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);

      // Advance
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('STRICT PRIVACY'), findsOneWidget);
    });

    test('GoRouter contains expected entry points for all 3 portals and prescribed courses', () {
      final routes = appRouter.configuration.routes;
      final paths = <String>[];

      for (final r in routes) {
        if (r is GoRoute) {
          paths.add(r.path);
        }
      }

      expect(paths, contains('/splash'));
      expect(paths, contains('/onboarding'));
      expect(paths, contains('/welcome'));
      expect(paths, contains('/doctor/login'));
      expect(paths, contains('/admin/login'));
      expect(paths, contains('/account-inactive'));
    });
  });
}
