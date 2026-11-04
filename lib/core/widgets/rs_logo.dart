import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../tokens.dart';

enum RSLogoVariant { mark, lockup }

class RSLogo extends StatelessWidget {
  final RSLogoVariant variant;
  final bool onDark;
  final double size;

  const RSLogo({
    super.key,
    this.variant = RSLogoVariant.lockup,
    this.onDark = false,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final markColor = onDark ? RSColors.brandMint : RSColors.brandAction;
    final textColor = onDark ? RSColors.textOnDark : RSColors.brandGreen;

    final markWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.24),
        boxShadow: onDark
            ? [
                BoxShadow(
                  color: RSColors.brandMint.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.24),
        child: Image.asset(
          'assets/images/app_logo.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: onDark
                    ? RSColors.brandMint.withValues(alpha: 0.2)
                    : RSColors.brandMint,
                borderRadius: BorderRadius.circular(size * 0.24),
              ),
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.activity,
                size: size * 0.55,
                color: markColor,
              ),
            );
          },
        ),
      ),
    );

    if (variant == RSLogoVariant.mark) {
      return markWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        markWidget,
        const SizedBox(width: 12),
        Text(
          'RehabSense',
          style: RSText.displayMedium.copyWith(
            color: textColor,
            fontSize: size * 0.7,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
