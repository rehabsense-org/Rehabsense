import 'package:flutter/material.dart';
import '../tokens.dart';

class RSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool flat;
  final Color? color;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Border? border;

  const RSCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(RSSpacing.md),
    this.flat = false,
    this.color,
    this.onTap,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? RSRadius.cardBR;
    final cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? RSColors.surfaceCard,
        borderRadius: br,
        border: border,
        boxShadow: flat ? null : RSShadows.card,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: br,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
