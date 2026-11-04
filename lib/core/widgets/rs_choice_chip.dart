import 'package:flutter/material.dart';
import '../tokens.dart';

class RSChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;
  final bool enabled;

  const RSChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled && onSelected != null ? () => onSelected!(!selected) : null,
        borderRadius: RSRadius.pillBR,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 40,
            minWidth: 48,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: RSSpacing.md,
            vertical: RSSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? RSColors.brandMint : RSColors.surfaceCard,
            borderRadius: RSRadius.pillBR,
            border: Border.all(
              color: selected ? RSColors.brandAction : RSColors.borderInput,
              width: selected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: selected ? RSColors.brandGreen : RSColors.textSecondary,
                ),
                const SizedBox(width: RSSpacing.xs),
              ],
              Text(
                label,
                style: RSText.bodySmallStrong.copyWith(
                  color: selected ? RSColors.brandGreen : RSColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

