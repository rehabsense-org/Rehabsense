import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../app/auth_notifier.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminLogoutDialog extends StatelessWidget {
  const AdminLogoutDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const AdminLogoutDialog(),
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
                color: RSColors.statusErrorTint,
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.logOut, color: RSColors.statusError, size: 24),
            ),
            const SizedBox(height: 16),
            Text('Log out?', style: RSText.headingH3),
            const SizedBox(height: 8),
            Text(
              'You will be signed out of the staff console and returned to the welcome screen.',
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
                  child: RSButton.destructive(
                    'Log out',
                    () async {
                      Navigator.of(context).pop();
                      await AuthNotifier.instance.signOut();
                      if (context.mounted) {
                        context.go('/welcome');
                      }
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

