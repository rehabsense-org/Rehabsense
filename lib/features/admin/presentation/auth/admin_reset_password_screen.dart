import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminResetPasswordScreen extends StatefulWidget {
  const AdminResetPasswordScreen({super.key});

  @override
  State<AdminResetPasswordScreen> createState() => _AdminResetPasswordScreenState();
}

class _AdminResetPasswordScreenState extends State<AdminResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password updated successfully. Please log in.')),
    );
    context.go('/admin/login');
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Create new password', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Enter your new staff security password below.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: RSSpacing.xl),
              RSInput(
                label: 'New password',
                prefixIcon: LucideIcons.lock,
                suffixIcon: _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
                obscureText: _obscurePassword,
                controller: _newPasswordController,
              ),
              const SizedBox(height: RSSpacing.md),
              RSInput(
                label: 'Confirm password',
                prefixIcon: LucideIcons.lock,
                obscureText: _obscurePassword,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: RSSpacing.xl),
              RSButton.primary(
                'Update password',
                _updatePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

