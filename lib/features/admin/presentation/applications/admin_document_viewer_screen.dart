import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminDocumentViewerScreen extends StatelessWidget {
  final String applicationId;
  final String docId;

  const AdminDocumentViewerScreen({
    super.key,
    required this.applicationId,
    required this.docId,
  });

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
        title: Text('Verification Document', style: RSText.bodyStrong),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RSColors.accentGoldWash,
                borderRadius: BorderRadius.circular(RSRadius.card),
                border: Border.all(color: RSColors.accentGold),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.clock, color: RSColors.accentGoldDeep, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This secure signed URL expires in 60 seconds. Reopen if it stops loading.',
                      style: RSText.caption.copyWith(color: RSColors.accentGoldDeep),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // Document simulated page
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OFFICIAL CREDENTIAL', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text('Dr. Sara Khan', style: RSText.headingH2),
                  const SizedBox(height: 2),
                  Text('License No. PMDC-48213', style: RSText.bodyStrong),
                  Text('Certified Doctor of Physical Therapy · Valid until 2029',
                      style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                  const Divider(height: 24),
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: RSColors.surfaceCeramic,
                      borderRadius: BorderRadius.circular(RSRadius.card),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.fileCheck, size: 48, color: RSColors.brandGreen),
                          const SizedBox(height: 12),
                          Text('Medical Board Seal & Signatures Verified', style: RSText.bodySmallStrong),
                          const SizedBox(height: 4),
                          Text('Signed SHA-256 hash verified with registry',
                              style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            RSButton.secondary(
              'Reopen secure link',
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Regenerated signed link (valid 60 seconds).')),
                );
              },
            ),
            const SizedBox(height: RSSpacing.sm),
            RSButton.text(
              'Back to application',
              () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

