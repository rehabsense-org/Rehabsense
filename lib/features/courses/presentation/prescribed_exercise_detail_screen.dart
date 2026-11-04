import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/seed/seed_data.dart';
import '../../../domain/models/models.dart';

class PrescribedExerciseDetailScreen extends StatelessWidget {
  final String assignmentId;

  const PrescribedExerciseDetailScreen({
    super.key,
    required this.assignmentId,
  });

  @override
  Widget build(BuildContext context) {
    // Resolve assignment or fallback to sample
    final assignment = _sampleAssignments.firstWhere(
      (a) => a.id == assignmentId,
      orElse: () => _sampleAssignments.first,
    );

    final exercise = seedExercises.firstWhere(
      (e) => e.id == assignment.exerciseId,
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
            Text(
              'Prescribed by ${assignment.doctorName}',
              style: RSText.caption.copyWith(color: RSColors.brandGreen),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Start exercise',
          () => context.push('/session/${exercise.id}/checklist'),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Doctor Prescription Callout ───────────────────────────
            Container(
              padding: const EdgeInsets.all(RSSpacing.md),
              decoration: BoxDecoration(
                color: RSColors.brandMint,
                borderRadius: RSRadius.cardBR,
                border: Border.all(color: RSColors.brandGreen.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: RSColors.brandGreen,
                        child: Icon(LucideIcons.stethoscope, size: 18, color: RSColors.textOnDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignment.doctorName,
                              style: RSText.bodySmallStrong.copyWith(color: RSColors.brandGreen),
                            ),
                            Text(
                              'Specialist Prescription Plan',
                              style: RSText.caption.copyWith(color: RSColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      RSStatusChip(
                        type: assignment.status == AssignmentStatus.active
                            ? RSStatusChipType.correct
                            : RSStatusChipType.incomplete,
                        customLabel: assignment.status == AssignmentStatus.active ? 'Active' : 'Completed',
                      ),
                    ],
                  ),
                  if (assignment.doctorNotes != null && assignment.doctorNotes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(color: RSColors.brandGreen, height: 1),
                    const SizedBox(height: 10),
                    Text(
                      'CLINICAL NOTES',
                      style: RSText.labelOverline.copyWith(color: RSColors.brandGreen),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assignment.doctorNotes!,
                      style: RSText.bodySmall.copyWith(color: RSColors.textPrimary),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── Target Prescription Summary ───────────────────────────
            RSCard(
              child: Row(
                children: [
                  Expanded(
                    child: _buildParamTile(
                      label: assignment.holdSeconds != null ? 'TARGET HOLD' : 'TARGET REPS',
                      value: assignment.holdSeconds != null
                          ? '${assignment.holdSeconds}s'
                          : '${assignment.targetReps} reps',
                      icon: assignment.holdSeconds != null ? LucideIcons.clock : LucideIcons.repeat,
                    ),
                  ),
                  Container(height: 40, width: 1, color: RSColors.borderHairline),
                  Expanded(
                    child: _buildParamTile(
                      label: 'TARGET SETS',
                      value: '${assignment.targetSets} sets',
                      icon: LucideIcons.layers,
                    ),
                  ),
                  Container(height: 40, width: 1, color: RSColors.borderHairline),
                  Expanded(
                    child: _buildParamTile(
                      label: 'FREQUENCY',
                      value: '${assignment.frequencyDaysPerWeek}x / week',
                      icon: LucideIcons.calendar,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── Schedule details ──────────────────────────────────────
            RSCard(
              child: Row(
                children: [
                  const Icon(LucideIcons.checkCircle, color: RSColors.brandAction, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assigned Schedule', style: RSText.bodySmallStrong),
                        Text(
                          assignment.scheduleDescription,
                          style: RSText.caption.copyWith(color: RSColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Instructions & Steps ──────────────────────────────────
            Text('HOW TO PERFORM', style: RSText.headingH3),
            const SizedBox(height: RSSpacing.sm),
            ...exercise.steps.asMap().entries.map((entry) {
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
                        '${entry.key + 1}',
                        style: RSText.captionStrong.copyWith(color: RSColors.brandGreen),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: RSText.bodyDefault.copyWith(color: RSColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: RSSpacing.md),

            // ── Watch Out For ─────────────────────────────────────────
            if (exercise.watchOutFor.isNotEmpty) ...[
              Text('WATCH OUT FOR', style: RSText.headingH3),
              const SizedBox(height: RSSpacing.sm),
              ...exercise.watchOutFor.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(LucideIcons.alertCircle, color: RSColors.statusWarningInk, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item,
                          style: RSText.bodySmall.copyWith(color: RSColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: RSSpacing.md),
            ],

            // ── Canonical Clinical Disclaimer ─────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RSColors.surfaceCeramic,
                borderRadius: BorderRadius.circular(RSRadius.card),
              ),
              child: Text(
                'RehabSense is a guidance tool. It does not diagnose or replace your physiotherapist.',
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildParamTile({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: RSColors.brandGreen),
        const SizedBox(height: 4),
        Text(value, style: RSText.bodySmallStrong),
        const SizedBox(height: 2),
        Text(
          label,
          style: RSText.labelOverline.copyWith(fontSize: 10, color: RSColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

final List<RSAssignment> _sampleAssignments = [
  RSAssignment(
    id: 'assign_001',
    doctorId: '00000000-0000-0000-0000-000000000002',
    doctorName: 'Dr. Sara Khan',
    patientId: 'patient_001',
    exerciseId: 'knee_mini_squat',
    exerciseName: 'Mini Squat',
    targetReps: 10,
    targetSets: 3,
    frequencyDaysPerWeek: 3,
    scheduleDescription: 'Mon, Wed, Fri',
    doctorNotes:
        'Focus on controlled descent. Do not exceed 45 degrees knee bend if pain is present. Keep back straight.',
    status: AssignmentStatus.active,
    startDate: DateTime.now().subtract(const Duration(days: 3)),
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  RSAssignment(
    id: 'assign_002',
    doctorId: '00000000-0000-0000-0000-000000000002',
    doctorName: 'Dr. Sara Khan',
    patientId: 'patient_001',
    exerciseId: 'knee_straight_leg_raise',
    exerciseName: 'Straight-Leg Raise',
    targetReps: 12,
    targetSets: 2,
    frequencyDaysPerWeek: 2,
    scheduleDescription: 'Tue, Thu',
    doctorNotes: 'Keep the quad actively engaged before lifting the leg.',
    status: AssignmentStatus.active,
    startDate: DateTime.now().subtract(const Duration(days: 2)),
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  RSAssignment(
    id: 'assign_003',
    doctorId: '00000000-0000-0000-0000-000000000002',
    doctorName: 'Dr. Sara Khan',
    patientId: 'patient_001',
    exerciseId: 'ex_wall_sit_hold',
    exerciseName: 'Wall Sit hold',
    targetReps: 3,
    targetSets: 1,
    holdSeconds: 30,
    frequencyDaysPerWeek: 2,
    scheduleDescription: 'Mon, Fri',
    doctorNotes: 'Maintain upright posture against wall and breathe steadily.',
    status: AssignmentStatus.completed,
    startDate: DateTime.now().subtract(const Duration(days: 14)),
    endDate: DateTime.now().subtract(const Duration(days: 1)),
    createdAt: DateTime.now().subtract(const Duration(days: 14)),
  ),
];
