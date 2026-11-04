import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminPatientDetailScreen extends StatefulWidget {
  final String patientId;

  const AdminPatientDetailScreen({super.key, required this.patientId});

  @override
  State<AdminPatientDetailScreen> createState() => _AdminPatientDetailScreenState();
}

class _AdminPatientDetailScreenState extends State<AdminPatientDetailScreen> {
  bool _isDisabled = false;

  void _toggleStatus() {
    setState(() => _isDisabled = !_isDisabled);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isDisabled ? 'Patient account disabled.' : 'Patient account reactivated.')),
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
        title: Text('Patient Account', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.destructiveOutline(
          _isDisabled ? 'Reactivate account' : 'Disable account',
          _toggleStatus,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Patient Account Header Card ───────────────────────────
            RSCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: _isDisabled ? RSColors.statusErrorTint : RSColors.brandMint,
                    child: Text(
                      'AM',
                      style: TextStyle(
                        color: _isDisabled ? RSColors.statusError : RSColors.brandGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alex Morgan', style: RSText.headingH3),
                        const SizedBox(height: 2),
                        Text('alex@rehab.test', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                        const SizedBox(height: 6),
                        RSStatusChip(
                          type: _isDisabled ? RSStatusChipType.incomplete : RSStatusChipType.correct,
                          customLabel: _isDisabled ? 'Disabled' : 'Active Account',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── Account Metadata Card (No clinical data) ──────────────
            RSCard(
              child: Column(
                children: [
                  _buildDetailRow('Account Created', '2 Nov 2026'),
                  const Divider(height: 16),
                  _buildDetailRow('Last Sign In', 'Today, 10:14 AM'),
                  const Divider(height: 16),
                  _buildDetailRow('Email Verified', 'Yes'),
                  const Divider(height: 16),
                  _buildDetailRow('Assigned Doctor', 'Yes (Dr. Sara Khan)'),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Clinical Privacy Boundary Banner ──────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RSColors.surfaceCeramic,
                borderRadius: BorderRadius.circular(RSRadius.card),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(LucideIcons.shieldCheck, color: RSColors.brandGreen, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Account info only. Individual exercise sessions, movement scores, pain logs, and health conditions are strictly private and not visible to staff administrators.',
                      style: RSText.caption.copyWith(color: RSColors.textSecondary),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: RSText.bodySmall.copyWith(color: RSColors.textSecondary)),
        Text(value, style: RSText.bodySmallStrong),
      ],
    );
  }
}

