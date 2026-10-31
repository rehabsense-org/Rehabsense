import 'package:flutter/material.dart';
import '../tokens.dart';
import 'rs_button.dart';

class RSDialog extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color? iconBgColor;
  final String title;
  final String body;
  final Widget? content;
  final String primaryButtonLabel;
  final VoidCallback? onPrimaryPressed;
  final bool primaryIsDestructive;
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryPressed;
  final bool isSecondaryDestructive;

  const RSDialog({
    super.key,
    required this.icon,
    this.iconColor,
    this.iconBgColor,
    required this.title,
    required this.body,
    this.content,
    required this.primaryButtonLabel,
    this.onPrimaryPressed,
    this.primaryIsDestructive = false,
    this.secondaryButtonLabel,
    this.onSecondaryPressed,
    this.isSecondaryDestructive = false,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required IconData icon,
    Color? iconColor,
    Color? iconBgColor,
    required String title,
    required String body,
    Widget? content,
    required String primaryButtonLabel,
    VoidCallback? onPrimaryPressed,
    bool primaryIsDestructive = false,
    String? secondaryButtonLabel,
    VoidCallback? onSecondaryPressed,
    bool isSecondaryDestructive = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: RSColors.overlayScrim,
      builder: (context) => RSDialog(
        icon: icon,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
        title: title,
        body: body,
        content: content,
        primaryButtonLabel: primaryButtonLabel,
        onPrimaryPressed: onPrimaryPressed,
        primaryIsDestructive: primaryIsDestructive,
        secondaryButtonLabel: secondaryButtonLabel,
        onSecondaryPressed: onSecondaryPressed,
        isSecondaryDestructive: isSecondaryDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final iBg = iconBgColor ??
        (primaryIsDestructive
            ? RSColors.statusErrorTint
            : RSColors.brandMint);
    final iFg = iconColor ??
        (primaryIsDestructive
            ? RSColors.statusError
            : RSColors.brandGreen);

    return Dialog(
      backgroundColor: RSColors.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: RSRadius.sheetBR),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(RSSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: iFg),
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
            if (content != null) ...[
              const SizedBox(height: RSSpacing.md),
              content!,
            ],
            const SizedBox(height: RSSpacing.lg),
            if (primaryIsDestructive)
              RSButton.destructive(
                primaryButtonLabel,
                () {
                  Navigator.of(context).pop();
                  onPrimaryPressed?.call();
                },
              )
            else
              RSButton.primary(
                primaryButtonLabel,
                () {
                  Navigator.of(context).pop();
                  onPrimaryPressed?.call();
                },
              ),
            if (secondaryButtonLabel != null) ...[
              const SizedBox(height: RSSpacing.sm),
              if (isSecondaryDestructive)
                RSButton.destructiveOutline(
                  secondaryButtonLabel!,
                  () {
                    Navigator.of(context).pop();
                    onSecondaryPressed?.call();
                  },
                )
              else
                RSButton.text(
                  secondaryButtonLabel!,
                  () {
                    Navigator.of(context).pop();
                    onSecondaryPressed?.call();
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}
