import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class DoctorProfilePublicScreen extends StatelessWidget {
  final String doctorId;

  const DoctorProfilePublicScreen({
    super.key,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    const docName = 'Dr. Sara Khan';
    const docTitle = 'Physiotherapist · 8 years experience';
    const clinic = 'City Rehab Clinic';
    const city = 'Karachi';
    const languages = 'English, Urdu';
    final expertise = ['Knee', 'Post-surgery', 'Sports injury'];
    const bio =
        'I help patients return to daily life after knee surgery using clear, gradual exercise plans tailored to mobility and pain limits.';
    const approach =
        'Small steps, objective angle tracking, honest feedback, and regular weekly progression checks.';

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'Doctor Profile',
          style: RSText.headingH3.copyWith(color: RSColors.brandGreen),
        ),
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(RSSpacing.screenH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 48,
                            backgroundColor: RSColors.brandMint,
                            child: Text(
                              'SK',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: RSColors.brandGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: RSSpacing.md),
                          Text(docName, style: RSText.headingH1),
                          const SizedBox(height: 2),
                          Text(
                            docTitle,
                            style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                          ),
                          const SizedBox(height: RSSpacing.sm),
                          const RSStatusChip(
                            type: RSStatusChipType.correct,
                            customLabel: 'Accepting patients',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: RSSpacing.xl),

                    RSCard(
                      padding: const EdgeInsets.all(RSSpacing.md),
                      child: Column(
                        children: [
                          _buildDetailRow('Clinic', clinic),
                          const Divider(),
                          _buildDetailRow('City', city),
                          const Divider(),
                          _buildDetailRow('Languages', languages),
                        ],
                      ),
                    ),
                    const SizedBox(height: RSSpacing.lg),

                    Text('Clinical Expertise', style: RSText.bodyStrong),
                    const SizedBox(height: RSSpacing.sm),
                    Wrap(
                      spacing: RSSpacing.xs,
                      runSpacing: RSSpacing.xs,
                      children: expertise.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: RSSpacing.md,
                            vertical: RSSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: RSColors.surfaceCeramic,
                            borderRadius: RSRadius.pillBR,
                          ),
                          child: Text(
                            tag,
                            style: RSText.bodySmall.copyWith(color: RSColors.textPrimary),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: RSSpacing.lg),

                    Text('About', style: RSText.bodyStrong),
                    const SizedBox(height: RSSpacing.xs),
                    Text(bio, style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary)),
                    const SizedBox(height: RSSpacing.md),

                    Text('Approach', style: RSText.bodyStrong),
                    const SizedBox(height: RSSpacing.xs),
                    Text(approach, style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(RSSpacing.screenH),
              child: RSButton.primary(
                'Request this doctor',
                () => context.push('/connect/doctors/$doctorId/request'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: RSText.bodySmall.copyWith(color: RSColors.textSecondary)),
          Text(value, style: RSText.bodySmallStrong),
        ],
      ),
    );
  }
}

