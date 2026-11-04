import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';
import 'doctor_decline_sheet.dart';

class DoctorRequestDetailScreen extends StatefulWidget {
  final String requestId;

  const DoctorRequestDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<DoctorRequestDetailScreen> createState() => _DoctorRequestDetailScreenState();
}

class _DoctorRequestDetailScreenState extends State<DoctorRequestDetailScreen> {
  void _onAccept() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request accepted. Patient added to your active list.')),
    );
    context.pushReplacement('/doctor/patients/patient_001');
  }

  void _onDecline() {
    DoctorDeclineSheet.show(
      context,
      patientName: 'Alex Mercer',
      onConfirm: (reason) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request declined.')),
        );
        context.pop();
      },
    );
  }

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
        title: Text('Connection Request', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: Row(
          children: [
            Expanded(
              child: RSButton.destructiveOutline(
                'Decline',
                _onDecline,
                size: RSButtonSize.large,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RSButton.primary(
                'Accept patient',
                _onAccept,
                size: RSButtonSize.large,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Patient Profile Header Card ───────────────────────────
            RSCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: RSColors.brandMint,
                    child: Text('AM', style: TextStyle(color: RSColors.brandGreen, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alex Mercer', style: RSText.headingH3),
                        const SizedBox(height: 2),
                        Text('Age 32 · Request submitted 2 hours ago', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            RSStatusChip(
                              type: RSStatusChipType.info,
                              customLabel: 'Right Knee',
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: RSColors.accentGoldWash,
                                borderRadius: BorderRadius.circular(RSRadius.pill),
                                border: Border.all(color: RSColors.accentGold),
                              ),
                              child: Text('95% Match', style: RSText.captionStrong.copyWith(color: RSColors.accentGoldDeep)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── Intake & Symptoms Assessment Card ─────────────────────
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('REPORTED CONDITION', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                  const SizedBox(height: 12),
                  _buildDetailRow('Primary Area', 'Right Knee (ACL Reconstruction rehab)'),
                  const Divider(height: 16),
                  _buildDetailRow('Current Pain Level', '5 / 10 (Moderate pain on bending)'),
                  const Divider(height: 16),
                  _buildDetailRow('Symptom Onset', '6 weeks ago (Post-surgery)'),
                  const Divider(height: 16),
                  _buildDetailRow('Daily Impact', 'Difficulty going down stairs and prolonged standing'),
                  const Divider(height: 16),
                  _buildDetailRow('Recovery Goal', 'Return to jogging and pain-free daily stairs'),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── Safety Screening ──────────────────────────────────────
            RSCard(
              color: RSColors.statusSuccessTint,
              child: Row(
                children: [
                  const Icon(LucideIcons.checkCircle, color: RSColors.statusSuccess, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('No Red Flags Reported', style: RSText.bodySmallStrong.copyWith(color: RSColors.statusSuccess)),
                        const SizedBox(height: 2),
                        Text(
                          'Patient reported no numbness, unexplained weight loss, or severe nighttime pain.',
                          style: RSText.caption.copyWith(color: RSColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Clinical Disclaimer ───────────────────────────────────
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

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: RSText.caption.copyWith(color: RSColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: RSText.bodySmallStrong),
      ],
    );
  }
}

