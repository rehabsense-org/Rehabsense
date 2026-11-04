import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class RequestDeclinedScreen extends StatelessWidget {
  const RequestDeclinedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.go('/home'),
          semanticLabel: 'Home',
        ),
      ),
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
                  LucideIcons.xCircle,
                  size: 48,
                  color: RSColors.statusWarningInk,
                ),
              ),
              const SizedBox(height: RSSpacing.xl),
              Text(
                'Request not accepted',
                style: RSText.headingH1.copyWith(color: RSColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.sm),
              Text(
                'Dr. Sara Khan was unable to accept your request due to current patient capacity. You can select another specialist matched to your condition.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xxl),
              RSButton.primary(
                'Find another doctor',
                () => context.push('/connect/doctors'),
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.secondary(
                'Back to home',
                () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

