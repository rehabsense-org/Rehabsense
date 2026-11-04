import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminForgotPasswordScreen extends StatefulWidget {
  const AdminForgotPasswordScreen({super.key});

  @override
  State<AdminForgotPasswordScreen> createState() => _AdminForgotPasswordScreenState();
}

class _AdminForgotPasswordScreenState extends State<AdminForgotPasswordScreen> {
  final _emailController = TextEditingController(text: 'admin@rehabsense.test');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendReset() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset link sent to admin email.')),
    );
    context.push('/admin/reset-password');
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
              Text('Forgot password?', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'We will send a reset link to your staff email.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: RSSpacing.xl),
              RSInput(
                label: 'Staff Email',
                prefixIcon: LucideIcons.mail,
                controller: _emailController,
              ),
              const SizedBox(height: RSSpacing.xl),
              RSButton.primary(
                'Send reset link',
                _sendReset,
              ),
              const SizedBox(height: RSSpacing.md),
              RSButton.text(
                'Back to login',
                () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

