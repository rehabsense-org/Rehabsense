import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/auth_notifier.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/repositories/repositories.dart';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  final _emailController = TextEditingController(text: 'sara.khan@clinic.test');
  final _passwordController = TextEditingController(text: 'Password123');
  bool _obscurePassword = true;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailController.text.trim();
    final pwd = _passwordController.text;

    if (email.isEmpty || pwd.isEmpty) {
      setState(() => _errorMessage = 'Please enter both email and password.');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await AuthRepository().login(email, pwd);
      await AuthNotifier.instance.initialize();

      if (!mounted) return;

      final auth = AuthNotifier.instance;
      if (auth.isAccountDisabled) {
        context.go('/account-inactive');
        return;
      }

      if (auth.role != UserRole.doctor) {
        setState(() => _errorMessage =
            'This portal is for doctors only. Please use the patient app.');
        return;
      }

      if (auth.accountStatus == AccountStatus.pendingVerification) {
        context.go('/doctor/application-status');
      } else {
        context.go('/doctor/home');
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Unable to connect. Use demo mode below.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Demo bypass — sets mock doctor state without Supabase, for UI prototyping.
  void _enterDemoMode() {
    AuthNotifier.instance.setMockState(
      role: UserRole.doctor,
      status: AccountStatus.active,
    );
    context.go('/doctor/home');
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
              Text('Doctor login', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Sign in to manage your patients and prescriptions.',
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
                label: 'Work email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: LucideIcons.mail,
                hintText: 'doctor@clinic.com',
              ),
              const SizedBox(height: RSSpacing.md),
              RSInput(
                label: 'Password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: LucideIcons.lock,
                suffixIcon:
                    _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                onSuffixTap: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                hintText: 'Enter your password',
              ),
              const SizedBox(height: RSSpacing.xs),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/doctor/forgot-password'),
                  child: Text(
                    'Forgot password?',
                    style: RSText.bodySmallStrong
                        .copyWith(color: RSColors.brandAction),
                  ),
                ),
              ),
              const SizedBox(height: RSSpacing.lg),
              RSButton.primary(
                'Log in',
                _login,
                loading: _loading,
              ),
              const SizedBox(height: RSSpacing.md),
              RSButton.secondary(
                'Create doctor account',
                () => context.go('/doctor/register'),
              ),
              const SizedBox(height: RSSpacing.lg),
              // ── Demo Mode ─────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: RSColors.statusWarningTint,
                  borderRadius: BorderRadius.circular(RSRadius.card),
                  border: Border.all(color: RSColors.statusWarning, width: 1),
                ),
                padding: const EdgeInsets.all(RSSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.flaskConical,
                            size: 16, color: RSColors.statusWarningInk),
                        const SizedBox(width: RSSpacing.xs),
                        Text(
                          'Demo mode — no Supabase needed',
                          style: RSText.captionStrong.copyWith(
                            color: RSColors.statusWarningInk,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: RSSpacing.sm),
                    RSButton.primary(
                      'Enter as Doctor (demo)',
                      _enterDemoMode,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
