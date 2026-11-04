import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class ConnectHubScreen extends StatelessWidget {
  const ConnectHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'Connect with a doctor',
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
                padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: RSSpacing.md),
                    Text(
                      'Get a plan made for you',
                      style: RSText.headingH1,
                    ),
                    const SizedBox(height: RSSpacing.xs),
                    Text(
                      'Share your recovery condition, choose an accredited physiotherapist, and receive tailored exercises.',
                      style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                    ),
                    const SizedBox(height: RSSpacing.xl),

                    _buildStepBullet(
                      step: '1',
                      title: 'Tell us about your condition',
                      subtitle: 'A few quick questions about where it hurts and your goals.',
                      icon: LucideIcons.clipboardList,
                    ),
                    const SizedBox(height: RSSpacing.md),
                    _buildStepBullet(
                      step: '2',
                      title: 'Choose a verified doctor',
                      subtitle: 'Matched specifically to your joint recovery needs.',
                      icon: LucideIcons.userCheck,
                    ),
                    const SizedBox(height: RSSpacing.md),
                    _buildStepBullet(
                      step: '3',
                      title: 'Send a request',
                      subtitle: 'Once accepted, your doctor assigns guided exercises.',
                      icon: LucideIcons.send,
                    ),
                    const SizedBox(height: RSSpacing.lg),

                    RSCard(
                      padding: const EdgeInsets.all(RSSpacing.md),
                      color: RSColors.brandMint,
                      child: Row(
                        children: [
                          const Icon(LucideIcons.shieldCheck, color: RSColors.brandGreen, size: 24),
                          const SizedBox(width: RSSpacing.md),
                          Expanded(
                            child: Text(
                              'Your privacy is protected. Only the doctor you request can view your condition summary. Doctors never see your camera video.',
                              style: RSText.caption.copyWith(color: RSColors.brandDeep),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: RSSpacing.xl),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(RSSpacing.screenH),
              child: RSButton.primary(
                'Start',
                () => context.push('/connect/condition'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepBullet({
    required String step,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return RSCard(
      padding: const EdgeInsets.all(RSSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: RSColors.brandMint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: RSColors.brandGreen),
          ),
          const SizedBox(width: RSSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: RSText.bodyStrong),
                const SizedBox(height: 2),
                Text(subtitle, style: RSText.bodySmall.copyWith(color: RSColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
