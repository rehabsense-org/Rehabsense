import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shariq_skeleton/core/widgets/rs_app_drawer.dart';
import 'package:shariq_skeleton/core/widgets/rs_logo.dart';
import 'package:shariq_skeleton/features/home/home_screen.dart';

void main() {
  testWidgets('RSLogo renders both mark and lockup variants cleanly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              RSLogo(variant: RSLogoVariant.mark, size: 48),
              RSLogo(variant: RSLogoVariant.lockup, size: 54, onDark: false),
              RSLogo(variant: RSLogoVariant.lockup, size: 54, onDark: true),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(RSLogo), findsNWidgets(3));
    expect(find.textContaining('Rehab'), findsNWidgets(2));
    expect(find.textContaining('Sense'), findsNWidgets(2));
  });

  testWidgets('RSAppDrawer renders themed navigation items and header', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          drawer: RSAppDrawer(),
        ),
      ),
    );

    // Open drawer
    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.byType(RSAppDrawer), findsOneWidget);
    expect(find.text('CORE NAVIGATION'), findsOneWidget);
    expect(find.text('Home Dashboard'), findsOneWidget);
    expect(find.text('Exercise Courses'), findsOneWidget);
    expect(find.text('Recovery & Progress'), findsOneWidget);
    expect(find.text('Connect with Doctor'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });

  testWidgets('Tapping menu button on HomeScreen opens RSAppDrawer cleanly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Drawer is closed initially
    expect(find.byType(RSAppDrawer), findsNothing);

    // Tap menu button
    final menuButton = find.byIcon(LucideIcons.menu);
    expect(menuButton, findsOneWidget);
    await tester.tap(menuButton);
    await tester.pumpAndSettle();

    // Drawer is now open!
    expect(find.byType(RSAppDrawer), findsOneWidget);
    expect(find.text('CORE NAVIGATION'), findsOneWidget);
    expect(find.text('Home Dashboard'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);

    // Close with X button
    final closeBtn = find.byIcon(LucideIcons.x);
    expect(closeBtn, findsOneWidget);
    await tester.tap(closeBtn);
    await tester.pumpAndSettle();

    // Drawer is closed again
    expect(find.byType(RSAppDrawer), findsNothing);
  });
}
