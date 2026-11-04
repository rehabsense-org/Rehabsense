import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class DisconnectConfirmDialog extends StatelessWidget {
  final String doctorName;
  final VoidCallback onDisconnect;

  const DisconnectConfirmDialog({
    super.key,
    required this.doctorName,
    required this.onDisconnect,
  });

  static Future<void> show(
    BuildContext context, {
    required String doctorName,
    required VoidCallback onDisconnect,
  }) {
    return showDialog(
      context: context,
      barrierColor: RSColors.overlayScrim,
      builder: (ctx) => DisconnectConfirmDialog(
        doctorName: doctorName,
        onDisconnect: onDisconnect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RSDialog(
      icon: LucideIcons.alertTriangle,
      iconBgColor: RSColors.statusErrorTint,
      iconColor: RSColors.statusError,
      title: 'Disconnect from $doctorName?',
      body:
          'Your doctor will no longer be able to monitor your exercise sessions. Any prescribed exercises will be locked.',
      primaryButtonLabel: 'Disconnect',
      primaryIsDestructive: true,
      onPrimaryPressed: () {
        Navigator.of(context).pop();
        onDisconnect();
      },
      secondaryButtonLabel: 'Stay connected',
    );
  }
}

