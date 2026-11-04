import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../app/auth_notifier.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorInactiveScreen extends StatelessWidget {
  const DoctorInactiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: RSColors.statusWarningTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.shieldAlert,
                  size: 40,
                  color: RSColors.statusWarningInk,
                ),
              ),
              const SizedBox(height: RSSpacing.xl),
              Text(
                'Doctor Account Suspended',
                style: RSText.headingH2.copyWith(color: RSColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.sm),
              Text(
                'Your doctor portal access has been deactivated by administration. '
                'Active patient assignments have been paused.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xl),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: RSColors.surfaceCeramic,
                  borderRadius: BorderRadius.circular(RSRadius.card),
                ),
                child: Column(
                  children: [
                    Text(
                      'Need help restoring your access?',
                      style: RSText.bodySmallStrong,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Contact our clinical support team at clinical-support@rehabsense.com',
                      style: RSText.caption.copyWith(color: RSColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.xxl),
              RSButton.primary(
                'Sign out',
                () async {
                  await AuthNotifier.instance.signOut();
                  if (context.mounted) context.go('/welcome');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

