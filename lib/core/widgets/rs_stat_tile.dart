import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../tokens.dart';
import 'rs_card.dart';

class RSStatTile extends StatelessWidget {
  final String label;
  final String value;
  final String? delta;
  final bool? deltaPositive; // true = up, false = down, null = neutral
  final Color? valueColor;

  const RSStatTile({
    super.key,
    required this.label,
    required this.value,
    this.delta,
    this.deltaPositive,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return RSCard(
      padding: const EdgeInsets.all(RSSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: RSText.labelOverline.copyWith(color: RSColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: RSText.displayMedium.copyWith(
              color: valueColor ?? RSColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (delta != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                if (deltaPositive != null)
                  Icon(
                    deltaPositive!
                        ? LucideIcons.trendingUp
                        : LucideIcons.trendingDown,
                    size: 14,
                    color: deltaPositive!
                        ? RSColors.statusSuccess
                        : RSColors.statusError,
                  ),
                if (deltaPositive != null) const SizedBox(width: 4),
                Text(
                  delta!,
                  style: RSText.caption.copyWith(
                    color: deltaPositive == null
                        ? RSColors.textSecondary
                        : (deltaPositive!
                            ? RSColors.statusSuccess
                            : RSColors.statusError),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
