import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../app/auth_notifier.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorApplicationRejectedScreen extends StatelessWidget {
  final String rejectionReason;
  final int attemptNumber;

  const DoctorApplicationRejectedScreen({
    super.key,
    this.rejectionReason = 'The license document uploaded was expired or not clearly readable. Please upload a current, clear photo or PDF of your state practice license.',
    this.attemptNumber = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Application Update'),
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
          'Update documents & resubmit',
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
                    color: RSColors.statusErrorTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.alertTriangle, color: RSColors.statusError, size: 32),
                ),
              ),
              const SizedBox(height: RSSpacing.md),
              Text(
                'Application needs attention',
                style: RSText.headingH2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Our compliance team was unable to verify your application. '
                'Please review the feedback below and update your credentials.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xl),

              // ── Admin Reason Card ───────────────────────────────────
              RSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('FEEDBACK FROM REVIEWER', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                        Text('Attempt $attemptNumber of 3', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      rejectionReason,
                      style: RSText.bodyDefault.copyWith(color: RSColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.lg),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RSColors.surfaceCeramic,
                  borderRadius: BorderRadius.circular(RSRadius.card),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.helpCircle, size: 18, color: RSColors.brandGreen),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Questions about your review? Contact support@rehabsense.com',
                        style: RSText.caption.copyWith(color: RSColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

