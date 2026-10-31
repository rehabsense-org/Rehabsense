import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class SavedScreen extends StatelessWidget {
  final String exerciseId;

  const SavedScreen({super.key, required this.exerciseId});

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
              const Spacer(),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: RSColors.brandMint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.checkCircle2,
                    size: 44,
                    color: RSColors.brandGreen,
                  ),
                ),
              ),
              const SizedBox(height: RSSpacing.lg),
              Text(
                'Result saved',
                style: RSText.headingH1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Saved on this phone. Syncs automatically when online.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xl),

              // Milestone card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: RSColors.accentGoldWash,
                  borderRadius: RSRadius.cardBR,
                  border: Border.all(color: RSColors.accentGold),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.award, color: RSColors.accentGoldDeep, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personal Best!', style: RSText.bodyStrong.copyWith(color: RSColors.accentGoldDeep)),
                          Text('Movement score of 86', style: RSText.caption.copyWith(color: RSColors.accentGoldDeep)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              RSButton.primary(
                'Back to home',
                () => context.go('/home'),
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.secondary(
                'View progress',
                () => context.go('/progress'),
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.text(
                'View this session',
                () => context.push('/progress/session/sess_001'),
              ),
              const SizedBox(height: RSSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
