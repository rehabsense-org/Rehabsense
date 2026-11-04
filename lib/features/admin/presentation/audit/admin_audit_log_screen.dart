import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminAuditLogScreen extends StatefulWidget {
  const AdminAuditLogScreen({super.key});

  @override
  State<AdminAuditLogScreen> createState() => _AdminAuditLogScreenState();
}

class _AdminAuditLogScreenState extends State<AdminAuditLogScreen> {
  String _filter = 'All';

  final List<Map<String, dynamic>> _logs = [
    {
      'title': 'Approved doctor application',
      'detail': 'admin@rehabsense.test · Dr. Sara Khan · Today, 9:30 AM',
      'icon': LucideIcons.checkCircle,
      'color': RSColors.brandGreen,
      'category': 'Approvals',
    },
    {
      'title': 'Rejected doctor application',
      'detail': 'admin@rehabsense.test · Dr. Hina Malik · Yesterday, 4:15 PM',
      'icon': LucideIcons.xCircle,
      'color': RSColors.statusError,
      'category': 'Approvals',
    },
    {
      'title': 'Published public exercise',
      'detail': 'admin@rehabsense.test · Tree pose · 2 days ago',
      'icon': LucideIcons.zap,
      'color': RSColors.accentGoldDeep,
      'category': 'Exercises',
    },
    {
      'title': 'Suspended doctor account',
      'detail': 'admin@rehabsense.test · Dr. Zaid Ahmed · 5 days ago',
      'icon': LucideIcons.ban,
      'color': RSColors.statusError,
      'category': 'Suspensions',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _logs.where((l) {
      if (_filter == 'All') return true;
      return l['category'] == _filter;
    }).toList();

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Audit Log', style: RSText.bodyStrong),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: RSColors.brandMint,
                  borderRadius: BorderRadius.circular(RSRadius.card),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.shield, color: RSColors.brandGreen, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Read-only audit trail. Every administrative decision and modification is immutably logged.',
                        style: RSText.caption.copyWith(color: RSColors.brandGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Approvals', 'Suspensions', 'Exercises'].map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: RSChoiceChip(
                        label: cat,
                        selected: _filter == cat,
                        onSelected: (sel) => setState(() => _filter = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(RSSpacing.screenH),
                itemCount: filtered.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final log = filtered[index];
                  return RSCard(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: (log['color'] as Color).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            log['icon'] as IconData,
                            color: log['color'] as Color,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(log['title'] as String, style: RSText.bodyStrong),
                              const SizedBox(height: 2),
                              Text(
                                log['detail'] as String,
                                style: RSText.caption.copyWith(color: RSColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

