import 'package:flutter/material.dart';
import '../tokens.dart';

class RSStepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String? title;
  final String? subtitle;

  const RSStepHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STEP $currentStep OF $totalSteps',
              style: RSText.labelOverline.copyWith(color: RSColors.brandAction),
            ),
            if (title != null)
              Text(
                title!,
                style: RSText.captionStrong.copyWith(color: RSColors.textSecondary),
              ),
          ],
        ),
        const SizedBox(height: RSSpacing.sm),
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isFirst = index == 0;
            final isLast = index == totalSteps - 1;

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: isFirst ? 0 : RSSpacing.xs / 2,
                  right: isLast ? 0 : RSSpacing.xs / 2,
                ),
                height: 4,
                decoration: BoxDecoration(
                  color: isCompleted ? RSColors.brandAction : RSColors.borderHairline,
                  borderRadius: RSRadius.pillBR,
                ),
              ),
            );
          }),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: RSSpacing.sm),
          Text(
            subtitle!,
            style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
          ),
        ],
      ],
    );
  }
}

