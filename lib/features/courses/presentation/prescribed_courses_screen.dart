import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class PrescribedCoursesScreen extends StatelessWidget {
  const PrescribedCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'Prescribed Exercises',
          style: RSText.headingH3.copyWith(color: RSColors.brandGreen),
        ),
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: RSSpacing.md),
              RSCard(
                padding: const EdgeInsets.all(RSSpacing.md),
                color: RSColors.brandMint,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: RSColors.brandGreen,
                      child: Text('SK', style: TextStyle(color: RSColors.textOnDark)),
                    ),
                    const SizedBox(width: RSSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prescribed by Dr. Sara Khan',
                            style: RSText.bodySmallStrong.copyWith(color: RSColors.brandGreen),
                          ),
                          Text(
                            'Custom rehabilitation plan for right knee recovery.',
                            style: RSText.caption.copyWith(color: RSColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.md),
              _buildExerciseCard(
                context,
                title: 'Mini Squat',
                subtitle: '3 sets · 10 reps · Mon, Wed, Fri',
                chipLabel: 'Active',
                chipType: RSStatusChipType.correct,
                route: '/courses/prescribed/assign_001',
              ),
              const SizedBox(height: RSSpacing.sm),
              _buildExerciseCard(
                context,
                title: 'Straight-Leg Raise',
                subtitle: '2 sets · 12 reps · Tue, Thu',
                chipLabel: 'Active',
                chipType: RSStatusChipType.correct,
                route: '/courses/prescribed/assign_002',
              ),
              const SizedBox(height: RSSpacing.sm),
              _buildExerciseCard(
                context,
                title: 'Wall Sit hold',
                subtitle: '3 holds · 30 s · Mon, Fri',
                chipLabel: 'Ended',
                chipType: RSStatusChipType.incomplete,
                route: '/courses/prescribed/assign_003',
              ),
              const SizedBox(height: RSSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String chipLabel,
    required RSStatusChipType chipType,
    required String route,
  }) {
    return RSCard(
      onTap: () => context.push(route),
      padding: const EdgeInsets.all(RSSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: RSColors.brandMint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.activity,
              size: 20,
              color: RSColors.brandGreen,
            ),
          ),
          const SizedBox(width: RSSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: RSText.bodyStrong.copyWith(color: RSColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: RSText.caption.copyWith(color: RSColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: RSSpacing.sm),
          RSStatusChip(
            type: chipType,
            customLabel: chipLabel,
          ),
        ],
      ),
    );
  }
}
