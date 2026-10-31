import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/seed/seed_data.dart';
import '../../domain/models/models.dart';

class ExerciseProgressScreen extends StatelessWidget {
  final String exerciseId;

  const ExerciseProgressScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    final exercise = seedExercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => seedExercises.first,
    );

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text(exercise.name),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // Stat row: Best score, average, attempts
            Row(
              children: const [
                Expanded(
                  child: RSStatTile(
                    label: 'Best Score',
                    value: '92',
                    valueColor: RSColors.statusSuccess,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: RSStatTile(
                    label: 'Avg Score',
                    value: '84',
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: RSStatTile(
                    label: 'Attempts',
                    value: '8',
                  ),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.lg),

            // Outcome distribution bar
            Text('Outcome distribution', style: RSText.headingH3),
            const SizedBox(height: 8),
            RSCard(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 12,
                      child: Row(
                        children: const [
                          Expanded(flex: 70, child: ColoredBox(color: RSColors.statusSuccess)),
                          Expanded(flex: 20, child: ColoredBox(color: RSColors.statusError)),
                          Expanded(flex: 10, child: ColoredBox(color: RSColors.statusWarning)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _distLegend(RSColors.statusSuccess, '70% Correct'),
                      _distLegend(RSColors.statusError, '20% Incorrect'),
                      _distLegend(RSColors.statusWarning, '10% Incomplete'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.xl),

            // Sessions list
            Text('Session history', style: RSText.headingH3),
            const SizedBox(height: 8),
            ...List.generate(4, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RSCard(
                  onTap: () => context.push('/progress/session/sess_00${i + 1}'),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Session #${4 - i}', style: RSText.bodyStrong),
                            Text('${i + 1} days ago • 10 reps', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                          ],
                        ),
                      ),
                      Text('Score ${90 - i * 3}', style: RSText.bodyStrong.copyWith(color: RSColors.brandAction)),
                      const SizedBox(width: 8),
                      RSStatusChip.fromOutcome(RepOutcome.correct, compact: true),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _distLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text, style: RSText.caption.copyWith(color: RSColors.textSecondary)),
      ],
    );
  }
}
