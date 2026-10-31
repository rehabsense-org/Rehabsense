import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class SyncErrorScreen extends StatelessWidget {
  final String exerciseId;

  const SyncErrorScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: const Text('Sync status'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: RSColors.statusWarningTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.wifiOff,
                    size: 36,
                    color: RSColors.statusWarningInk,
                  ),
                ),
              ),
              const SizedBox(height: RSSpacing.lg),
              Text(
                "You're offline",
                style: RSText.headingH1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Your session result is safely stored on this phone and will synchronize with your cloud account as soon as connectivity is restored.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              RSButton.primary(
                'Try again',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Retrying cloud sync...')),
                  );
                },
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.secondary(
                'Continue offline',
                () => context.go('/home'),
              ),
              const SizedBox(height: RSSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
