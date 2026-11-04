import 'package:flutter/material.dart';
import '../tokens.dart';

class RSSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int divisions;
  final String? title;
  final String minLabel;
  final String maxLabel;
  final bool showValueCallout;

  const RSSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 10.0,
    this.divisions = 10,
    this.title,
    this.minLabel = '0 - No pain',
    this.maxLabel = '10 - Severe',
    this.showValueCallout = true,
  });

  @override
  Widget build(BuildContext context) {
    final intDisplay = value.round();
    final isSevere = intDisplay >= 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || showValueCallout) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: RSText.bodyStrong.copyWith(color: RSColors.textPrimary),
                ),
              if (showValueCallout)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: RSSpacing.sm + 2,
                    vertical: RSSpacing.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSevere ? RSColors.statusErrorTint : RSColors.brandMint,
                    borderRadius: RSRadius.pillBR,
                  ),
                  child: Text(
                    '$intDisplay / ${max.round()}',
                    style: RSText.captionStrong.copyWith(
                      color: isSevere ? RSColors.statusError : RSColors.brandGreen,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: RSSpacing.xs),
        ],
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: isSevere ? RSColors.statusError : RSColors.brandAction,
            inactiveTrackColor: RSColors.surfaceCeramic,
            thumbColor: isSevere ? RSColors.statusError : RSColors.brandAction,
            overlayColor: (isSevere ? RSColors.statusErrorTint : RSColors.brandMint)
                .withValues(alpha: 0.5),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              minLabel,
              style: RSText.caption.copyWith(color: RSColors.textSecondary),
            ),
            Text(
              maxLabel,
              style: RSText.caption.copyWith(
                color: isSevere ? RSColors.statusError : RSColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

