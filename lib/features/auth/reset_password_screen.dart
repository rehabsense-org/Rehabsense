import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  bool get _has8Chars => _passwordController.text.length >= 8;
  bool get _hasLetter => RegExp(r'[a-zA-Z]').hasMatch(_passwordController.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _updatePassword() async {
    if (!_has8Chars || !_hasLetter || !_hasNumber) return;
    if (_passwordController.text != _confirmController.text) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password updated successfully. Please log in.')),
    );

    // Stack cleared per spec A 5.3
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.x,
          onPressed: () => context.go('/login'),
          semanticLabel: 'Close',
        ),
        title: const Text('New password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: RSSpacing.md),
              Text('Create new password', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Your new password must be different from previous passwords.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: RSSpacing.xl),
              RSInput(
                label: 'New password',
                controller: _passwordController,
                obscureText: _obscure,
                prefixIcon: LucideIcons.lock,
                suffixIcon: _obscure ? LucideIcons.eye : LucideIcons.eyeOff,
                onSuffixTap: () => setState(() => _obscure = !_obscure),
                hintText: 'Enter new password',
              ),
              const SizedBox(height: RSSpacing.sm),
              _ruleRow('At least 8 characters', _has8Chars),
              const SizedBox(height: 4),
              _ruleRow('At least 1 letter', _hasLetter),
              const SizedBox(height: 4),
              _ruleRow('At least 1 number', _hasNumber),
              const SizedBox(height: RSSpacing.md),
              RSInput(
                label: 'Confirm new password',
                controller: _confirmController,
                obscureText: _obscure,
                prefixIcon: LucideIcons.lock,
                hintText: 'Re-enter new password',
              ),
              const SizedBox(height: RSSpacing.xl),
              RSButton.primary(
                'Update password',
                _updatePassword,
                loading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ruleRow(String text, bool met) {
    return Row(
      children: [
        Icon(
          met ? LucideIcons.check : LucideIcons.circle,
          size: 14,
          color: met ? RSColors.statusSuccess : RSColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: RSText.caption.copyWith(
            color: met ? RSColors.statusSuccess : RSColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
