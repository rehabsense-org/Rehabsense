import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class RequestStatusScreen extends StatelessWidget {
  const RequestStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'Request status',
          style: RSText.headingH3.copyWith(color: RSColors.brandGreen),
        ),
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.go('/home'),
          semanticLabel: 'Home',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: RSSpacing.sm),
              RSCard(
                padding: const EdgeInsets.all(RSSpacing.md),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: RSColors.brandMint,
                      child: Text('SK', style: TextStyle(color: RSColors.brandGreen, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: RSSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dr. Sara Khan', style: RSText.bodyStrong),
                          const SizedBox(height: 2),
                          Text(
                            'Sent today · Expires in 7 days',
                            style: RSText.caption.copyWith(color: RSColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const RSStatusChip(
                      type: RSStatusChipType.incomplete,
                      customLabel: 'Pending',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.xl),

              const RSTimeline(
                items: [
                  RSTimelineItem(
                    title: 'Request sent',
                    subtitle: 'Today · Condition summary shared with Dr. Khan',
                    state: RSTimelineState.completed,
                  ),
                  RSTimelineItem(
                    title: 'Doctor reviews',
                    subtitle: 'Usually reviewed within 2 business days',
                    state: RSTimelineState.active,
                  ),
                  RSTimelineItem(
                    title: 'Connected',
                    subtitle: 'You receive an alert and customized prescribed exercises',
                    state: RSTimelineState.pending,
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.xxl),

              RSButton.primary(
                'Back to home',
                () => context.go('/home'),
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.secondary(
                'Cancel request',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request cancelled.')),
                  );
                  context.go('/home');
                },
              ),

              const SizedBox(height: RSSpacing.xl),
              Center(
                child: Text('PROTOTYPE SHORTCUTS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
              ),
              const SizedBox(height: RSSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context.push('/connect/success'),
                    child: Text('Simulate Accepted', style: RSText.bodySmall.copyWith(color: RSColors.brandAction)),
                  ),
                  Text(' · ', style: TextStyle(color: RSColors.textSecondary)),
                  TextButton(
                    onPressed: () => context.push('/connect/declined'),
                    child: Text('Simulate Declined', style: RSText.bodySmall.copyWith(color: RSColors.statusError)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

