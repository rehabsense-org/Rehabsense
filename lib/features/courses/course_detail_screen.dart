import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/seed/seed_data.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final course = seedCourses.firstWhere(
      (c) => c.id == courseId,
      orElse: () => seedCourses.first,
    );

    final exercises = seedExercises
        .where((e) => course.exerciseIds.contains(e.id))
        .toList();

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text(course.name),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Continue course',
          () {
            if (exercises.isNotEmpty) {
              context.push('/courses/$courseId/exercise/${exercises.first.id}');
            }
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Hero Band ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(RSSpacing.lg),
              decoration: BoxDecoration(
                color: RSColors.brandDeep,
                borderRadius: RSRadius.cardBR,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COURSE',
                    style: RSText.labelOverline.copyWith(color: RSColors.brandMint),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.name,
                    style: RSText.headingH1.copyWith(color: RSColors.textOnDark),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: RSText.bodySmall.copyWith(color: RSColors.textOnDarkSoft),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildChip(LucideIcons.clock, '15 mins'),
                      const SizedBox(width: 8),
                      _buildChip(LucideIcons.list, '5 exercises'),
                      const SizedBox(width: 8),
                      _buildChip(LucideIcons.camera, 'Camera'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '2 of 5 completed',
                    style: RSText.captionStrong.copyWith(color: RSColors.brandMint),
                  ),
                  const SizedBox(height: 6),
                  const RSProgressBar(
                    value: 0.4,
                    fillColor: RSColors.brandMint,
                    trackColor: RSColors.brandUplift,
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.xl),

            Text('Exercises', style: RSText.headingH3),
            const SizedBox(height: RSSpacing.sm),

            // ── Exercise List ───────────────────────────────────────────
            ...List.generate(exercises.length, (index) {
              final ex = exercises[index];
              final isCompleted = index < 2;
              final isInProgress = index == 2;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: RSCard(
                  onTap: () => context.push('/courses/$courseId/exercise/${ex.id}'),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? RSColors.brandAction
                              : RSColors.surfaceCeramic,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isCompleted
                                ? Colors.white
                                : RSColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex.name, style: RSText.bodyStrong),
                            const SizedBox(height: 2),
                            Text(
                              '${ex.targetReps} reps • ${ex.targetSets} sets',
                              style: RSText.caption.copyWith(color: RSColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      if (isCompleted)
                        const RSStatusChip(
                          type: RSStatusChipType.correct,
                          customLabel: '86',
                          compact: true,
                        )
                      else if (isInProgress)
                        const RSStatusChip(
                          type: RSStatusChipType.incomplete,
                          customLabel: 'In progress',
                          compact: true,
                        )
                      else
                        const Icon(LucideIcons.chevronRight, size: 20, color: RSColors.borderInput),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: RSColors.brandUplift,
        borderRadius: BorderRadius.circular(RSRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: RSColors.brandMint),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
