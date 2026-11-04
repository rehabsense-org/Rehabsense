import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorResetPasswordScreen extends StatefulWidget {
  const DoctorResetPasswordScreen({super.key});

  @override
  State<DoctorResetPasswordScreen> createState() => _DoctorResetPasswordScreenState();
}

class _DoctorResetPasswordScreenState extends State<DoctorResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onResetPassword() async {
    final pwd = _passwordController.text;
    final confirm = _confirmController.text;

    if (pwd.length < 8) {
      setState(() => _errorMessage = 'Password must be at least 8 characters long.');
      return;
    }

    if (pwd != confirm) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    context.go('/doctor/login');
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

              if (_errorMessage != null) ...[
                RSBanner(
                  type: RSBannerType.error,
                  message: _errorMessage!,
                ),
                const SizedBox(height: RSSpacing.md),
              ],

              RSInput(
                label: 'New password',
                hintText: 'At least 8 characters',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: LucideIcons.lock,
                suffixIcon: _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: RSSpacing.md),

              RSInput(
                label: 'Confirm new password',
                hintText: 'Re-enter your password',
                controller: _confirmController,
                obscureText: _obscurePassword,
                prefixIcon: LucideIcons.lock,
              ),
              const SizedBox(height: RSSpacing.xl),

              RSButton.primary(
                'Save new password',
                _onResetPassword,
                loading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
