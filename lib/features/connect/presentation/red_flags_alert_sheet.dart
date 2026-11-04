import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class RedFlagsAlertSheet extends StatelessWidget {
  final VoidCallback onContinue;

  const RedFlagsAlertSheet({
    super.key,
    required this.onContinue,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onContinue}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: RSColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RSRadius.sheet)),
      ),
      builder: (ctx) => RedFlagsAlertSheet(onContinue: onContinue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(RSSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: RSColors.statusErrorTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.alertTriangle,
                size: 32,
                color: RSColors.statusError,
              ),
            ),
            const SizedBox(height: RSSpacing.md),
            Text(
              'Please see a doctor first',
              style: RSText.headingH2.copyWith(color: RSColors.statusError),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: RSSpacing.sm),
            Text(
              'Some of your symptoms (such as numbness, fever, severe night pain, or sudden trauma) require immediate medical examination before starting exercises.',
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: RSSpacing.xl),
            RSButton.primary(
              'I understand, continue',
              () {
                Navigator.of(context).pop();
                onContinue();
              },
            ),
            const SizedBox(height: RSSpacing.sm),
            RSButton.secondary(
              'Go back',
              () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

