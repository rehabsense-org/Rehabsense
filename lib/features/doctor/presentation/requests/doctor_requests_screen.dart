import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorRequestsScreen extends StatefulWidget {
  const DoctorRequestsScreen({super.key});

  @override
  State<DoctorRequestsScreen> createState() => _DoctorRequestsScreenState();
}

class _DoctorRequestsScreenState extends State<DoctorRequestsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text('Patient Requests', style: RSText.headingH2),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH, vertical: 8),
              child: RSSegmentedControl(
                segments: const ['Pending (2)', 'Accepted (12)', 'Declined (3)'],
                selectedIndex: _selectedTab,
                onValueChanged: (index) => setState(() => _selectedTab = index),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
                children: [
                  if (_selectedTab == 0) ...[
                    _buildRequestCard(
                      id: 'req_001',
                      name: 'Alex Mercer',
                      area: 'Right Knee',
                      timeAgo: '2 hours ago',
                      snippet: 'ACL recovery • Needs guidance on range of motion',
                      matchScore: 95,
                    ),
                    const SizedBox(height: 12),
                    _buildRequestCard(
                      id: 'req_002',
                      name: 'Fatima Al-Sayed',
                      area: 'Left Shoulder',
                      timeAgo: '5 hours ago',
                      snippet: 'Rotator cuff impingement • Experiencing overhead stiffness',
                      matchScore: 92,
                    ),
                  ] else if (_selectedTab == 1) ...[
                    _buildHistoryTile(
                      name: 'Marcus Vance',
                      area: 'Right Knee',
                      date: 'Accepted yesterday',
                      status: 'Active Patient',
                      chipType: RSStatusChipType.correct,
                    ),
                    const SizedBox(height: 8),
                    _buildHistoryTile(
                      name: 'Chloe Bennett',
                      area: 'Cervical Spine',
                      date: 'Accepted 3 days ago',
                      status: 'Active Patient',
                      chipType: RSStatusChipType.correct,
                    ),
                  ] else ...[
                    _buildHistoryTile(
                      name: 'David Miller',
                      area: 'Lower Back',
                      date: 'Declined 4 days ago',
                      status: 'Caseload full',
                      chipType: RSStatusChipType.info,
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard({
    required String id,
    required String name,
    required String area,
    required String timeAgo,
    required String snippet,
    required int matchScore,
  }) {
    return RSCard(
      onTap: () => context.push('/doctor/requests/$id'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: RSColors.brandMint,
                child: Text(
                  name.split(' ').map((e) => e[0]).take(2).join(),
                  style: const TextStyle(color: RSColors.brandGreen, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: RSText.bodyStrong),
                    Text(timeAgo, style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: RSColors.accentGoldWash,
                  borderRadius: BorderRadius.circular(RSRadius.pill),
                  border: Border.all(color: RSColors.accentGold),
                ),
                child: Text('$matchScore% match', style: RSText.captionStrong.copyWith(color: RSColors.accentGoldDeep)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              RSStatusChip(
                type: RSStatusChipType.info,
                customLabel: area,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            snippet,
            style: RSText.bodySmall.copyWith(color: RSColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Review request',
                style: RSText.bodySmallStrong.copyWith(color: RSColors.brandAction),
              ),
              const Icon(LucideIcons.chevronRight, size: 16, color: RSColors.brandAction),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTile({
    required String name,
    required String area,
    required String date,
    required String status,
    required RSStatusChipType chipType,
  }) {
    return RSCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: RSText.bodyStrong),
                Text('$area • $date', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
              ],
            ),
          ),
          RSStatusChip(
            type: chipType,
            customLabel: status,
          ),
        ],
      ),
    );
  }
}

