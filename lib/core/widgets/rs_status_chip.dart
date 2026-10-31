import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/models/models.dart';
import '../tokens.dart';

enum RSStatusChipType { correct, incorrect, incomplete, info }

class RSStatusChip extends StatelessWidget {
  final RSStatusChipType type;
  final String? customLabel;
  final bool compact;

  const RSStatusChip({
    super.key,
    required this.type,
    this.customLabel,
    this.compact = false,
  });

  factory RSStatusChip.fromOutcome(RepOutcome outcome, {bool compact = false}) {
    switch (outcome) {
      case RepOutcome.correct:
        return RSStatusChip(type: RSStatusChipType.correct, compact: compact);
      case RepOutcome.incorrect:
        return RSStatusChip(type: RSStatusChipType.incorrect, compact: compact);
      case RepOutcome.incomplete:
        return RSStatusChip(type: RSStatusChipType.incomplete, compact: compact);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (type) {
      case RSStatusChipType.correct:
        bg = RSColors.statusSuccessTint;
        fg = RSColors.statusSuccess;
        icon = LucideIcons.checkCircle;
        label = customLabel ?? 'Correct';
        break;
      case RSStatusChipType.incorrect:
        bg = RSColors.statusErrorTint;
        fg = RSColors.statusError;
        icon = LucideIcons.xCircle;
        label = customLabel ?? 'Incorrect';
        break;
      case RSStatusChipType.incomplete:
        bg = RSColors.statusWarningTint;
        fg = RSColors.statusWarningInk;
        icon = LucideIcons.minusCircle;
        label = customLabel ?? 'Incomplete';
        break;
      case RSStatusChipType.info:
        bg = RSColors.surfaceCeramic;
        fg = RSColors.textSecondary;
        icon = LucideIcons.info;
        label = customLabel ?? 'Info';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(RSRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 14 : 16, color: fg),
          SizedBox(width: compact ? 4 : 6),
          Text(
            label,
            style: (compact ? RSText.captionStrong : RSText.bodySmallStrong)
                .copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
