import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminPatientsListScreen extends StatefulWidget {
  const AdminPatientsListScreen({super.key});

  @override
  State<AdminPatientsListScreen> createState() => _AdminPatientsListScreenState();
}

class _AdminPatientsListScreenState extends State<AdminPatientsListScreen> {
  final _searchController = TextEditingController();
  String _filter = 'All';

  final List<Map<String, dynamic>> _patients = [
    {
      'id': 'pat_001',
      'name': 'Alex Morgan',
      'email': 'alex@rehab.test',
      'initials': 'AM',
      'status': 'Active',
      'joined': '2 Nov 2026',
    },
    {
      'id': 'pat_002',
      'name': 'Ali Raza',
      'email': 'ali.raza@mail.test',
      'initials': 'AR',
      'status': 'Active',
      'joined': '18 Oct 2026',
    },
    {
      'id': 'pat_003',
      'name': 'Sana Iqbal',
      'email': 'sana@mail.test',
      'initials': 'SI',
      'status': 'Disabled',
      'joined': '5 Oct 2026',
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
      final matchesQuery = (p['name'] as String).toLowerCase().contains(query) ||
          (p['email'] as String).toLowerCase().contains(query);
      if (_filter == 'All') return matchesQuery;
      return matchesQuery && (p['status'] == _filter);
    }).toList();

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Patients', style: RSText.bodyStrong),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH, vertical: 8),
              child: RSInput(
                hintText: 'Search patients by name or email...',
                prefixIcon: LucideIcons.search,
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
              child: Row(
                children: ['All', 'Active', 'Disabled'].map((f) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: RSChoiceChip(
                      label: f,
                      selected: _filter == f,
                      onSelected: (sel) => setState(() => _filter = f),
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
                  final p = filtered[index];
                  final isActive = p['status'] == 'Active';

                  return RSCard(
                    onTap: () => context.push('/admin/patients/${p['id']}'),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: isActive ? RSColors.brandMint : RSColors.statusErrorTint,
                          child: Text(
                            p['initials'] as String,
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
                              Text(p['name'] as String, style: RSText.bodyStrong),
                              const SizedBox(height: 2),
                              Text(
                                p['email'] as String,
                                style: RSText.caption.copyWith(color: RSColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        RSStatusChip(
                          type: isActive ? RSStatusChipType.correct : RSStatusChipType.incomplete,
                          customLabel: p['status'] as String,
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

