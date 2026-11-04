import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../app/auth_notifier.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorResumeApplicationScreen extends StatelessWidget {
  const DoctorResumeApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Incomplete Application'),
        actions: [
          RSIconButton.plain(
            icon: LucideIcons.logOut,
            onPressed: () async {
              await AuthNotifier.instance.signOut();
              if (context.mounted) context.go('/welcome');
            },
            semanticLabel: 'Log out',
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Resume application',
          () => context.push('/doctor/onboarding/documents'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: RSSpacing.md),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: RSColors.brandMint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.fileText, color: RSColors.brandGreen, size: 32),
                ),
              ),
              const SizedBox(height: RSSpacing.md),
              Text(
                'Finish your registration',
                style: RSText.headingH2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Your credentials and practice documents still need to be uploaded '
                'before we can submit your profile for admin verification.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xl),

              RSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('REGISTRATION PROGRESS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                    const SizedBox(height: 12),
                    _buildStepRow('1. Account details', true),
                    const Divider(height: 16),
                    _buildStepRow('2. Email verified', true),
                    const Divider(height: 16),
                    _buildStepRow('3. Credentials & practice license', false),
                    const Divider(height: 16),
                    _buildStepRow('4. Final review and submission', false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow(String title, bool done) {
    return Row(
      children: [
        Icon(
          done ? LucideIcons.checkCircle : LucideIcons.circle,
          color: done ? RSColors.statusSuccess : RSColors.textSecondary,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: done ? RSText.bodySmallStrong : RSText.bodySmall.copyWith(color: RSColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

