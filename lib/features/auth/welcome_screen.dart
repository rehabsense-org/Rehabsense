import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              // Hero illustration circle
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: RSColors.brandMint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.activity,
                    size: 60,
                    color: RSColors.brandGreen,
                  ),
                ),
              ),
              const SizedBox(height: RSSpacing.xl),
              Text(
                'Rehab, guided by your camera',
                style: RSText.headingH1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.lg),
              _buildBullet(
                icon: LucideIcons.checkCircle,
                text: 'Real-time rep counting and instant feedback',
              ),
              const SizedBox(height: RSSpacing.md),
              _buildBullet(
                icon: LucideIcons.trendingUp,
                text: 'Progress you can see over time',
              ),
              const SizedBox(height: RSSpacing.md),
              _buildBullet(
                icon: LucideIcons.shieldCheck,
                text: 'Private: no video or photo is ever stored',
              ),
              const Spacer(flex: 2),
              // Canonical disclaimer per spec rule 3
              Text(
                'RehabSense is a guidance tool. It does not diagnose or replace your physiotherapist.',
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.lg),
              RSButton.primary(
                'Get started',
                () => context.push('/register'),
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.secondary(
                'I already have an account',
                () => context.push('/login'),
              ),
              const SizedBox(height: RSSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBullet({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: RSColors.surfaceCard,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: RSColors.brandAction),
        ),
        const SizedBox(width: RSSpacing.md),
        Expanded(
          child: Text(
            text,
            style: RSText.bodyDefault.copyWith(color: RSColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
