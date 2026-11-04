import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorOtpScreen extends StatefulWidget {
  final String email;

  const DoctorOtpScreen({super.key, this.email = 'doctor@clinic.com'});

  @override
  State<DoctorOtpScreen> createState() => _DoctorOtpScreenState();
}

class _DoctorOtpScreenState extends State<DoctorOtpScreen> {
  String _code = '';
  bool _hasError = false;
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onVerify() {
    if (_code.length != 6) {
      setState(() => _hasError = true);
      return;
    }

    setState(() => _hasError = false);
    // Proceed to Step 2: Upload Documents (D-04)
    context.push('/doctor/onboarding/documents');
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
              Text('Verify your email', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'We sent a 6-digit verification code to:\n${widget.email}',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: RSSpacing.xl),

              Center(
                child: RSOtpField(
                  length: 6,
                  hasError: _hasError,
                  onChanged: (val) {
                    setState(() {
                      _code = val;
                      _hasError = false;
                    });
                  },
                  onCompleted: (val) {
                    _code = val;
                    _onVerify();
                  },
                ),
              ),
              if (_hasError) ...[
                const SizedBox(height: RSSpacing.sm),
                Text(
                  'Invalid verification code. Please check and try again.',
                  style: RSText.caption.copyWith(color: RSColors.statusError),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: RSSpacing.xl),

              RSButton.primary(
                'Verify & continue',
                _code.length == 6 ? _onVerify : null,
                disabled: _code.length != 6,
              ),
              const SizedBox(height: RSSpacing.md),

              Center(
                child: _secondsRemaining > 0
                    ? Text(
                        'Resend code in ${_secondsRemaining}s',
                        style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                      )
                    : TextButton(
                        onPressed: _startTimer,
                        child: Text(
                          'Resend code',
                          style: RSText.bodySmallStrong.copyWith(color: RSColors.brandAction),
                        ),
                      ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Wrong email? Change email address',
                    style: RSText.captionStrong.copyWith(color: RSColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: RSSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

