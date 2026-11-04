import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

// ---------------------------------------------------------------------------
// WelcomeScreen — Landing page for unauthenticated users.
// Uses LayoutBuilder + SingleChildScrollView so the layout fills large screens
// and scrolls gracefully on compact ones. No Spacer inside IntrinsicHeight.
// ---------------------------------------------------------------------------

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            // Determine if we need scroll (content taller than screen)
            // We always wrap in scroll for safety; ConstrainedBox ensures
            // it fills on large screens without requiring IntrinsicHeight.
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RSSpacing.screenH,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ── Top section: hero + features ─────────────────
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: RSSpacing.xl),
                          // Hero circle with activity icon
                          Center(
                            child: Container(
                              width: 112,
                              height: 112,
                              decoration: const BoxDecoration(
                                color: RSColors.brandMint,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                LucideIcons.activity,
                                size: 56,
                                color: RSColors.brandGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: RSSpacing.lg),
                          Text(
                            'Rehab, guided\nby your camera',
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
                        ],
                      ),

                      // ── Bottom section: disclaimer + CTAs ────────────
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: RSSpacing.xl),
                          // Canonical disclaimer — spec rule 3
                          Text(
                            'RehabSense is a guidance tool. It does not '
                            'diagnose or replace your physiotherapist.',
                            style: RSText.caption.copyWith(
                              color: RSColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: RSSpacing.md),
                          RSButton.primary(
                            'Get started',
                            () => context.push('/register'),
                          ),
                          const SizedBox(height: RSSpacing.sm),
                          RSButton.secondary(
                            'I already have an account',
                            () => context.push('/login'),
                          ),
                          const SizedBox(height: RSSpacing.xs),
                          // Portal links: Doctor · Staff
                          // Use Wrap so it never overflows on narrow screens
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => context.push('/doctor/login'),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: RSSpacing.sm,
                                    vertical: RSSpacing.xs,
                                  ),
                                  child: Text(
                                    'I am a Doctor',
                                    style: RSText.buttonMedium.copyWith(
                                      color: RSColors.brandAction,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '·',
                                style: TextStyle(
                                  color: RSColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/admin/login'),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: RSSpacing.sm,
                                    vertical: RSSpacing.xs,
                                  ),
                                  child: Text(
                                    'Staff login',
                                    style: RSText.buttonMedium.copyWith(
                                      color: RSColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: RSSpacing.md),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
