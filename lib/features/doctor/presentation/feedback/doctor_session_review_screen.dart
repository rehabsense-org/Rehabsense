import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorSessionReviewScreen extends StatefulWidget {
  final String sessionId;
  final String? patientId;

  const DoctorSessionReviewScreen({
    super.key,
    required this.sessionId,
    this.patientId,
  });

  @override
  State<DoctorSessionReviewScreen> createState() => _DoctorSessionReviewScreenState();
}

class _DoctorSessionReviewScreenState extends State<DoctorSessionReviewScreen> {
  final _feedbackController = TextEditingController(
    text: 'Thanks for reporting your pain level. Please pause squats for 48 hours and ice the knee. Call the clinic if swelling appears.',
  );

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _sendFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback sent to patient successfully.')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    const movementScore = 78;
    const painLevel = 8;

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Session Review', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Send feedback',
          _sendFeedback,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Session Header Card with Movement Score ───────────────
            RSCard(
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: RSColors.brandMint,
                      shape: BoxShape.circle,
                      border: Border.all(color: RSColors.brandGreen, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '$movementScore',
                        style: RSText.headingH2.copyWith(color: RSColors.brandGreen),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mini Squat', style: RSText.headingH3),
                        const SizedBox(height: 2),
                        Text(
                          'Ali Raza · Today 10:30 AM',
                          style: RSText.caption.copyWith(color: RSColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        const RSStatusChip(
                          type: RSStatusChipType.incorrect,
                          customLabel: 'High Pain Reported (8/10)',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── Pain Alert Banner ─────────────────────────────────────
            if (painLevel >= 7) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RSColors.statusErrorTint,
                  borderRadius: BorderRadius.circular(RSRadius.card),
                  border: Border.all(color: RSColors.statusError),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.alertTriangle, color: RSColors.statusError, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'High Pain Level: 8 / 10',
                            style: RSText.bodySmallStrong.copyWith(color: RSColors.statusError),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Patient reported: "Sharp pain on the last reps."',
                            style: RSText.caption.copyWith(color: RSColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.md),
            ],

            // ── Repetition Summary Stats ──────────────────────────────
            Row(
              children: [
                Expanded(
                  child: RSStatTile(
                    label: 'Target Reps',
                    value: '10',
                  ),
                ),
                const SizedBox(width: RSSpacing.md),
                Expanded(
                  child: RSStatTile(
                    label: 'Correct Reps',
                    value: '6',
                    valueColor: RSColors.statusSuccess,
                  ),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Rep By Rep Breakdown ──────────────────────────────────
            Text('REP BY REP BREAKDOWN', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            RSCard(
              child: Column(
                children: [
                  _buildRepItem(1, 'Correct', '42° knee flex', RSStatusChipType.correct),
                  const Divider(height: 16),
                  _buildRepItem(2, 'Incomplete', '28° (Did not reach target depth)', RSStatusChipType.incomplete),
                  const Divider(height: 16),
                  _buildRepItem(3, 'Incorrect', '55° (Exceeded safe range)', RSStatusChipType.incorrect),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Doctor Feedback Section ───────────────────────────────
            Text('CLINICAL FEEDBACK', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            RSInput(
              hintText: 'Write feedback for your patient (max 500 characters)...',
              controller: _feedbackController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_feedbackController.text.length} / 500',
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Canonical Disclaimer ──────────────────────────────────
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

  Widget _buildRepItem(int number, String outcome, String detail, RSStatusChipType type) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: RSColors.surfaceCeramic,
          child: Text('$number', style: RSText.captionStrong),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rep $number', style: RSText.bodySmallStrong),
              Text(detail, style: RSText.caption.copyWith(color: RSColors.textSecondary)),
            ],
          ),
        ),
        RSStatusChip(
          type: type,
          customLabel: outcome,
        ),
      ],
    );
  }
}
