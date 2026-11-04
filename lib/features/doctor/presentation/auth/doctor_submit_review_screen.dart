import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorSubmitReviewScreen extends StatefulWidget {
  const DoctorSubmitReviewScreen({super.key});

  @override
  State<DoctorSubmitReviewScreen> createState() => _DoctorSubmitReviewScreenState();
}

class _DoctorSubmitReviewScreenState extends State<DoctorSubmitReviewScreen> {
  bool _declarationAccepted = false;
  bool _submitting = false;

  void _onSubmit() async {
    if (!_declarationAccepted) return;

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    context.go('/doctor/application-status');
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
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Submit application',
          _declarationAccepted ? _onSubmit : null,
          disabled: !_declarationAccepted,
          loading: _submitting,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            const RSStepHeader(
              currentStep: 3,
              totalSteps: 3,
              title: 'Review & Submit',
            ),
            const SizedBox(height: RSSpacing.md),
            Text(
              'Please review your registration details carefully before submitting for verification.',
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Practitioner Summary Card ─────────────────────────────
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PRACTITIONER DETAILS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text('Edit', style: RSText.captionStrong.copyWith(color: RSColors.brandAction)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildReviewRow('Full Name', 'Dr. Sara Khan'),
                  const Divider(height: 16),
                  _buildReviewRow('Title', 'Physiotherapist'),
                  const Divider(height: 16),
                  _buildReviewRow('Clinic / Hospital', 'Apex Physical Therapy Centre'),
                  const Divider(height: 16),
                  _buildReviewRow('License No.', 'PT-98231-NY'),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── Documents Uploaded Card ───────────────────────────────
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UPLOADED CREDENTIALS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                  const SizedBox(height: 12),
                  _buildDocItem('State_PT_License_2026.pdf', 'Practice License'),
                  const SizedBox(height: 8),
                  _buildDocItem('Doctorate_Physical_Therapy.pdf', 'Medical / PT Degree'),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Compliance Declaration Checkbox ───────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RSColors.surfaceCard,
                borderRadius: BorderRadius.circular(RSRadius.card),
                border: Border.all(
                  color: _declarationAccepted ? RSColors.brandGreen : RSColors.borderInput,
                ),
              ),
              child: InkWell(
                onTap: () => setState(() => _declarationAccepted = !_declarationAccepted),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _declarationAccepted,
                      activeColor: RSColors.brandGreen,
                      onChanged: (val) => setState(() => _declarationAccepted = val ?? false),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'I certify under penalty of professional license revocation that all provided credentials, licenses, and diplomas are authentic, valid, and belong to me.',
                        style: RSText.bodySmall.copyWith(color: RSColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: RSText.bodySmall.copyWith(color: RSColors.textSecondary)),
        Text(value, style: RSText.bodySmallStrong),
      ],
    );
  }

  Widget _buildDocItem(String name, String type) {
    return Row(
      children: [
        const Icon(LucideIcons.fileCheck, size: 18, color: RSColors.statusSuccess),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: RSText.bodySmallStrong),
              Text(type, style: RSText.caption.copyWith(color: RSColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}

