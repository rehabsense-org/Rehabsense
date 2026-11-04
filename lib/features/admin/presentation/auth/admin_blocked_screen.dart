import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminBlockedScreen extends StatelessWidget {
  const AdminBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.go('/admin/login'),
          semanticLabel: 'Back',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: RSColors.statusErrorTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.ban, size: 40, color: RSColors.statusError),
                ),
              ),
              const SizedBox(height: RSSpacing.lg),
              Text(
                'No access',
                style: RSText.headingH1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'This account does not have staff administrator privileges. Please use the patient or doctor portal instead.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xl),
              RSButton.primary(
                'Back to welcome',
                () => context.go('/welcome'),
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.secondary(
                'Try another account',
                () => context.go('/admin/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

