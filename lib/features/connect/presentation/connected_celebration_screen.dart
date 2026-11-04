import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class ConnectedCelebrationScreen extends StatelessWidget {
  const ConnectedCelebrationScreen({super.key});

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
                  color: RSColors.brandMint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.heartHandshake,
                  size: 48,
                  color: RSColors.brandGreen,
                ),
              ),
              const SizedBox(height: RSSpacing.xl),
              Text(
                'You are connected!',
                style: RSText.headingH1.copyWith(color: RSColors.brandGreen),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.sm),
              Text(
                'Dr. Sara Khan has accepted your rehabilitation request. Any exercises tailored for you will appear directly under Prescribed.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xxl),
              RSButton.primary(
                'Go to home',
                () => context.go('/home'),
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.secondary(
                'See my doctor',
                () => context.push('/my-doctor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

