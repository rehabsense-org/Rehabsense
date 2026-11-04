import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shariq_skeleton/core/widgets/widgets.dart';

void main() {
  group('Phase 0 Core Widgets', () {
    testWidgets('RSDoctorCard renders doctor details and responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RSDoctorCard(
              name: 'Dr. Sara Khan',
              subtitle: 'Physiotherapist · 8 yrs',
              tags: const ['Knee', 'Post-surgery'],
              matchText: '96% match',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Dr. Sara Khan'), findsOneWidget);
      expect(find.text('Physiotherapist · 8 yrs'), findsOneWidget);
      expect(find.text('Knee'), findsOneWidget);
      expect(find.text('Post-surgery'), findsOneWidget);
      expect(find.text('96% match'), findsOneWidget);
      expect(find.text('SK'), findsOneWidget);

      await tester.tap(find.text('Dr. Sara Khan'));
      expect(tapped, isTrue);
    });

    testWidgets('RSDocumentTile renders upload and uploaded states', (tester) async {
      bool tapped = false;
      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                RSDocumentTile(
                  title: 'Medical licence',
                  subtitle: 'licence.pdf · 1.2 MB',
                  isUploaded: true,
                  onTap: () => tapped = true,
                  onDelete: () => deleted = true,
                ),
                const RSDocumentTile(
                  title: 'National ID',
                  isUploaded: false,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Medical licence'), findsOneWidget);
      expect(find.text('licence.pdf · 1.2 MB'), findsOneWidget);
      expect(find.text('National ID'), findsOneWidget);
      expect(find.text('Tap to upload'), findsOneWidget);

      await tester.tap(find.text('Medical licence'));
      expect(tapped, isTrue);

      await tester.tap(find.byType(IconButton));
      expect(deleted, isTrue);
    });

    testWidgets('RSStepHeader renders step progress and labels', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RSStepHeader(
              currentStep: 2,
              totalSteps: 4,
              title: 'Tracking config',
              subtitle: 'Configure camera and angles',
            ),
          ),
        ),
      );

      expect(find.text('STEP 2 OF 4'), findsOneWidget);
      expect(find.text('Tracking config'), findsOneWidget);
      expect(find.text('Configure camera and angles'), findsOneWidget);
    });

    testWidgets('RSTimeline renders timeline nodes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RSTimeline(
              items: [
                RSTimelineItem(
                  title: 'Submitted',
                  subtitle: 'Today 10:00 AM',
                  state: RSTimelineState.completed,
                ),
                RSTimelineItem(
                  title: 'Under review',
                  subtitle: 'Takes 1-3 days',
                  state: RSTimelineState.active,
                ),
                RSTimelineItem(
                  title: 'Decision',
                  subtitle: 'By email',
                  state: RSTimelineState.pending,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Submitted'), findsOneWidget);
      expect(find.text('Under review'), findsOneWidget);
      expect(find.text('Decision'), findsOneWidget);
    });

    testWidgets('RSSlider displays discrete values and triggers onChanged', (tester) async {
      double currentVal = 4.0;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: RSSlider(
                  value: currentVal,
                  title: 'Current pain',
                  onChanged: (val) {
                    setState(() => currentVal = val);
                  },
                ),
              ),
            );
          },
        ),
      );

      expect(find.text('Current pain'), findsOneWidget);
      expect(find.text('4 / 10'), findsOneWidget);
      expect(find.text('0 - No pain'), findsOneWidget);
      expect(find.text('10 - Severe'), findsOneWidget);

      await tester.tap(find.byType(Slider));
      await tester.pumpAndSettle();
    });

    testWidgets('RSOtpField accepts digit input and fires callbacks', (tester) async {
      String latestCode = '';
      String completedCode = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RSOtpField(
              length: 6,
              onChanged: (code) => latestCode = code,
              onCompleted: (code) => completedCode = code,
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(6));

      await tester.enterText(find.byType(TextField).at(0), '1');
      await tester.enterText(find.byType(TextField).at(1), '2');
      await tester.enterText(find.byType(TextField).at(2), '3');
      await tester.enterText(find.byType(TextField).at(3), '4');
      await tester.enterText(find.byType(TextField).at(4), '5');
      await tester.enterText(find.byType(TextField).at(5), '6');

      expect(latestCode, equals('123456'));
      expect(completedCode, equals('123456'));
    });

    testWidgets('RSChoiceChip toggles selection and displays icon', (tester) async {
      bool selected = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: RSChoiceChip(
                  label: 'Knee',
                  selected: selected,
                  onSelected: (val) {
                    setState(() => selected = val);
                  },
                ),
              ),
            );
          },
        ),
      );

      expect(find.text('Knee'), findsOneWidget);
      await tester.tap(find.text('Knee'));
      expect(selected, isTrue);
    });
  });
}

