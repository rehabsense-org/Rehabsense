import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/auth_notifier.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'alex@rehab.test');
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

      if (auth.role == UserRole.doctor) {
        context.go('/doctor/home');
      } else if (auth.role == UserRole.admin) {
        context.go('/admin/dashboard');
      } else {
        context.go('/home');
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

  /// Demo bypass — sets mock patient state without Supabase.
  void _enterDemoMode() {
    AuthNotifier.instance.setMockState(
      role: UserRole.patient,
      status: AccountStatus.active,
    );
    context.go('/home');
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
              Text('Welcome back', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Log in to continue your rehabilitation programme.',
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
                  onPressed: () => context.push('/forgot-password'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 36),
                  ),
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
              const SizedBox(height: RSSpacing.lg),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or',
                        style: RSText.caption
                            .copyWith(color: RSColors.textSecondary)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: RSSpacing.lg),
              RSButton.secondary(
                'Create account',
                () => context.go('/register'),
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
                      'Enter as Patient (demo)',
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
