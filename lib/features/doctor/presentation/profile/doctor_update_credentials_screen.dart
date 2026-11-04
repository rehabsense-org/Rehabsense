import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorUpdateCredentialsScreen extends StatefulWidget {
  const DoctorUpdateCredentialsScreen({super.key});

  @override
  State<DoctorUpdateCredentialsScreen> createState() => _DoctorUpdateCredentialsScreenState();
}

class _DoctorUpdateCredentialsScreenState extends State<DoctorUpdateCredentialsScreen> {
  final _licenseController = TextEditingController(text: 'PMDC-48213');
  final _degreeController = TextEditingController(text: 'DPT, Doctor of Physical Therapy');

  bool _licenseUploaded = true;
  bool _degreeUploaded = true;

  @override
  void dispose() {
    _licenseController.dispose();
    _degreeController.dispose();
    super.dispose();
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Credentials submitted for admin re-review. Your profile remains active.'),
      ),
    );
    context.pop();
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
        title: Text('Credentials & Verification', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Submit for review',
          _submit,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // Warning/Info re-review banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RSColors.accentGoldWash,
                borderRadius: BorderRadius.circular(RSRadius.card),
                border: Border.all(color: RSColors.accentGold),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.alertCircle, color: RSColors.accentGoldDeep, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Updating credentials requires admin re-review. You remain active and listed while the review is pending.',
                      style: RSText.caption.copyWith(color: RSColors.accentGoldDeep),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            RSInput(
              label: 'Medical License Number',
              controller: _licenseController,
            ),
            const SizedBox(height: RSSpacing.md),

            RSInput(
              label: 'Highest Medical Degree',
              controller: _degreeController,
            ),
            const SizedBox(height: RSSpacing.lg),

            Text('VERIFICATION DOCUMENTS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: 8),

            RSDocumentTile(
              title: 'Medical Practice License',
              subtitle: _licenseUploaded ? 'license_pmdc_2024.pdf (2.4 MB)' : 'Tap to upload PDF or JPG',
              isUploaded: _licenseUploaded,
              onTap: () => setState(() => _licenseUploaded = true),
              onDelete: () => setState(() => _licenseUploaded = false),
            ),
            const SizedBox(height: 10),

            RSDocumentTile(
              title: 'Degree Certificate',
              subtitle: _degreeUploaded ? 'dpt_degree_verified.jpg (1.8 MB)' : 'Tap to upload PDF or JPG',
              isUploaded: _degreeUploaded,
              onTap: () => setState(() => _degreeUploaded = true),
              onDelete: () => setState(() => _degreeUploaded = false),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
