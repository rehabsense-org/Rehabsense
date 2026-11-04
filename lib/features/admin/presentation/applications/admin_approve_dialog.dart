import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminApproveDialog extends StatelessWidget {
  final String doctorName;
  final VoidCallback onApproved;

  const AdminApproveDialog({
    super.key,
    required this.doctorName,
    required this.onApproved,
  });

  static Future<void> show(
    BuildContext context, {
    required String doctorName,
    required VoidCallback onApproved,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AdminApproveDialog(
        doctorName: doctorName,
        onApproved: onApproved,
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
              decoration: const BoxDecoration(
                color: RSColors.brandMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.checkCircle, color: RSColors.brandGreen, size: 24),
            ),
            const SizedBox(height: 16),
            Text('Approve $doctorName?', style: RSText.headingH3, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'The doctor will be approved, granted clinical portal access, and listed in the directory. This event is recorded in the audit log.',
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
                  child: RSButton.primary(
                    'Approve',
                    () {
                      Navigator.of(context).pop();
                      onApproved();
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
