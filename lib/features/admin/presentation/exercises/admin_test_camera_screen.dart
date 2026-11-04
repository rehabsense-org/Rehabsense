import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminTestCameraScreen extends StatelessWidget {
  final String exerciseId;

  const AdminTestCameraScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.brandDeep,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.camera, color: RSColors.textOnDarkSoft, size: 72),
                  const SizedBox(height: 16),
                  Text(
                    'Staff Camera Simulator',
                    style: RSText.bodyStrong.copyWith(color: RSColors.textOnDark),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tracking MediaPipe 2D posture angles',
                    style: RSText.caption.copyWith(color: RSColors.textOnDarkSoft),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(LucideIcons.x, color: RSColors.textOnDark),
                    onPressed: () => context.pop(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: RSColors.accentGoldWash,
                      borderRadius: BorderRadius.circular(RSRadius.pill),
                      border: Border.all(color: RSColors.accentGold),
                    ),
                    child: Text(
                      'TEST MODE · nothing is saved',
                      style: RSText.captionStrong.copyWith(color: RSColors.accentGoldDeep),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    '0:14',
                    style: RSText.displayLarge.copyWith(color: RSColors.textOnDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hold 20 s · Tree pose',
                    style: RSText.bodyStrong.copyWith(color: RSColors.textOnDarkSoft),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RSButton.primary(
                    'Mark as tested',
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Exercise marked as tested.')),
                      );
                      context.pop();
                    },
                  ),
                  const SizedBox(height: 8),
                  RSButton.secondary(
                    'Back to builder',
                    () => context.pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

