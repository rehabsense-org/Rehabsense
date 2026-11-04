import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorDocumentsScreen extends StatefulWidget {
  const DoctorDocumentsScreen({super.key});

  @override
  State<DoctorDocumentsScreen> createState() => _DoctorDocumentsScreenState();
}

class _DoctorDocumentsScreenState extends State<DoctorDocumentsScreen> {
  bool _licenseUploaded = true;
  bool _degreeUploaded = true;
  bool _certUploaded = false;

  @override
  Widget build(BuildContext context) {
    final canProceed = _licenseUploaded && _degreeUploaded;

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Review application',
          canProceed ? () => context.push('/doctor/onboarding/review') : null,
          disabled: !canProceed,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            const RSStepHeader(
              currentStep: 2,
              totalSteps: 3,
              title: 'Upload Credentials',
            ),
            const SizedBox(height: RSSpacing.md),
            Text(
              'To ensure patient safety, our clinical compliance team verifies all licenses '
              'and practitioner degrees before activation.',
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Section 1: Practice License (Required) ───────────────
            Text('PRACTICE LICENSE *', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            if (_licenseUploaded)
              RSDocumentTile(
                title: 'State_PT_License_2026.pdf',
                subtitle: '1.4 MB · Uploaded',
                isUploaded: true,
                onDelete: () => setState(() => _licenseUploaded = false),
              )
            else
              _buildUploadBox(
                label: 'Upload License (PDF, PNG, JPG)',
                onTap: () => setState(() => _licenseUploaded = true),
              ),
            const SizedBox(height: RSSpacing.md),

            // ── Section 2: Medical / PT Degree (Required) ────────────
            Text('MEDICAL / PT DEGREE *', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            if (_degreeUploaded)
              RSDocumentTile(
                title: 'Doctorate_Physical_Therapy.pdf',
                subtitle: '2.8 MB · Uploaded',
                isUploaded: true,
                onDelete: () => setState(() => _degreeUploaded = false),
              )
            else
              _buildUploadBox(
                label: 'Upload Degree Certificate',
                onTap: () => setState(() => _degreeUploaded = true),
              ),
            const SizedBox(height: RSSpacing.md),

            // ── Section 3: Additional Certifications (Optional) ──────
            Text('SPECIALIST CERTIFICATIONS (OPTIONAL)', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            if (_certUploaded)
              RSDocumentTile(
                title: 'Orthopedic_Board_Specialist.pdf',
                subtitle: '950 KB · Uploaded',
                isUploaded: true,
                onDelete: () => setState(() => _certUploaded = false),
              )
            else
              _buildUploadBox(
                label: 'Add Specialist Certificate',
                onTap: () => setState(() => _certUploaded = true),
              ),
            const SizedBox(height: RSSpacing.lg),

            // ── Security notice ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RSColors.surfaceCeramic,
                borderRadius: BorderRadius.circular(RSRadius.card),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.lock, size: 18, color: RSColors.brandGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your documents are encrypted and stored in private healthcare compliance buckets.',
                      style: RSText.caption.copyWith(color: RSColors.textPrimary),
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

  Widget _buildUploadBox({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RSRadius.card),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          borderRadius: BorderRadius.circular(RSRadius.card),
          border: Border.all(color: RSColors.borderInput, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.uploadCloud, color: RSColors.brandAction, size: 20),
            const SizedBox(width: 10),
            Text(label, style: RSText.bodySmallStrong.copyWith(color: RSColors.brandAction)),
          ],
        ),
      ),
    );
  }
}
