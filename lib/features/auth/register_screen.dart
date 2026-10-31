import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _loading = false;
  String? _errorMessage;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pwd = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || email.isEmpty) {
      setState(() => _errorMessage = 'Please complete all required fields.');
      return;
    }
    if (!_has8Chars || !_hasLetter || !_hasNumber) {
      setState(() => _errorMessage = 'Please meet all password requirements.');
      return;
    }
    if (pwd != confirm) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }
    if (!_agreedToTerms) {
      setState(() => _errorMessage = 'You must agree to the Terms and Privacy Policy.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _loading = false);

    // Proceed to email verification (31)
    context.push('/verify-email', extra: email);
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
        title: const Text('Create account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: RSSpacing.md),
              Text('Get started with RehabSense', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Personalized movement guidance powered by your camera.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: RSSpacing.lg),

              if (_errorMessage != null) ...[
                RSBanner(type: RSBannerType.error, message: _errorMessage!),
                const SizedBox(height: RSSpacing.md),
              ],

              RSInput(
                label: 'Full name',
                controller: _nameController,
                prefixIcon: LucideIcons.user,
                hintText: 'Jane Doe',
              ),
              const SizedBox(height: RSSpacing.md),
              RSInput(
                label: 'Email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: LucideIcons.mail,
                hintText: 'name@example.com',
              ),
              const SizedBox(height: RSSpacing.md),
              RSInput(
                label: 'Password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: LucideIcons.lock,
                suffixIcon: _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
                hintText: 'Create a password',
              ),
              const SizedBox(height: RSSpacing.sm),
              // Live password rules checklist
              _ruleRow('At least 8 characters', _has8Chars),
              const SizedBox(height: 4),
              _ruleRow('At least 1 letter', _hasLetter),
              const SizedBox(height: 4),
              _ruleRow('At least 1 number', _hasNumber),
              const SizedBox(height: RSSpacing.md),
              RSInput(
                label: 'Confirm password',
                controller: _confirmController,
                obscureText: _obscurePassword,
                prefixIcon: LucideIcons.lock,
                hintText: 'Re-enter your password',
              ),
              const SizedBox(height: RSSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'I agree to the Terms of Service and Privacy Policy.',
                        style: RSText.bodySmall.copyWith(color: RSColors.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.lg),
              RSButton.primary(
                'Create account',
                _register,
                loading: _loading,
              ),
              const SizedBox(height: RSSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?', style: RSText.bodySmall.copyWith(color: RSColors.textSecondary)),
                  TextButton(
                    onPressed: () => context.push('/login'),
                    style: TextButton.styleFrom(minimumSize: const Size(60, 36)),
                    child: Text('Log in', style: RSText.bodySmallStrong.copyWith(color: RSColors.brandAction)),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.xl),
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
