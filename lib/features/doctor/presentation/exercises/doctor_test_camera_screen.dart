import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorTestCameraScreen extends StatelessWidget {
  final String exerciseId;

  const DoctorTestCameraScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.brandDeep,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview placeholder
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.camera, color: RSColors.textOnDarkSoft, size: 72),
                  const SizedBox(height: 16),
                  Text(
                    'Camera Feed Preview',
                    style: RSText.bodyStrong.copyWith(color: RSColors.textOnDark),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tracking joint landmarks in real time',
                    style: RSText.caption.copyWith(color: RSColors.textOnDarkSoft),
                  ),
                ],
              ),
            ),

            // Top Header: Exit Button + Test Mode Pill
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
                  const SizedBox(width: 48), // Balancing spacer
                ],
              ),
            ),

            // Metric counter display
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    '0:22',
                    style: RSText.displayLarge.copyWith(color: RSColors.textOnDark),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hold 30 s · Target Range (80°-100°)',
                    style: RSText.bodyStrong.copyWith(color: RSColors.textOnDarkSoft),
                  ),
                ],
              ),
            ),

            // Live Angle feedback indicator
            Positioned(
              bottom: 160,
              left: 40,
              right: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: RSColors.statusSuccessTint,
                  borderRadius: BorderRadius.circular(RSRadius.card),
                  border: Border.all(color: RSColors.statusSuccess),
                ),
                child: Center(
                  child: Text(
                    'Angle in range: 92° (Good posture)',
                    style: RSText.bodySmallStrong.copyWith(color: RSColors.statusSuccess),
                  ),
                ),
              ),
            ),

            // Bottom control actions
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
                        const SnackBar(content: Text('Exercise marked as tested successfully!')),
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
