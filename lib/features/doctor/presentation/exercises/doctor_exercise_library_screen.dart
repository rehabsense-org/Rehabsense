import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorExerciseLibraryScreen extends StatefulWidget {
  const DoctorExerciseLibraryScreen({super.key});

  @override
  State<DoctorExerciseLibraryScreen> createState() => _DoctorExerciseLibraryScreenState();
}

class _DoctorExerciseLibraryScreenState extends State<DoctorExerciseLibraryScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _exercises = [
    {
      'id': 'knee_mini_squat',
      'name': 'Mini Squat',
      'category': 'Rehab',
      'type': 'rep',
      'view': 'side',
      'visibility': 'Public',
      'tested': true,
    },
    {
      'id': 'wall_sit_hold',
      'name': 'Wall Sit hold',
      'category': 'Rehab',
      'type': 'hold',
      'view': 'side',
      'visibility': 'Private',
      'tested': false,
    },
    {
      'id': 'warrior_ii_hold',
      'name': 'Warrior II hold',
      'category': 'Yoga',
      'type': 'hold',
      'view': 'front',
      'visibility': 'Public',
      'tested': true,
    },
    {
      'id': 'straight_leg_raise',
      'name': 'Straight-Leg Raise',
      'category': 'Rehab',
      'type': 'rep',
      'view': 'side',
      'visibility': 'Mine',
      'tested': true,
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
    final filtered = _exercises.where((e) {
      final nameMatches = (e['name'] as String).toLowerCase().contains(query);
      if (_selectedCategory == 'All') return nameMatches;
      if (_selectedCategory == 'Mine') {
        return nameMatches && (e['visibility'] == 'Private' || e['visibility'] == 'Mine');
      }
      return nameMatches && (e['category'] == _selectedCategory);
    }).toList();

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text('Exercise Library', style: RSText.bodyStrong),
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: RSButton.primary(
              'New',
              () => context.push('/doctor/exercises/new'),
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
                hintText: 'Search exercises...',
                prefixIcon: LucideIcons.search,
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Rehab', 'Yoga', 'Mine'].map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: RSChoiceChip(
                        label: cat,
                        selected: _selectedCategory == cat,
                        onSelected: (sel) => setState(() => _selectedCategory = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No exercises found',
                        style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final ex = filtered[index];
                        final isTested = ex['tested'] as bool;
                        final subtitle = '${ex['category']} · ${ex['type']} · ${ex['view']} view'
                            '${ex['visibility'] == 'Private' ? ' · Private' : ''}';

                        return RSCard(
                          onTap: () => context.push('/doctor/exercises/${ex['id']}/test'),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: RSColors.brandMint,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(LucideIcons.activity, color: RSColors.brandGreen, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ex['name'] as String, style: RSText.bodyStrong),
                                    const SizedBox(height: 2),
                                    Text(
                                      subtitle,
                                      style: RSText.caption.copyWith(color: RSColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              RSStatusChip(
                                type: isTested ? RSStatusChipType.correct : RSStatusChipType.incomplete,
                                customLabel: isTested ? 'Tested' : 'Untested',
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
