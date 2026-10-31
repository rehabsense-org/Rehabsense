import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
    });
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
        title: const Text('Password recovery'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: _sent ? _buildSuccessState() : _buildFormState(),
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: RSSpacing.md),
        Text('Reset your password', style: RSText.headingH1),
        const SizedBox(height: RSSpacing.xs),
        Text(
          'Enter the email address associated with your account and we’ll send a link to reset your password.',
          style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.xl),
        RSInput(
          label: 'Email address',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: LucideIcons.mail,
          hintText: 'name@example.com',
        ),
        const SizedBox(height: RSSpacing.lg),
        RSButton.primary(
          'Send reset link',
          _sendLink,
          loading: _loading,
        ),
        const Spacer(),
        RSButton.text(
          'Back to log in',
          () => context.pop(),
        ),
        const SizedBox(height: RSSpacing.md),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: RSSpacing.xl),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: RSColors.brandMint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.checkCircle,
              size: 36,
              color: RSColors.brandGreen,
            ),
          ),
        ),
        const SizedBox(height: RSSpacing.lg),
        Text(
          'Check your email',
          style: RSText.headingH1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: RSSpacing.xs),
        Text(
          'We’ve sent password reset instructions to ${_emailController.text}.',
          style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: RSSpacing.xl),
        RSButton.primary(
          'Open email app',
          () {
            // Simulator: simulate clicking email reset link -> Screen 06
            context.push('/reset-password');
          },
        ),
        const SizedBox(height: RSSpacing.sm),
        RSButton.text(
          'Resend email',
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reset email resent.')),
            );
          },
        ),
        const Spacer(),
        RSButton.text(
          'Back to log in',
          () => context.go('/login'),
        ),
        const SizedBox(height: RSSpacing.md),
      ],
    );
  }
}
