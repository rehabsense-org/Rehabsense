import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminExerciseLibraryScreen extends StatefulWidget {
  const AdminExerciseLibraryScreen({super.key});

  @override
  State<AdminExerciseLibraryScreen> createState() => _AdminExerciseLibraryScreenState();
}

class _AdminExerciseLibraryScreenState extends State<AdminExerciseLibraryScreen> {
  String _filter = 'All';

  final List<Map<String, dynamic>> _exercises = [
    {
      'id': 'knee_mini_squat',
      'name': 'Mini Squat',
      'category': 'Rehab',
      'type': 'rep',
      'visibility': 'Public',
      'tested': true,
    },
    {
      'id': 'warrior_ii_hold',
      'name': 'Warrior II hold',
      'category': 'Yoga',
      'type': 'hold',
      'visibility': 'Public',
      'tested': true,
    },
    {
      'id': 'tree_pose_hold',
      'name': 'Tree pose hold',
      'category': 'Yoga',
      'type': 'hold',
      'visibility': 'Public',
      'tested': false,
    },
    {
      'id': 'wall_sit',
      'name': 'Wall Sit',
      'category': 'Rehab',
      'type': 'hold',
      'visibility': 'Private (Dr. Khan)',
      'tested': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _exercises.where((e) {
      if (_filter == 'All') return true;
      if (_filter == 'Public') return e['visibility'] == 'Public';
      if (_filter == 'Private') return (e['visibility'] as String).contains('Private');
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Exercise Management', style: RSText.bodyStrong),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: RSButton.primary(
              'New',
              () => context.push('/admin/exercises/new'),
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Public', 'Private', 'Archived'].map((f) {
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
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(RSSpacing.screenH),
                itemCount: filtered.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final ex = filtered[index];
                  final isTested = ex['tested'] as bool;
                  final subtitle = '${ex['category']} · ${ex['type']} · ${ex['visibility']}';

                  return RSCard(
                    onTap: () => context.push('/admin/exercises/${ex['id']}/test'),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: RSColors.brandMint,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.activity, color: RSColors.brandGreen, size: 20),
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

