import 'package:flutter/material.dart';
import '../tokens.dart';

// ---------------------------------------------------------------------------
// RSIconButton — icon button with visual / semantic separation.
// Variants: plain, soft, glass, filled, light.
// ---------------------------------------------------------------------------

enum RSIconButtonVariant { plain, soft, glass, filled, light }

class RSIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final RSIconButtonVariant variant;
  final double iconSize;
  final Color? overrideColor;

  const RSIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.variant = RSIconButtonVariant.plain,
    this.iconSize = 20,
    this.overrideColor,
  });

  const RSIconButton.plain({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.iconSize = 20,
    this.overrideColor,
  }) : variant = RSIconButtonVariant.plain;

  const RSIconButton.soft({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.iconSize = 20,
    this.overrideColor,
  }) : variant = RSIconButtonVariant.soft;

  const RSIconButton.glass({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.iconSize = 20,
    this.overrideColor,
  }) : variant = RSIconButtonVariant.glass;

  const RSIconButton.filled({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.iconSize = 20,
    this.overrideColor,
  }) : variant = RSIconButtonVariant.filled;

  const RSIconButton.light({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.iconSize = 20,
    this.overrideColor,
  }) : variant = RSIconButtonVariant.light;

  Color _bgColor() {
    switch (variant) {
      case RSIconButtonVariant.plain:
        return Colors.transparent;
      case RSIconButtonVariant.soft:
        return RSColors.surfaceCanvas;
      case RSIconButtonVariant.glass:
        return Colors.white.withOpacity(0.16);
      case RSIconButtonVariant.filled:
        return RSColors.brandAction;
      case RSIconButtonVariant.light:
        return RSColors.brandMint;
    }
  }

  Color _iconColor() {
    if (overrideColor != null) return overrideColor!;
    switch (variant) {
      case RSIconButtonVariant.plain:
      case RSIconButtonVariant.soft:
      case RSIconButtonVariant.light:
        return RSColors.textPrimary;
      case RSIconButtonVariant.glass:
        return RSColors.textOnDark;
      case RSIconButtonVariant.filled:
        return RSColors.textOnDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor();
    final fg = _iconColor();

    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: RSSizes.iconButtonHit,
            height: RSSizes.iconButtonHit,
            alignment: Alignment.center,
            child: Container(
              width: RSSizes.iconButton,
              height: RSSizes.iconButton,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: iconSize,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
