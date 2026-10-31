import 'package:flutter/material.dart';
import 'package:flutter_mp_pose_landmarker/flutter_mp_pose_landmarker.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class SafetyConsentScreen extends StatefulWidget {
  const SafetyConsentScreen({super.key});

  @override
  State<SafetyConsentScreen> createState() => _SafetyConsentScreenState();
}

class _SafetyConsentScreenState extends State<SafetyConsentScreen> {
  bool _consentGiven = false;
  bool _loading = false;

  void _requestCameraAndContinue() async {
    if (!_consentGiven) return;

    setState(() => _loading = true);

    try {
      final granted = await PoseLandmarker.checkCameraPermission();
      if (!granted) {
        final reqGranted = await PoseLandmarker.requestCameraPermission();
        if (!reqGranted) {
          if (!mounted) return;
          context.push('/setup/camera-help');
          return;
        }
      }

      if (!mounted) return;
      // Replaces onboarding stack per spec A 5.3
      context.go('/home');
    } catch (_) {
      if (!mounted) return;
      context.go('/home');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
        title: const Text('Step 2 of 2'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: RSProgressBar(value: 1.0, height: 4),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: RSSpacing.md),
              Text('Safety & camera consent', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'Please review how we use your camera and ensure you exercise safely.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: RSSpacing.xl),

              _buildInfoRow(
                icon: LucideIcons.camera,
                title: 'On-device camera tracking',
                body:
                    'Your camera tracks your joint coordinates in real-time. Video and images are processed on your phone and NEVER recorded, stored, or sent to any server.',
              ),
              const SizedBox(height: RSSpacing.md),
              _buildInfoRow(
                icon: LucideIcons.shieldCheck,
                title: 'Strict medical privacy',
                body:
                    'Only numerical joint angles, rep counts, and session movement scores are saved to track your rehabilitation progress.',
              ),
              const SizedBox(height: RSSpacing.md),
              _buildInfoRow(
                icon: LucideIcons.alertTriangle,
                title: 'Exercise safely',
                body:
                    'Clear enough space around you. Stop exercising immediately if you feel pain, dizziness, or sharp discomfort.',
              ),
              const SizedBox(height: RSSpacing.lg),

              // Disclaimer required on 08 per product rule 3
              RSCard(
                color: RSColors.surfaceCeramic,
                flat: true,
                child: Text(
                  'RehabSense is a guidance tool. It does not diagnose or replace your physiotherapist.',
                  style: RSText.caption.copyWith(color: RSColors.textMutedGreen),
                ),
              ),
              const SizedBox(height: RSSpacing.md),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _consentGiven,
                    onChanged: (val) => setState(() => _consentGiven = val ?? false),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'I have read and agree to the safety guidelines and camera usage policy.',
                        style: RSText.bodySmallStrong.copyWith(color: RSColors.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.xl),

              RSButton.primary(
                'Allow camera & continue',
                _consentGiven ? _requestCameraAndContinue : null,
                disabled: !_consentGiven,
                loading: _loading,
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.text(
                'Not now',
                () => context.push('/setup/camera-help'),
              ),
              const SizedBox(height: RSSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return RSCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: RSColors.brandMint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: RSColors.brandGreen),
          ),
          const SizedBox(width: RSSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: RSText.bodyStrong),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
