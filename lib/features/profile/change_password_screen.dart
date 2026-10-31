import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  bool get _has8Chars => _newController.text.length >= 8;
  bool get _hasLetter => RegExp(r'[a-zA-Z]').hasMatch(_newController.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_newController.text);

  @override
  void initState() {
    super.initState();
    _newController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_currentController.text.isEmpty) return;
    if (!_has8Chars || !_hasLetter || !_hasNumber) return;
    if (_newController.text != _confirmController.text) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password updated successfully.')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: const Text('Change password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RSInput(
                label: 'Current password',
                controller: _currentController,
                obscureText: true,
                prefixIcon: LucideIcons.lock,
                hintText: 'Enter current password',
              ),
              const SizedBox(height: RSSpacing.md),
              RSInput(
                label: 'New password',
                controller: _newController,
                obscureText: true,
                prefixIcon: LucideIcons.lock,
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
                obscureText: true,
                prefixIcon: LucideIcons.lock,
                hintText: 'Re-enter new password',
              ),
              const SizedBox(height: RSSpacing.xl),
              RSButton.primary(
                'Update password',
                _submit,
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
