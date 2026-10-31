import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../domain/models/models.dart';

class SessionDetailsScreen extends StatefulWidget {
  final String sessionId;

  const SessionDetailsScreen({super.key, required this.sessionId});

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  int _selectedRepIndex = 0;

  final List<Map<String, dynamic>> _reps = const [
    {'rep': 1, 'outcome': RepOutcome.correct, 'feedback': 'Good form, reached 92°'},
    {'rep': 2, 'outcome': RepOutcome.correct, 'feedback': 'Good depth, chest upright'},
    {'rep': 3, 'outcome': RepOutcome.incorrect, 'feedback': 'Knee valgus: knees leaned inward'},
    {'rep': 4, 'outcome': RepOutcome.correct, 'feedback': 'Solid hold and controlled rise'},
    {'rep': 5, 'outcome': RepOutcome.correct, 'feedback': 'Smooth tempo'},
    {'rep': 6, 'outcome': RepOutcome.incorrect, 'feedback': 'Incomplete depth: reached 78°'},
    {'rep': 7, 'outcome': RepOutcome.correct, 'feedback': 'Perfect knee alignment'},
    {'rep': 8, 'outcome': RepOutcome.correct, 'feedback': 'Great posture'},
    {'rep': 9, 'outcome': RepOutcome.correct, 'feedback': 'Well-paced descent'},
    {'rep': 10, 'outcome': RepOutcome.incomplete, 'feedback': 'Movement stopped prematurely'},
  ];

  void _deleteSession() {
    showDialog(
      context: context,
      builder: (ctx) => RSDialog(
        icon: LucideIcons.trash2,
        iconBgColor: RSColors.statusErrorTint,
        iconColor: RSColors.statusError,
        title: 'Delete this session?',
        body: 'This will remove the session and its metrics permanently from your history.',
        primaryButtonLabel: 'Delete session',
        primaryIsDestructive: true,
        onPrimaryPressed: () => context.pop(),
        secondaryButtonLabel: 'Cancel',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedRep = _reps[_selectedRepIndex];

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: const Text('Session details'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical),
            onSelected: (val) {
              if (val == 'delete') _deleteSession();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash, color: RSColors.statusError, size: 18),
                    SizedBox(width: 8),
                    Text('Delete session', style: TextStyle(color: RSColors.statusError)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Retry exercise',
          () => context.push('/courses/knee_rehab/exercise/knee_mini_squat'),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // Exercise header
            Text('Mini Squats', style: RSText.headingH1),
            const SizedBox(height: 2),
            Text(
              'Knee Rehabilitation • Today at 10:30 AM',
              style: RSText.caption.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: RSSpacing.lg),

            // Score ring
            const Center(
              child: RSScoreRing(
                score: 86,
                size: 140,
                isPersonalBest: true,
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // Outcome trio
            Row(
              children: const [
                Expanded(
                  child: _OutcomeCard('7 Correct', RSColors.statusSuccess, RSColors.statusSuccessTint),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _OutcomeCard('2 Incorrect', RSColors.statusError, RSColors.statusErrorTint),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _OutcomeCard('1 Incomplete', RSColors.statusWarningInk, RSColors.statusWarningTint),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.xl),

            // Per-rep timeline strip
            Text('REPETITION TIMELINE', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_reps.length, (i) {
                  final r = _reps[i];
                  final outcome = r['outcome'] as RepOutcome;
                  final isSelected = i == _selectedRepIndex;

                  Color bg = outcome == RepOutcome.correct
                      ? RSColors.statusSuccess
                      : (outcome == RepOutcome.incorrect
                          ? RSColors.statusError
                          : RSColors.statusWarning);

                  return GestureDetector(
                    onTap: () => setState(() => _selectedRepIndex = i),
                    child: Container(
                      width: 44,
                      height: 52,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? bg : bg.withOpacity(0.15),
                        borderRadius: RSRadius.cardBR,
                        border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '#${r['rep']}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Icon(
                            outcome == RepOutcome.correct
                                ? LucideIcons.check
                                : (outcome == RepOutcome.incorrect
                                    ? LucideIcons.x
                                    : LucideIcons.minus),
                            size: 14,
                            color: isSelected ? Colors.white : bg,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),

            // Feedback box for selected rep
            RSCard(
              child: Row(
                children: [
                  const Icon(LucideIcons.messageSquare, size: 20, color: RSColors.brandAction),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rep ${selectedRep['rep']} feedback', style: RSText.bodySmallStrong),
                        const SizedBox(height: 2),
                        Text(
                          selectedRep['feedback'] as String,
                          style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // Metrics
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('SESSION METRICS', style: TextStyle(color: Color(0xFF757575), fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  _MetricRow('Total Time', '02:45'),
                  Divider(height: 16),
                  _MetricRow('Avg Range of Motion', '88° (Target 90°)'),
                  Divider(height: 16),
                  _MetricRow('Average Tempo', '2.8s / rep'),
                  Divider(height: 16),
                  _MetricRow('Left / Right Symmetry', '94% balanced'),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  final String text;
  final Color color;
  final Color bg;

  const _OutcomeCard(this.text, this.color, this.bg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: RSRadius.cardBR),
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String val;

  const _MetricRow(this.label, this.val);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF757575))),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
