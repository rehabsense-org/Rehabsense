import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorNotificationsScreen extends StatelessWidget {
  const DoctorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'New request',
        'subtitle': 'Alex Morgan wants to connect · 5 min ago',
        'icon': LucideIcons.userPlus,
        'route': '/doctor/requests/req_001',
        'isAlert': false,
      },
      {
        'title': 'Pain alert',
        'subtitle': 'Ali Raza reported pain 8 · 1 h ago',
        'icon': LucideIcons.alertTriangle,
        'route': '/doctor/sessions/sess_001/review',
        'isAlert': true,
      },
      {
        'title': 'Request expiring',
        'subtitle': 'Bilal Noor’s request expires in 24 h',
        'icon': LucideIcons.clock,
        'route': '/doctor/requests/req_002',
        'isAlert': false,
      },
      {
        'title': 'Patient inactive',
        'subtitle': 'Sana Iqbal has not trained for 3 days',
        'icon': LucideIcons.bell,
        'route': '/doctor/patients/patient_001',
        'isAlert': false,
      },
      {
        'title': 'Application approved',
        'subtitle': 'You are now listed for patients in the directory',
        'icon': LucideIcons.checkCircle,
        'route': '/doctor/home',
        'isAlert': false,
      },
    ];

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Notifications', style: RSText.bodyStrong),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = notifications[index];
            final isAlert = item['isAlert'] as bool;

            return RSCard(
              onTap: () => context.push(item['route'] as String),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isAlert ? RSColors.statusErrorTint : RSColors.brandMint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: isAlert ? RSColors.statusError : RSColors.brandGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'] as String, style: RSText.bodyStrong),
                        const SizedBox(height: 2),
                        Text(
                          item['subtitle'] as String,
                          style: RSText.caption.copyWith(color: RSColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, color: RSColors.textSecondary, size: 18),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
