import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../tokens.dart';

enum RSTimelineState { completed, active, pending }

class RSTimelineItem {
  final String title;
  final String subtitle;
  final RSTimelineState state;

  const RSTimelineItem({
    required this.title,
    required this.subtitle,
    this.state = RSTimelineState.pending,
  });
}

class RSTimeline extends StatelessWidget {
  final List<RSTimelineItem> items;

  const RSTimeline({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isLast = index == items.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  _buildNode(item.state),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: item.state == RSTimelineState.completed
                            ? RSColors.brandAction
                            : RSColors.borderHairline,
                        margin: const EdgeInsets.symmetric(vertical: RSSpacing.xs),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: RSSpacing.md),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : RSSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: RSText.bodyStrong.copyWith(
                          color: item.state == RSTimelineState.active
                              ? RSColors.brandGreen
                              : (item.state == RSTimelineState.completed
                                  ? RSColors.textPrimary
                                  : RSColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: RSSpacing.xs / 2),
                      Text(
                        item.subtitle,
                        style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNode(RSTimelineState state) {
    switch (state) {
      case RSTimelineState.completed:
        return Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: RSColors.brandAction,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.check,
            size: 14,
            color: RSColors.textOnDark,
          ),
        );
      case RSTimelineState.active:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: RSColors.brandMint,
            shape: BoxShape.circle,
            border: Border.all(color: RSColors.brandAction, width: 2),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: RSColors.brandAction,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      case RSTimelineState.pending:
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: RSColors.surfaceCard,
            shape: BoxShape.circle,
            border: Border.all(color: RSColors.borderInput, width: 2),
          ),
        );
    }
  }
}

