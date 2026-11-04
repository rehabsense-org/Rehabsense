import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminDoctorsListScreen extends StatefulWidget {
  const AdminDoctorsListScreen({super.key});

  @override
  State<AdminDoctorsListScreen> createState() => _AdminDoctorsListScreenState();
}

class _AdminDoctorsListScreenState extends State<AdminDoctorsListScreen> {
  final _searchController = TextEditingController();
  String _filter = 'All';

  final List<Map<String, dynamic>> _doctors = [
    {
      'id': 'doc_001',
      'name': 'Dr. Sara Khan',
      'initials': 'SK',
      'patientsCount': 12,
      'specialty': 'Knee, Post-surgery',
      'status': 'Active',
      'license': 'PMDC-48213',
    },
    {
      'id': 'doc_002',
      'name': 'Dr. Omar Sheikh',
      'initials': 'OS',
      'patientsCount': 8,
      'specialty': 'Sports Rehabilitation',
      'status': 'Active',
      'license': 'PMDC-39120',
    },
    {
      'id': 'doc_003',
      'name': 'Dr. Hina Malik',
      'initials': 'HM',
      'patientsCount': 0,
      'specialty': 'Shoulder Rehabilitation',
      'status': 'Suspended',
      'license': 'PMDC-51007',
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
    final filtered = _doctors.where((d) {
      final matchesName = (d['name'] as String).toLowerCase().contains(query) ||
          (d['license'] as String).toLowerCase().contains(query);
      if (_filter == 'All') return matchesName;
      return matchesName && (d['status'] == _filter);
    }).toList();

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Doctors Directory', style: RSText.bodyStrong),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: RSButton.secondary(
              'Add doctor',
              () => context.push('/admin/doctors/new'),
              size: RSButtonSize.medium,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH, vertical: 8),
              child: RSInput(
                hintText: 'Search doctors by name or license...',
                prefixIcon: LucideIcons.search,
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
              child: Row(
                children: ['All', 'Active', 'Suspended'].map((status) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: RSChoiceChip(
                      label: status,
                      selected: _filter == status,
                      onSelected: (sel) => setState(() => _filter = status),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(RSSpacing.screenH),
                itemCount: filtered.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final doc = filtered[index];
                  final isActive = doc['status'] == 'Active';

                  return RSCard(
                    onTap: () => context.push('/admin/doctors/${doc['id']}'),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: isActive ? RSColors.brandMint : RSColors.statusErrorTint,
                          child: Text(
                            doc['initials'] as String,
                            style: TextStyle(
                              color: isActive ? RSColors.brandGreen : RSColors.statusError,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc['name'] as String, style: RSText.bodyStrong),
                              const SizedBox(height: 2),
                              Text(
                                '${doc['patientsCount']} active patients · ${doc['specialty']}',
                                style: RSText.caption.copyWith(color: RSColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        RSStatusChip(
                          type: isActive ? RSStatusChipType.correct : RSStatusChipType.incomplete,
                          customLabel: doc['status'] as String,
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

