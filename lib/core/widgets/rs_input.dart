import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../tokens.dart';

// ---------------------------------------------------------------------------
// RSInput — text field with label, helper, error, prefix/suffix, password.
// ---------------------------------------------------------------------------

class RSInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final int? maxLength;
  final bool autofocus;

  const RSInput({
    super.key,
    this.label,
    this.hint,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
  });

  const RSInput.password({
    super.key,
    this.label,
    this.hint,
    this.hintText,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.autofocus = false,
  })  : obscureText = true,
        prefixIcon = null,
        suffixIcon = null,
        onSuffixTap = null,
        keyboardType = null,
        maxLines = 1,
        maxLength = null;

  @override
  State<RSInput> createState() => _RSInputState();
}

class _RSInputState extends State<RSInput> {
  late bool _obscured;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant RSInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscured = widget.obscureText;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  bool get _hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

  Color get _borderColor {
    if (!widget.enabled) return RSColors.borderInput.withOpacity(0.4);
    if (_hasError) return RSColors.statusError;
    if (_hasFocus) return RSColors.brandAction;
    return RSColors.borderInput;
  }

  String? get _resolvedHint => widget.hintText ?? widget.hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: RSText.bodySmallStrong.copyWith(color: RSColors.textPrimary),
          ),
          const SizedBox(height: RSSpacing.xs),
        ],

        // Field
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscured,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          autofocus: widget.autofocus,
          style: RSText.bodyDefault.copyWith(
            color: widget.enabled ? RSColors.textPrimary : RSColors.textSecondary,
          ),
          cursorColor: RSColors.brandAction,
          decoration: InputDecoration(
            hintText: _resolvedHint,
            hintStyle: RSText.bodyDefault.copyWith(
              color: RSColors.textSecondary,
            ),
            filled: true,
            fillColor: widget.enabled ? RSColors.surfaceCard : RSColors.surfaceCeramic,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: RSSpacing.md,
              vertical: 14,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20, color: RSColors.textSecondary)
                : null,
            suffixIcon: _buildSuffix(),
            border: _outlineBorder(RSColors.borderInput),
            enabledBorder: _outlineBorder(_borderColor),
            focusedBorder: _outlineBorder(
              _hasError ? RSColors.statusError : RSColors.brandAction,
              width: 1.5,
            ),
            errorBorder: _outlineBorder(RSColors.statusError),
            focusedErrorBorder: _outlineBorder(RSColors.statusError, width: 1.5),
            disabledBorder: _outlineBorder(RSColors.borderInput.withOpacity(0.4)),
            counterText: '',
          ),
        ),

        // Helper / Error
        if (_hasError) ...[
          const SizedBox(height: RSSpacing.xs),
          Row(
            children: [
              const Icon(LucideIcons.alertCircle, size: 14, color: RSColors.statusError),
              const SizedBox(width: RSSpacing.xs),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: RSText.caption.copyWith(color: RSColors.statusError),
                ),
              ),
            ],
          ),
        ] else if (widget.helperText != null) ...[
          const SizedBox(height: RSSpacing.xs),
          Text(
            widget.helperText!,
            style: RSText.caption.copyWith(color: RSColors.textSecondary),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.suffixIcon != null && widget.onSuffixTap != null) {
      return GestureDetector(
        onTap: widget.onSuffixTap,
        child: Icon(widget.suffixIcon, size: 20, color: RSColors.textSecondary),
      );
    }
    if (widget.obscureText) {
      return GestureDetector(
        onTap: () => setState(() => _obscured = !_obscured),
        child: Icon(
          _obscured ? LucideIcons.eyeOff : LucideIcons.eye,
          size: 20,
          color: RSColors.textSecondary,
        ),
      );
    }
    if (widget.suffixIcon != null) {
      return Icon(widget.suffixIcon, size: 20, color: RSColors.textSecondary);
    }
    return null;
  }

  OutlineInputBorder _outlineBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: RSRadius.inputBR,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
