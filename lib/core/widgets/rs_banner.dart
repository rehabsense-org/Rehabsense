import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../tokens.dart';

enum RSBannerType { offline, syncPending, error, info }

class RSBanner extends StatelessWidget {
  final RSBannerType type;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const RSBanner({
    super.key,
    required this.type,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    switch (type) {
      case RSBannerType.offline:
        bg = RSColors.statusWarningTint;
        fg = RSColors.statusWarningInk;
        icon = LucideIcons.wifiOff;
        break;
      case RSBannerType.syncPending:
        bg = RSColors.brandMint;
        fg = RSColors.brandGreen;
        icon = LucideIcons.repeat;
        break;
      case RSBannerType.error:
        bg = RSColors.statusErrorTint;
        fg = RSColors.statusError;
        icon = LucideIcons.alertCircle;
        break;
      case RSBannerType.info:
        bg = RSColors.surfaceCeramic;
        fg = RSColors.textMutedGreen;
        icon = LucideIcons.info;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: bg,
      child: Row(
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: RSText.bodySmall.copyWith(color: fg),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: RSText.bodySmallStrong.copyWith(
                  color: fg,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
