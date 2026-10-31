import 'package:flutter/material.dart';
import '../tokens.dart';

// ---------------------------------------------------------------------------
// RSButton — pill-shaped button with named constructors for every variant.
// ---------------------------------------------------------------------------

enum RSButtonSize { large, medium }

enum _RSButtonVariant {
  primary,
  secondary,
  dark,
  text,
  destructive,
  destructiveOutline,
  primaryOnDark,
  outlineOnDark,
}

class RSButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool disabled;
  final IconData? icon;
  final RSButtonSize size;
  final _RSButtonVariant _variant;

  // ── Primary ─────────────────────────────────────────────────────────────
  const RSButton.primary(
    this.label,
    this.onPressed, {
    super.key,
    this.loading = false,
    this.disabled = false,
    this.icon,
    this.size = RSButtonSize.large,
  }) : _variant = _RSButtonVariant.primary;

  // ── Secondary ───────────────────────────────────────────────────────────
  const RSButton.secondary(
    this.label,
    this.onPressed, {
    super.key,
    this.loading = false,
    this.disabled = false,
    this.icon,
    this.size = RSButtonSize.large,
  }) : _variant = _RSButtonVariant.secondary;

  // ── Dark ────────────────────────────────────────────────────────────────
  const RSButton.dark(
    this.label,
    this.onPressed, {
    super.key,
    this.loading = false,
    this.disabled = false,
    this.icon,
    this.size = RSButtonSize.large,
  }) : _variant = _RSButtonVariant.dark;

  // ── Text ────────────────────────────────────────────────────────────────
  const RSButton.text(
    this.label,
    this.onPressed, {
    super.key,
    this.loading = false,
    this.disabled = false,
    this.icon,
    this.size = RSButtonSize.large,
  }) : _variant = _RSButtonVariant.text;

  // ── Destructive ─────────────────────────────────────────────────────────
  const RSButton.destructive(
    this.label,
    this.onPressed, {
    super.key,
    this.loading = false,
    this.disabled = false,
    this.icon,
    this.size = RSButtonSize.large,
  }) : _variant = _RSButtonVariant.destructive;

  // ── Destructive Outline ─────────────────────────────────────────────────
  const RSButton.destructiveOutline(
    this.label,
    this.onPressed, {
    super.key,
    this.loading = false,
    this.disabled = false,
    this.icon,
    this.size = RSButtonSize.large,
  }) : _variant = _RSButtonVariant.destructiveOutline;

  // ── Primary on dark ────────────────────────────────────────────────────
  const RSButton.primaryOnDark(
    this.label,
    this.onPressed, {
    super.key,
    this.loading = false,
    this.disabled = false,
    this.icon,
    this.size = RSButtonSize.large,
  }) : _variant = _RSButtonVariant.primaryOnDark;

  // ── Outline on dark ───────────────────────────────────────────────────
  const RSButton.outlineOnDark(
    this.label,
    this.onPressed, {
    super.key,
    this.loading = false,
    this.disabled = false,
    this.icon,
    this.size = RSButtonSize.large,
  }) : _variant = _RSButtonVariant.outlineOnDark;

  // ── Helpers ─────────────────────────────────────────────────────────────

  double get _height =>
      size == RSButtonSize.large ? RSSizes.buttonLarge : RSSizes.buttonMedium;

  TextStyle get _textStyle =>
      size == RSButtonSize.large ? RSText.buttonLarge : RSText.buttonMedium;

  bool get _isInteractive => !disabled && !loading;

  Color _bg(BuildContext context) {
    switch (_variant) {
      case _RSButtonVariant.primary:
        return RSColors.brandAction;
      case _RSButtonVariant.secondary:
        return RSColors.surfaceCard;
      case _RSButtonVariant.dark:
        return RSColors.surfaceInk;
      case _RSButtonVariant.text:
        return Colors.transparent;
      case _RSButtonVariant.destructive:
        return RSColors.statusError;
      case _RSButtonVariant.destructiveOutline:
        return Colors.transparent;
      case _RSButtonVariant.primaryOnDark:
        return RSColors.surfaceCard;
      case _RSButtonVariant.outlineOnDark:
        return Colors.transparent;
    }
  }

  Color _fg(BuildContext context) {
    switch (_variant) {
      case _RSButtonVariant.primary:
      case _RSButtonVariant.dark:
      case _RSButtonVariant.destructive:
      case _RSButtonVariant.outlineOnDark:
        return RSColors.textOnDark;
      case _RSButtonVariant.secondary:
      case _RSButtonVariant.text:
        return RSColors.brandAction;
      case _RSButtonVariant.destructiveOutline:
        return RSColors.statusError;
      case _RSButtonVariant.primaryOnDark:
        return RSColors.brandDeep;
    }
  }

  BorderSide? get _border {
    switch (_variant) {
      case _RSButtonVariant.secondary:
        return const BorderSide(color: RSColors.brandAction, width: 1.5);
      case _RSButtonVariant.destructiveOutline:
        return const BorderSide(color: RSColors.statusError, width: 1.5);
      case _RSButtonVariant.outlineOnDark:
        return const BorderSide(color: RSColors.textOnDark, width: 1.5);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = disabled ? RSColors.surfaceCeramic : _bg(context);
    final fgColor = disabled ? RSColors.textSecondary : _fg(context);
    final border = disabled ? null : _border;

    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(bgColor),
      foregroundColor: WidgetStatePropertyAll(fgColor),
      overlayColor: WidgetStatePropertyAll(fgColor.withOpacity(0.08)),
      elevation: const WidgetStatePropertyAll(0),
      minimumSize: WidgetStatePropertyAll(Size(0, _height)),
      fixedSize: WidgetStatePropertyAll(Size.fromHeight(_height)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: RSSpacing.lg),
      ),
      shape: WidgetStatePropertyAll(
        StadiumBorder(side: border ?? BorderSide.none),
      ),
      textStyle: WidgetStatePropertyAll(_textStyle),
    );

    final child = _buildContent(fgColor);

    return ElevatedButton(
      onPressed: _isInteractive ? onPressed : null,
      style: buttonStyle,
      child: child,
    );
  }

  Widget _buildContent(Color fgColor) {
    if (loading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation(fgColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: RSSpacing.sm),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
