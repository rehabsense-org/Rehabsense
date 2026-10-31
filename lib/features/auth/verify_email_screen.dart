import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String? email;

  const VerifyEmailScreen({super.key, this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _verifying = false;
  String? _warningMessage;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _checkVerification() async {
    setState(() {
      _verifying = true;
      _warningMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _verifying = false);

    // Navigate to Step 1 of Profile Setup (07)
    context.go('/setup/profile');
  }

  @override
  Widget build(BuildContext context) {
    final displayEmail = widget.email ?? 'alex@rehab.test';

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
              const SizedBox(height: RSSpacing.xl),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: RSColors.brandMint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.mail,
                    size: 40,
                    color: RSColors.brandGreen,
                  ),
                ),
              ),
              const SizedBox(height: RSSpacing.lg),
              Text(
                'Check your inbox',
                style: RSText.headingH1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.sm),
              Text(
                'We sent a verification link to:\n$displayEmail',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xl),

              if (_warningMessage != null) ...[
                RSBanner(
                  type: RSBannerType.error,
                  message: _warningMessage!,
                ),
                const SizedBox(height: RSSpacing.md),
              ],

              RSButton.primary(
                "I've verified my email",
                _checkVerification,
                loading: _verifying,
              ),
              const SizedBox(height: RSSpacing.md),
              RSButton.text(
                _secondsRemaining > 0
                    ? 'Resend email (${_secondsRemaining}s)'
                    : 'Resend email',
                _secondsRemaining > 0
                    ? null
                    : () {
                        _startCountdown();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Verification link resent.')),
                        );
                      },
                disabled: _secondsRemaining > 0,
              ),
              const Spacer(),
              RSButton.text(
                'Change email address',
                () => context.pop(),
              ),
              const SizedBox(height: RSSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
