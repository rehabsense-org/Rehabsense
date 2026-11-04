import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../app/auth_notifier.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/repositories/repositories.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController(text: 'admin@rehabsense.test');
  final _passwordController = TextEditingController(text: 'AdminPass123');
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
      setState(() => _errorMessage = 'Please enter staff credentials.');
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

      if (auth.role != UserRole.admin) {
        setState(() => _errorMessage = 'This portal is restricted to staff administrators.');
        return;
      }

      context.go('/admin/dashboard');
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

  /// Demo bypass — sets mock admin state without Supabase, for UI prototyping.
  void _enterDemoMode() {
    AuthNotifier.instance.setMockState(
      role: UserRole.admin,
      status: AccountStatus.active,
    );
    context.go('/admin/dashboard');
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
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: RSColors.brandMint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.shield,
                    size: 36,
                    color: RSColors.brandGreen,
                  ),
                ),
              ),
              const SizedBox(height: RSSpacing.lg),
              Text(
                'Staff login',
                style: RSText.headingH1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Admin accounts are provisioned by the operations team.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
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
                label: 'Staff email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: LucideIcons.mail,
                hintText: 'admin@rehabsense.com',
              ),
              const SizedBox(height: RSSpacing.md),
              RSInput(
                label: 'Password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: LucideIcons.lock,
                suffixIcon: _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                onSuffixTap: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
                hintText: 'Enter admin password',
              ),
              const SizedBox(height: RSSpacing.xs),
              Align(
                alignment: Alignment.centerRight,
                child: RSButton.text(
                  'Forgot password?',
                  () => context.push('/admin/forgot-password'),
                ),
              ),
              const SizedBox(height: RSSpacing.md),
              RSButton.primary(
                'Log in to Console',
                _login,
                loading: _loading,
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.text(
                'Prototype: wrong portal (not an admin)',
                () => context.push('/admin/blocked'),
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
                      'Enter as Admin (demo)',
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

