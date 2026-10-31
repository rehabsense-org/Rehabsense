import 'package:flutter/material.dart';
import '../tokens.dart';
import 'rs_button.dart';

class RSEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String? ctaLabel;
  final VoidCallback? onCtaPressed;

  const RSEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.ctaLabel,
    this.onCtaPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(RSSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: RSColors.brandMint,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: RSColors.brandGreen),
            ),
            const SizedBox(height: RSSpacing.md),
            Text(
              title,
              style: RSText.headingH3.copyWith(color: RSColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: RSSpacing.sm),
            Text(
              body,
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCtaPressed != null) ...[
              const SizedBox(height: RSSpacing.lg),
              RSButton.primary(
                ctaLabel!,
                onCtaPressed!,
                size: RSButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
