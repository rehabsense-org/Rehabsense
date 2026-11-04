import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'New doctor application',
        'subtitle': 'Dr. Sara Khan submitted credentials · 5 min ago',
        'icon': LucideIcons.fileText,
        'route': '/admin/applications/app_001',
      },
      {
        'title': 'Application resubmission',
        'subtitle': 'Dr. Hina Malik resubmitted license documents (attempt 2 of 3)',
        'icon': LucideIcons.refreshCw,
        'route': '/admin/applications/app_003',
      },
      {
        'title': 'Credentials updated',
        'subtitle': 'Dr. Omar Sheikh updated his PMDC registration',
        'icon': LucideIcons.alertCircle,
        'route': '/admin/doctors/doc_002',
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
        title: Text('Staff Notifications', style: RSText.bodyStrong),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = notifications[index];
            return RSCard(
              onTap: () => context.push(item['route'] as String),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: RSColors.brandMint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: RSColors.brandGreen,
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
                  Icon(LucideIcons.chevronRight, color: RSColors.textSecondary, size: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

