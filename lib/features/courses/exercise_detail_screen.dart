import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/seed/seed_data.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String courseId;
  final String exerciseId;

  const ExerciseDetailScreen({
    super.key,
    required this.courseId,
    required this.exerciseId,
  });

  @override
  Widget build(BuildContext context) {
    final course = seedCourses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => seedCourses.first,
    );

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
        title: Column(
          children: [
            Text(exercise.name, style: RSText.bodyStrong),
            Text(course.name, style: RSText.caption.copyWith(color: RSColors.textSecondary)),
          ],
        ),
        actions: [
          RSIconButton.plain(
            icon: LucideIcons.helpCircle,
            onPressed: () => context.push('/profile/help'),
            semanticLabel: 'Help',
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
          'Start exercise',
          () => context.push('/session/$exerciseId/checklist'),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Demo Video / Illustration Placeholder ──────────────────
            Container(
              height: 190,
              decoration: BoxDecoration(
                color: RSColors.brandDeep,
                borderRadius: RSRadius.cardBR,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.play,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Demo video • 0:45',
                        style: RSText.captionStrong.copyWith(color: RSColors.textOnDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Targets Row ─────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _buildTargetCard('REPS', '${exercise.targetReps} reps'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTargetCard('SETS', '${exercise.targetSets} sets'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTargetCard('REST', '${exercise.restSeconds}s'),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── What It Helps ───────────────────────────────────────────
            Text('What it helps', style: RSText.headingH3),
            const SizedBox(height: 6),
            Text(
              exercise.whatItHelps,
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── How To Do It ────────────────────────────────────────────
            Text('How to do it', style: RSText.headingH3),
            const SizedBox(height: 10),
            RSCard(
              child: Column(
                children: List.generate(exercise.steps.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: RSColors.brandMint,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${i + 1}',
                            style: RSText.captionStrong.copyWith(color: RSColors.brandGreen),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(exercise.steps[i], style: RSText.bodyDefault),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Watch Out For ───────────────────────────────────────────
            if (exercise.watchOutFor.isNotEmpty) ...[
              Text('Watch out for', style: RSText.headingH3),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(RSSpacing.md),
                decoration: BoxDecoration(
                  color: RSColors.statusWarningTint,
                  borderRadius: RSRadius.cardBR,
                  border: Border.all(color: RSColors.statusWarning.withOpacity(0.4)),
                ),
                child: Column(
                  children: exercise.watchOutFor.map((tip) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.alertTriangle, size: 18, color: RSColors.statusWarningInk),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            tip,
                            style: RSText.bodySmall.copyWith(color: RSColors.statusWarningInk),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: RSSpacing.lg),
            ],

            // ── Disclaimer per spec rule 3 ──────────────────────────────
            Text(
              'RehabSense is a guidance tool. It does not diagnose or replace your physiotherapist.',
              style: RSText.caption.copyWith(color: RSColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetCard(String label, String value) {
    return RSCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Text(label, style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value, style: RSText.bodyStrong),
        ],
      ),
    );
  }
}
