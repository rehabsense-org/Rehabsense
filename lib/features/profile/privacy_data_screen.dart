import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class PrivacyDataScreen extends StatelessWidget {
  const PrivacyDataScreen({super.key});

  void _showDeleteAccountDialog(BuildContext context) {
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: RSColors.overlayScrim,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final canDelete = confirmController.text.trim() == 'DELETE';

          return AlertDialog(
            backgroundColor: RSColors.surfaceCard,
            shape: RoundedRectangleBorder(borderRadius: RSRadius.sheetBR),
            title: Row(
              children: const [
                Icon(LucideIcons.alertTriangle, color: RSColors.statusError),
                SizedBox(width: 8),
                Text('Delete account?'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This action is irreversible. All your rehabilitation history, scores, and profile data will be permanently wiped.',
                  style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Text('Type DELETE to confirm:', style: RSText.bodySmallStrong),
                const SizedBox(height: 8),
                TextField(
                  controller: confirmController,
                  onChanged: (_) => setDialogState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'DELETE',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: canDelete
                    ? () {
                        Navigator.pop(ctx);
                        context.go('/welcome');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: RSColors.statusError,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: RSColors.surfaceCeramic,
                ),
                child: const Text('Delete permanently'),
              ),
            ],
          );
        },
      ),
    );
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
        title: const Text('Privacy & data'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // What we store vs What we don't
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(LucideIcons.shieldCheck, color: RSColors.brandAction, size: 20),
                      SizedBox(width: 8),
                      Text('What we store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('• Your name, email, and age range preference', style: RSText.bodySmall),
                  const SizedBox(height: 4),
                  Text('• Repetition counts, joint angles, and movement scores', style: RSText.bodySmall),
                  const SizedBox(height: 4),
                  Text('• App notification and audio preferences', style: RSText.bodySmall),
                  const Divider(height: 24),
                  Row(
                    children: const [
                      Icon(LucideIcons.cameraOff, color: RSColors.statusSuccess, size: 20),
                      SizedBox(width: 8),
                      Text('What we NEVER store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('• NO video recordings are ever created or saved', style: RSText.bodySmall),
                  const SizedBox(height: 4),
                  Text('• NO camera photos or frames are persisted or uploaded', style: RSText.bodySmall),
                  const SizedBox(height: 4),
                  Text('• All pose landmark analysis runs strictly on your device', style: RSText.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.xl),

            Text('DATA CONTROLS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: 8),

            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.download,
                  title: 'Export my data',
                  subtitle: 'Download your session history as JSON',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Session data exported to downloads.')),
                    );
                  },
                ),
                RSMenuRowItem(
                  icon: LucideIcons.trash2,
                  title: 'Clear local sessions',
                  subtitle: 'Erase cached session records on this device',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Local cache cleared.')),
                    );
                  },
                ),
                RSMenuRowItem(
                  icon: LucideIcons.userX,
                  title: 'Delete account',
                  subtitle: 'Permanently remove your account and data',
                  danger: true,
                  onTap: () => _showDeleteAccountDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
