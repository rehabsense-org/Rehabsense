import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../app/auth_notifier.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorApplicationSubmittedScreen extends StatelessWidget {
  const DoctorApplicationSubmittedScreen({super.key});

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
                  LucideIcons.clock,
                  size: 48,
                  color: RSColors.brandGreen,
                ),
              ),
              const SizedBox(height: RSSpacing.xl),
              Text(
                'Application submitted',
                style: RSText.headingH1.copyWith(color: RSColors.brandGreen),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.sm),
              Text(
                'We will email you after reviewing your credentials. This usually takes 1 to 3 business days.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xl),
              const RSTimeline(
                items: [
                  RSTimelineItem(
                    title: 'Submitted',
                    subtitle: 'Today · Application received',
                    state: RSTimelineState.completed,
                  ),
                  RSTimelineItem(
                    title: 'Under review',
                    subtitle: 'Credentials validation in progress',
                    state: RSTimelineState.active,
                  ),
                  RSTimelineItem(
                    title: 'Decision by email',
                    subtitle: 'Activation upon approval',
                    state: RSTimelineState.pending,
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.xxl),
              RSButton.primary(
                'Back to welcome',
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
