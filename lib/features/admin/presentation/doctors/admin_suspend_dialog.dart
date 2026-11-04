import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminSuspendDialog extends StatelessWidget {
  final String doctorName;
  final bool isCurrentlySuspended;
  final VoidCallback onConfirm;

  const AdminSuspendDialog({
    super.key,
    required this.doctorName,
    this.isCurrentlySuspended = false,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String doctorName,
    bool isCurrentlySuspended = false,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AdminSuspendDialog(
        doctorName: doctorName,
        isCurrentlySuspended: isCurrentlySuspended,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: RSColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RSRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCurrentlySuspended ? RSColors.brandMint : RSColors.statusErrorTint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCurrentlySuspended ? LucideIcons.checkCircle : LucideIcons.ban,
                color: isCurrentlySuspended ? RSColors.brandGreen : RSColors.statusError,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isCurrentlySuspended ? 'Reactivate $doctorName?' : 'Suspend $doctorName?',
              style: RSText.headingH3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isCurrentlySuspended
                  ? 'The doctor will regain full clinical access and appear in directory search.'
                  : 'She will be signed out immediately and her profile will be hidden from new patients. Existing assignments will be paused.',
              style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RSButton.secondary(
                    'Cancel',
                    () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: isCurrentlySuspended
                      ? RSButton.primary(
                          'Reactivate',
                          () {
                            Navigator.of(context).pop();
                            onConfirm();
                          },
                        )
                      : RSButton.destructive(
                          'Suspend doctor',
                          () {
                            Navigator.of(context).pop();
                            onConfirm();
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

