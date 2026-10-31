import 'package:flutter/material.dart';
import 'package:flutter_mp_pose_landmarker/flutter_mp_pose_landmarker.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class CameraHelpScreen extends StatelessWidget {
  const CameraHelpScreen({super.key});

  void _openSettings(BuildContext context) async {
    await PoseLandmarker.requestCameraPermission();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Checking camera permissions...')),
      );
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
        title: const Text('Camera permission'),
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
                    color: RSColors.statusErrorTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.cameraOff,
                    size: 40,
                    color: RSColors.statusError,
                  ),
                ),
              ),
              const SizedBox(height: RSSpacing.lg),
              Text(
                'Camera access is off',
                style: RSText.headingH1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'RehabSense requires camera access to track your body movements and count repetitions in real time.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xl),

              RSCard(
                child: Column(
                  children: [
                    _buildStep('1', 'Open your phone Settings'),
                    const Divider(height: 20),
                    _buildStep('2', 'Tap on Permissions or Apps'),
                    const Divider(height: 20),
                    _buildStep('3', 'Select Camera and choose "Allow"'),
                  ],
                ),
              ),

              const Spacer(),
              RSButton.primary(
                'Open settings',
                () => _openSettings(context),
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.secondary(
                'Back to home',
                () => context.go('/home'),
              ),
              const SizedBox(height: RSSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: RSColors.brandMint,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: RSText.bodySmallStrong.copyWith(color: RSColors.brandGreen),
          ),
        ),
        const SizedBox(width: RSSpacing.md),
        Expanded(
          child: Text(text, style: RSText.bodyStrong),
        ),
      ],
    );
  }
}
