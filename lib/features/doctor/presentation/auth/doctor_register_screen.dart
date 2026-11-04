import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _clinicController = TextEditingController();
  final _licenseController = TextEditingController();

  String _selectedTitle = 'Physiotherapist';
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _clinicController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    final clinic = _clinicController.text.trim();
    final license = _licenseController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || clinic.isEmpty || license.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all required fields.');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }

    if (password.length < 8) {
      setState(() => _errorMessage = 'Password must be at least 8 characters long.');
      return;
    }

    if (password != confirm) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }

    setState(() => _errorMessage = null);
    // Proceed to OTP Verification (D-03)
    context.push('/doctor/verify-email', extra: {
      'email': email,
      'name': name,
      'clinic': clinic,
      'license': license,
      'title': _selectedTitle,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/welcome');
            }
          },
          semanticLabel: 'Back',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: RSSpacing.md),
              Text('Doctor Registration', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Join RehabSense to guide, assign exercises and monitor patient recovery.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: RSSpacing.lg),

              if (_errorMessage != null) ...[
                RSBanner(
                  type: RSBannerType.error,
                  message: _errorMessage!,
                ),
                const SizedBox(height: RSSpacing.md),
              ],

              RSInput(
                label: 'Full Name *',
                hintText: 'e.g. Dr. Sara Khan',
                controller: _nameController,
                prefixIcon: LucideIcons.user,
              ),
              const SizedBox(height: RSSpacing.md),

              RSInput(
                label: 'Work Email *',
                hintText: 'e.g. sara.khan@rehabclinic.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: LucideIcons.mail,
              ),
              const SizedBox(height: RSSpacing.md),

              RSInput(
                label: 'Password *',
                hintText: 'At least 8 characters',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: LucideIcons.lock,
                suffixIcon: _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: RSSpacing.md),

              RSInput(
                label: 'Confirm Password *',
                hintText: 'Re-enter your password',
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
                prefixIcon: LucideIcons.lock,
              ),
              const SizedBox(height: RSSpacing.md),

              Text('Professional Title *', style: RSText.bodySmallStrong),
              const SizedBox(height: RSSpacing.xs),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Physiotherapist',
                  'Orthopedic Doctor',
                  'Rehab Specialist',
                ].map((title) {
                  return RSChoiceChip(
                    label: title,
                    selected: _selectedTitle == title,
                    onSelected: (sel) {
                      if (sel) setState(() => _selectedTitle = title);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: RSSpacing.md),

              RSInput(
                label: 'Phone Number',
                hintText: '+1 234 567 8900',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: LucideIcons.phone,
              ),
              const SizedBox(height: RSSpacing.md),

              RSInput(
                label: 'Clinic / Hospital Name *',
                hintText: 'e.g. Apex Physical Therapy Centre',
                controller: _clinicController,
                prefixIcon: LucideIcons.building,
              ),
              const SizedBox(height: RSSpacing.md),

              RSInput(
                label: 'Medical / PT License Number *',
                hintText: 'e.g. PT-98231-NY',
                controller: _licenseController,
                prefixIcon: LucideIcons.award,
              ),
              const SizedBox(height: RSSpacing.xl),

              RSButton.primary(
                'Continue to verification',
                _onContinue,
              ),
              const SizedBox(height: RSSpacing.md),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: RSText.bodySmall),
                  GestureDetector(
                    onTap: () => context.go('/doctor/login'),
                    child: Text(
                      'Log in',
                      style: RSText.bodySmallStrong.copyWith(color: RSColors.brandAction),
                    ),
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
}
