import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../app/auth_notifier.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class InactiveAccountScreen extends StatelessWidget {
  final String? portal; // 'patient', 'doctor', 'admin'

  const InactiveAccountScreen({
    super.key,
    this.portal = 'patient',
  });

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
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: RSColors.statusWarningTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.ban,
                  size: 48,
                  color: RSColors.statusWarningInk,
                ),
              ),
              const SizedBox(height: RSSpacing.xl),
              Text(
                'Account inactive',
                style: RSText.headingH1.copyWith(color: RSColors.brandGreen),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.sm),
              Text(
                portal == 'doctor'
                    ? 'Your doctor account is suspended. Please contact clinic support.'
                    : 'Your account is currently disabled. Please contact support to restore it.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xxl),
              RSButton.primary(
                'Log out',
                () async {
                  await AuthNotifier.instance.signOut();
                  if (context.mounted) {
                    context.go('/welcome');
                  }
                },
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.secondary(
                'Contact support',
                () {
                  context.push('/profile/settings');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
