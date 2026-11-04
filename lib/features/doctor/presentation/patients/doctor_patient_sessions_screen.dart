import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorPatientSessionsScreen extends StatelessWidget {
  final String patientId;

  const DoctorPatientSessionsScreen({super.key, required this.patientId});

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
        title: Text('Session History', style: RSText.bodyStrong),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            _buildSessionTile(
              context,
              sessionId: 'sess_001',
              exerciseName: 'Mini Squat',
              date: 'Today, 10:30 AM',
              score: 86,
              pain: 5,
              feedbackStatus: 'Pending Feedback',
              needsFeedback: true,
            ),
            const SizedBox(height: 12),
            _buildSessionTile(
              context,
              sessionId: 'sess_002',
              exerciseName: 'Straight-Leg Raise',
              date: 'Yesterday, 4:15 PM',
              score: 91,
              pain: 3,
              feedbackStatus: 'Feedback Sent',
              needsFeedback: false,
            ),
            const SizedBox(height: 12),
            _buildSessionTile(
              context,
              sessionId: 'sess_003',
              exerciseName: 'Mini Squat',
              date: '3 days ago',
              score: 82,
              pain: 6,
              feedbackStatus: 'Feedback Sent',
              needsFeedback: false,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTile(
    BuildContext context, {
    required String sessionId,
    required String exerciseName,
    required String date,
    required int score,
    required int pain,
    required String feedbackStatus,
    required bool needsFeedback,
  }) {
    return RSCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(exerciseName, style: RSText.headingH3),
              RSStatusChip(
                type: needsFeedback ? RSStatusChipType.incomplete : RSStatusChipType.correct,
                customLabel: feedbackStatus,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(date, style: RSText.caption.copyWith(color: RSColors.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Movement score: $score',
                style: RSText.captionStrong.copyWith(color: RSColors.brandAction),
              ),
              const SizedBox(width: 16),
              Text(
                'Pain: $pain/10',
                style: RSText.captionStrong.copyWith(
                  color: pain >= 7 ? RSColors.statusError : RSColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          RSButton.secondary(
            needsFeedback ? 'Review & add feedback' : 'View session & feedback',
            () => context.push('/doctor/sessions/$sessionId/review'),
            size: RSButtonSize.medium,
          ),
        ],
      ),
    );
  }
}

