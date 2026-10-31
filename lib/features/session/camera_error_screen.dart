import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class CameraErrorScreen extends StatelessWidget {
  final String exerciseId;

  const CameraErrorScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCamera,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: RSIconButton.glass(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: RSColors.surfaceCard,
                  borderRadius: RSRadius.sheetBR,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: RSColors.statusErrorTint,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.cameraOff,
                          size: 28,
                          color: RSColors.statusError,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "We can't see you clearly",
                      style: RSText.headingH3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pose tracking lost your landmarks. Common causes:',
                      style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildCauseItem('Room is too dark or has strong backlighting'),
                    const SizedBox(height: 8),
                    _buildCauseItem('Too close or too far from the camera (aim for ~2m)'),
                    const SizedBox(height: 8),
                    _buildCauseItem('Clothing blending into the background'),
                    const SizedBox(height: 8),
                    _buildCauseItem('Another person walked into the camera frame'),
                    const SizedBox(height: 24),
                    RSButton.primary(
                      'Try again',
                      () => context.pushReplacement('/session/$exerciseId/camera'),
                    ),
                    const SizedBox(height: 8),
                    RSButton.text(
                      'View camera tips',
                      () => context.push('/profile/help'),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCauseItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(LucideIcons.alertCircle, size: 16, color: RSColors.statusWarningInk),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: RSText.bodySmall),
        ),
      ],
    );
  }
}
