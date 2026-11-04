import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorPatientConditionScreen extends StatelessWidget {
  final String patientId;

  const DoctorPatientConditionScreen({super.key, required this.patientId});

  void _showDisconnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => RSDialog(
        icon: LucideIcons.userMinus,
        iconBgColor: RSColors.statusErrorTint,
        iconColor: RSColors.statusError,
        title: 'End Patient Care Relationship?',
        body:
            'This will archive Alex Mercer from your active caseload. '
            'Existing exercise assignments will remain viewable by the patient until their target end date.',
        primaryButtonLabel: 'Keep patient in care',
        onPrimaryPressed: () => Navigator.pop(ctx),
        secondaryButtonLabel: 'End relationship',
        isSecondaryDestructive: true,
        onSecondaryPressed: () {
          Navigator.pop(ctx);
          context.go('/doctor/patients');
        },
      ),
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
        title: Text('Condition & Intake', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.destructiveOutline(
          'End care relationship',
          () => _showDisconnectDialog(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PATIENT INTAKE FORM', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                  const SizedBox(height: 12),
                  _buildItem('Primary Area', 'Right Knee'),
                  const Divider(height: 16),
                  _buildItem('Condition Type', 'Post-Surgical ACL Reconstruction'),
                  const Divider(height: 16),
                  _buildItem('Baseline Pain', '5 / 10'),
                  const Divider(height: 16),
                  _buildItem('Onset', '6 weeks ago'),
                  const Divider(height: 16),
                  _buildItem('Aggravating Activities', 'Stairs, prolonged sitting, squats'),
                  const Divider(height: 16),
                  _buildItem('Patient Goal', 'Return to daily jogging and pain-free stairs'),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),
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
                        Text('Red Flags Screening Clear', style: RSText.bodySmallStrong.copyWith(color: RSColors.statusSuccess)),
                        const SizedBox(height: 2),
                        Text(
                          'No history of unexplained swelling, numbness, or night pain.',
                          style: RSText.caption.copyWith(color: RSColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value) {
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

