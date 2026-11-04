import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorPatientPlanScreen extends StatelessWidget {
  final String patientId;

  const DoctorPatientPlanScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Prescribed Plan', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Assign new exercise',
          () => context.push('/doctor/patients/$patientId/assign'),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            Text(
              'Active Prescriptions',
              style: RSText.labelOverline.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: RSSpacing.xs),
            _buildAssignmentCard(
              title: 'Mini Squat',
              dosage: '3 sets · 10 reps',
              frequency: 'Mon, Wed, Fri',
              notes: 'Focus on slow descent. Do not exceed 45 degrees if painful.',
              isActive: true,
            ),
            const SizedBox(height: 12),
            _buildAssignmentCard(
              title: 'Straight-Leg Raise',
              dosage: '2 sets · 12 reps',
              frequency: 'Tue, Thu',
              notes: 'Ensure quadriceps is fully engaged before lift.',
              isActive: true,
            ),
            const SizedBox(height: RSSpacing.lg),

            Text(
              'Completed Prescriptions',
              style: RSText.labelOverline.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: RSSpacing.xs),
            _buildAssignmentCard(
              title: 'Wall Sit hold',
              dosage: '3 holds · 30 s',
              frequency: 'Mon, Fri',
              notes: 'Keep back flat against the wall.',
              isActive: false,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard({
    required String title,
    required String dosage,
    required String frequency,
    required String notes,
    required bool isActive,
  }) {
    return RSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: RSText.headingH3),
              RSStatusChip(
                type: isActive ? RSStatusChipType.correct : RSStatusChipType.incomplete,
                customLabel: isActive ? 'Active' : 'Completed',
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('$dosage • $frequency', style: RSText.bodySmallStrong.copyWith(color: RSColors.brandAction)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: RSColors.surfaceCeramic,
              borderRadius: BorderRadius.circular(RSRadius.card),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(LucideIcons.fileText, size: 16, color: RSColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notes,
                    style: RSText.bodySmall.copyWith(color: RSColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

