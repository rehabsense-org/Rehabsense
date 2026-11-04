import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class PainAlertSheet extends StatelessWidget {
  final int painLevel;
  final VoidCallback? onAcknowledge;

  const PainAlertSheet({
    super.key,
    required this.painLevel,
    this.onAcknowledge,
  });

  static Future<void> show(BuildContext context, {required int painLevel, VoidCallback? onAcknowledge}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: RSColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => PainAlertSheet(
        painLevel: painLevel,
        onAcknowledge: onAcknowledge,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                  LucideIcons.alertTriangle,
                  color: RSColors.statusError,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'High pain reported ($painLevel / 10)',
              style: RSText.headingH2.copyWith(color: RSColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Stop the exercise if you feel sharp or worsening pain. '
              'We have flagged this session for your physiotherapist to review.',
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RSColors.surfaceCeramic,
                borderRadius: BorderRadius.circular(RSRadius.card),
              ),
              child: Text(
                'RehabSense is a guidance tool. It does not diagnose or replace your physiotherapist.',
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            RSButton.primary(
              'I understand',
              () {
                Navigator.of(context).pop();
                onAcknowledge?.call();
              },
            ),
            const SizedBox(height: 8),
            RSButton.secondary(
              'View My Doctor',
              () {
                Navigator.of(context).pop();
                context.push('/my-doctor');
              },
            ),
          ],
        ),
      ),
    );
  }
}

