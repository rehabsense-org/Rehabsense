import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminApplicationsScreen extends StatefulWidget {
  const AdminApplicationsScreen({super.key});

  @override
  State<AdminApplicationsScreen> createState() => _AdminApplicationsScreenState();
}

class _AdminApplicationsScreenState extends State<AdminApplicationsScreen> {
  int _selectedTab = 0; // 0: Pending, 1: Rejected, 2: Approved

  final List<Map<String, dynamic>> _applications = [
    {
      'id': 'app_001',
      'name': 'Dr. Sara Khan',
      'initials': 'SK',
      'license': 'PMDC-48213',
      'attempt': 'attempt 1 of 3',
      'status': 'Pending',
      'date': 'Submitted today',
    },
    {
      'id': 'app_002',
      'name': 'Dr. Omar Sheikh',
      'initials': 'OS',
      'license': 'PMDC-39120',
      'attempt': 'attempt 1 of 3',
      'status': 'Pending',
      'date': 'Submitted 2d ago',
    },
    {
      'id': 'app_003',
      'name': 'Dr. Hina Malik',
      'initials': 'HM',
      'license': 'PMDC-51007',
      'attempt': 'attempt 2 of 3',
      'status': 'Pending',
      'date': 'Submitted 3d ago',
    },
    {
      'id': 'app_004',
      'name': 'Dr. Zaid Ahmed',
      'initials': 'ZA',
      'license': 'PMDC-22764',
      'attempt': 'attempt 1 of 3',
      'status': 'Pending',
      'date': 'Submitted 5d ago',
    },
  ];

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
        title: Text('Doctor Applications', style: RSText.bodyStrong),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH, vertical: 8),
              child: RSSegmentedControl(
                segments: const ['Pending', 'Rejected', 'Approved'],
                selectedIndex: _selectedTab,
                onValueChanged: (idx) => setState(() => _selectedTab = idx),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _selectedTab == 0
                  ? ListView.separated(
                      padding: const EdgeInsets.all(RSSpacing.screenH),
                      itemCount: _applications.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final app = _applications[index];
                        return RSCard(
                          onTap: () => context.push('/admin/applications/${app['id']}'),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: RSColors.brandMint,
                                child: Text(
                                  app['initials'] as String,
                                  style: const TextStyle(color: RSColors.brandGreen, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(app['name'] as String, style: RSText.bodyStrong),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${app['license']} · ${app['attempt']}',
                                      style: RSText.caption.copyWith(color: RSColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              const RSStatusChip(
                                type: RSStatusChipType.incomplete,
                                customLabel: 'Pending',
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        _selectedTab == 1 ? 'No rejected applications' : 'No approved applications in this filter',
                        style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

