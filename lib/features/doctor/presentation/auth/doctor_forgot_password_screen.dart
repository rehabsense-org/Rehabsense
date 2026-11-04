import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorForgotPasswordScreen extends StatefulWidget {
  const DoctorForgotPasswordScreen({super.key});

  @override
  State<DoctorForgotPasswordScreen> createState() => _DoctorForgotPasswordScreenState();
}

class _DoctorForgotPasswordScreenState extends State<DoctorForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid work email.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: RSSpacing.md),
              Text('Reset Doctor Password', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Enter your verified work email address to receive password reset instructions.',
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

              if (_sent) ...[
                RSBanner(
                  type: RSBannerType.info,
                  message: 'Instructions have been sent to your email. Please check your inbox.',
                ),
                const SizedBox(height: RSSpacing.lg),
                RSButton.primary(
                  'Set new password',
                  () => context.push('/doctor/reset-password'),
                ),
                const SizedBox(height: RSSpacing.sm),
                RSButton.secondary(
                  'Back to login',
                  () => context.pushReplacement('/doctor/login'),
                ),
              ] else ...[
                RSInput(
                  label: 'Work email',
                  hintText: 'e.g. sara.khan@rehabclinic.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: LucideIcons.mail,
                ),
                const SizedBox(height: RSSpacing.xl),
                RSButton.primary(
                  'Send reset link',
                  _onSendReset,
                  loading: _loading,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

