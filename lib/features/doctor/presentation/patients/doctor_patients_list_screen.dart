import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorPatientsListScreen extends StatefulWidget {
  const DoctorPatientsListScreen({super.key});

  @override
  State<DoctorPatientsListScreen> createState() => _DoctorPatientsListScreenState();
}

class _DoctorPatientsListScreenState extends State<DoctorPatientsListScreen> {
  final _searchController = TextEditingController();
  String _filter = 'All';

  final List<Map<String, dynamic>> _patients = [
    {
      'id': 'patient_001',
      'name': 'Alex Mercer',
      'area': 'Right Knee',
      'adherence': 90,
      'movementScore': 86,
      'lastSession': 'Today',
      'painLevel': 5,
      'status': 'Active',
    },
    {
      'id': 'patient_002',
      'name': 'Chloe Bennett',
      'area': 'Cervical Spine',
      'adherence': 85,
      'movementScore': 92,
      'lastSession': 'Yesterday',
      'painLevel': 2,
      'status': 'Active',
    },
    {
      'id': 'patient_003',
      'name': 'Marcus Vance',
      'area': 'Right Shoulder',
      'adherence': 60,
      'movementScore': 74,
      'lastSession': '3 days ago',
      'painLevel': 8,
      'status': 'Needs Attention',
    },
    {
      'id': 'patient_004',
      'name': 'Eleanor Davies',
      'area': 'Right Knee',
      'adherence': 95,
      'movementScore': 89,
      'lastSession': 'Today',
      'painLevel': 3,
      'status': 'Active',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _patients.where((p) {
      final nameMatches = (p['name'] as String).toLowerCase().contains(query);
      if (_filter == 'Needs Attention') {
        return nameMatches && (p['painLevel'] as int) >= 7;
      }
      return nameMatches;
    }).toList();

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text('My Patients', style: RSText.headingH2),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH, vertical: 8),
              child: RSInput(
                hintText: 'Search patients by name...',
                prefixIcon: LucideIcons.search,
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
              child: Row(
                children: [
                  RSChoiceChip(
                    label: 'All (${_patients.length})',
                    selected: _filter == 'All',
                    onSelected: (sel) => setState(() => _filter = 'All'),
                  ),
                  const SizedBox(width: 8),
                  RSChoiceChip(
                    label: 'Needs Attention (1)',
                    selected: _filter == 'Needs Attention',
                    onSelected: (sel) => setState(() => _filter = 'Needs Attention'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = filtered[index];
                  final isAlert = (p['painLevel'] as int) >= 7;

                  return RSCard(
                    onTap: () => context.push('/doctor/patients/${p['id']}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: isAlert ? RSColors.statusErrorTint : RSColors.brandMint,
                              child: Text(
                                (p['name'] as String).split(' ').map((e) => e[0]).take(2).join(),
                                style: TextStyle(
                                  color: isAlert ? RSColors.statusError : RSColors.brandGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p['name'] as String, style: RSText.bodyStrong),
                                  Text('${p['area']} · Last session: ${p['lastSession']}',
                                      style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                                ],
                              ),
                            ),
                            RSStatusChip(
                              type: isAlert ? RSStatusChipType.incorrect : RSStatusChipType.correct,
                              customLabel: p['status'] as String,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Adherence: ${p['adherence']}%',
                              style: RSText.captionStrong.copyWith(color: RSColors.brandGreen),
                            ),
                            Text(
                              'Movement score: ${p['movementScore']}',
                              style: RSText.captionStrong.copyWith(color: RSColors.brandAction),
                            ),
                            Text(
                              'Pain: ${p['painLevel']}/10',
                              style: RSText.captionStrong.copyWith(
                                color: isAlert ? RSColors.statusError : RSColors.textSecondary,
                              ),
                            ),
                          ],
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

