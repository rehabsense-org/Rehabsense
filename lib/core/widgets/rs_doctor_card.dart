import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../tokens.dart';
import 'rs_card.dart';

class RSDoctorCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final List<String> tags;
  final String? matchText;
  final String? initials;
  final VoidCallback? onTap;

  const RSDoctorCard({
    super.key,
    required this.name,
    required this.subtitle,
    this.tags = const [],
    this.matchText,
    this.initials,
    this.onTap,
  });

  String _computedInitials() {
    if (initials != null && initials!.isNotEmpty) return initials!;
    final clean = name.replaceAll('Dr.', '').trim();
    final parts = clean.split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return 'DR';
    if (parts.length == 1) return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return RSCard(
      onTap: onTap,
      padding: const EdgeInsets.all(RSSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: RSColors.brandMint,
            child: Text(
              _computedInitials(),
              style: RSText.headingH3.copyWith(color: RSColors.brandGreen),
            ),
          ),
          const SizedBox(width: RSSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: RSText.bodyStrong.copyWith(color: RSColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (matchText != null) ...[
                      const SizedBox(width: RSSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: RSSpacing.sm,
                          vertical: RSSpacing.xs / 2,
                        ),
                        decoration: BoxDecoration(
                          color: RSColors.brandMint,
                          borderRadius: RSRadius.pillBR,
                        ),
                        child: Text(
                          matchText!,
                          style: RSText.captionStrong.copyWith(color: RSColors.brandGreen),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: RSSpacing.xs),
                Text(
                  subtitle,
                  style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: RSSpacing.sm),
                  Wrap(
                    spacing: RSSpacing.xs,
                    runSpacing: RSSpacing.xs,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: RSSpacing.sm,
                          vertical: RSSpacing.xs / 2,
                        ),
                        decoration: BoxDecoration(
                          color: RSColors.surfaceCeramic,
                          borderRadius: RSRadius.pillBR,
                        ),
                        child: Text(
                          tag,
                          style: RSText.caption.copyWith(color: RSColors.textMutedGreen),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: RSSpacing.sm),
          Icon(
            LucideIcons.chevronRight,
            size: 20,
            color: RSColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

