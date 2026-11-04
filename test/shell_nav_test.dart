import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shariq_skeleton/app/auth_notifier.dart';
import 'package:shariq_skeleton/app/router.dart';

void main() {
  testWidgets('Bottom nav switching, full text visibility, and repeated taps', (tester) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      throw details.exception;
    };

    AuthNotifier.instance.setMockState(role: UserRole.patient, status: AccountStatus.active);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter,
      ),
    );
    await tester.pumpAndSettle();

    appRouter.go('/home');
    await tester.pumpAndSettle();

    // 1. Initial tab: Home is active, full text 'Home' is visible
    expect(find.text('Home'), findsWidgets);

    // Repeated tap on already active Home tab must NOT crash with duplicate key
    await tester.tap(find.text('Home').first);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsWidgets);

    // 2. Tap Courses tab
    await tester.tap(find.byIcon(LucideIcons.bookOpen));
    await tester.pump();
    await tester.pumpAndSettle();
    // Full text 'Courses' must be displayed
    expect(find.text('Courses'), findsWidgets);

    // Repeated tap on Courses tab must NOT crash
    await tester.tap(find.text('Courses').first);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Courses'), findsWidgets);

    // 3. Tap Progress tab
    await tester.tap(find.byIcon(LucideIcons.barChart3));
    await tester.pump();
    await tester.pumpAndSettle();
    // Full text 'Progress' must be displayed
    expect(find.text('Progress'), findsWidgets);

    // Repeated tap on Progress tab
    await tester.tap(find.text('Progress').first);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Progress'), findsWidgets);

    // 4. Tap Profile tab
    await tester.tap(find.byIcon(LucideIcons.user));
    await tester.pump();
    await tester.pumpAndSettle();
    // Full text 'Profile' must be displayed
    expect(find.text('Profile'), findsWidgets);

    // Repeated tap on Profile tab
    await tester.tap(find.text('Profile').first);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsWidgets);

    // 5. Navigate back to Home
    await tester.tap(find.byIcon(LucideIcons.home));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsWidgets);
  });
}
