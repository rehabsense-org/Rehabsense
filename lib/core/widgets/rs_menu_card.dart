import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../tokens.dart';
import 'rs_card.dart';

class RSMenuRowItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  const RSMenuRowItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.danger = false,
  });
}

class RSMenuCard extends StatelessWidget {
  final List<RSMenuRowItem> items;

  const RSMenuCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return RSCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _MenuRow(item: items[i]),
            if (i < items.length - 1)
              const Divider(
                indent: 56,
                endIndent: 16,
                height: 1,
                color: RSColors.borderHairline,
              ),
          ],
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final RSMenuRowItem item;

  const _MenuRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final fg = item.danger ? RSColors.statusError : RSColors.textPrimary;
    final iconBg = item.danger ? RSColors.statusErrorTint : RSColors.brandMint;
    final iconFg = item.danger ? RSColors.statusError : RSColors.brandGreen;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 20, color: iconFg),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: RSText.bodyStrong.copyWith(color: fg),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle!,
                        style: RSText.caption.copyWith(color: RSColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
              item.trailing ??
                  Icon(
                    LucideIcons.chevronRight,
                    size: 20,
                    color: RSColors.textSecondary,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
