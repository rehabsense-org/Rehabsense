import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';
import 'admin_approve_dialog.dart';
import 'admin_reject_sheet.dart';

class AdminApplicationDetailScreen extends StatelessWidget {
  final String applicationId;

  const AdminApplicationDetailScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context) {
    const doctorName = 'Dr. Sara Khan';

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Doctor Application', style: RSText.bodyStrong),
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
                'Reject',
                () {
                  AdminRejectSheet.show(
                    context,
                    doctorName: doctorName,
                    onConfirm: (reason) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Application rejected. Reason: $reason')),
                      );
                      context.pop();
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RSButton.primary(
                'Approve',
                () {
                  AdminApproveDialog.show(
                    context,
                    doctorName: doctorName,
                    onApproved: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Doctor approved and directory listing activated.')),
                      );
                      context.pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Doctor Info Header Card ───────────────────────────────
            RSCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: RSColors.brandMint,
                    child: Text(
                      'SK',
                      style: TextStyle(color: RSColors.brandGreen, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctorName, style: RSText.headingH3),
                        const SizedBox(height: 2),
                        Text(
                          'sara.khan@clinic.test',
                          style: RSText.caption.copyWith(color: RSColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        const RSStatusChip(
                          type: RSStatusChipType.incomplete,
                          customLabel: 'Pending Staff Review',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── Application Metadata Card ─────────────────────────────
            RSCard(
              child: Column(
                children: [
                  _buildDetailRow('Medical License', 'PMDC-48213'),
                  const Divider(height: 16),
                  _buildDetailRow('Highest Degree', 'DPT, Doctor of Physical Therapy'),
                  const Divider(height: 16),
                  _buildDetailRow('Review Attempt', 'Attempt 1 of 3'),
                  const Divider(height: 16),
                  _buildDetailRow('Submitted Date', 'Today, 9:12 AM'),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Uploaded Credentials Section ──────────────────────────
            Text('UPLOADED CREDENTIALS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            RSCard(
              onTap: () => context.push('/admin/applications/$applicationId/doc/license'),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: RSColors.brandMint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.fileText, color: RSColors.brandGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Medical Practice License', style: RSText.bodyStrong),
                        Text('PDF · 1.2 MB · Tap to view signed file',
                            style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                      ],
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, color: RSColors.textSecondary, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RSCard(
              onTap: () => context.push('/admin/applications/$applicationId/doc/degree'),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: RSColors.brandMint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.fileCheck, color: RSColors.brandGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Degree Certificate', style: RSText.bodyStrong),
                        Text('JPG · 2.4 MB · Tap to view signed file',
                            style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                      ],
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, color: RSColors.textSecondary, size: 20),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            RSButton.text(
              'Resend confirmation email',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Status notification resent to doctor email.')),
                );
              },
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
