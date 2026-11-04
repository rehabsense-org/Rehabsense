import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../tokens.dart';
import 'rs_card.dart';

class RSDocumentTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isUploaded;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const RSDocumentTile({
    super.key,
    required this.title,
    this.subtitle,
    this.isUploaded = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RSCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: RSSpacing.md,
        vertical: RSSpacing.sm + 4,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUploaded ? RSColors.brandMint : RSColors.surfaceCeramic,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.fileText,
              size: 20,
              color: isUploaded ? RSColors.brandGreen : RSColors.textSecondary,
            ),
          ),
          const SizedBox(width: RSSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: RSText.bodyStrong.copyWith(color: RSColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: RSSpacing.xs / 2),
                Text(
                  subtitle ?? (isUploaded ? 'Uploaded' : 'Tap to upload'),
                  style: RSText.caption.copyWith(
                    color: isUploaded ? RSColors.textSecondary : RSColors.brandAction,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: RSSpacing.sm),
          if (isUploaded && onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                LucideIcons.trash2,
                size: 20,
                color: RSColors.statusError,
              ),
              splashRadius: 24,
            )
          else if (isUploaded)
            Icon(
              LucideIcons.checkCircle2,
              size: 20,
              color: RSColors.statusSuccess,
            )
          else
            Icon(
              LucideIcons.upload,
              size: 20,
              color: RSColors.brandAction,
            ),
        ],
      ),
    );
  }
}

