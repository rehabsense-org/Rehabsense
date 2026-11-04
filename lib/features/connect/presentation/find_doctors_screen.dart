import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class FindDoctorsScreen extends StatefulWidget {
  const FindDoctorsScreen({super.key});

  @override
  State<FindDoctorsScreen> createState() => _FindDoctorsScreenState();
}

class _FindDoctorsScreenState extends State<FindDoctorsScreen> {
  String _selectedFilter = 'Best match';

  final List<Map<String, dynamic>> _doctors = [
    {
      'id': 'doc_001',
      'name': 'Dr. Sara Khan',
      'subtitle': 'Physiotherapist · 8 yrs experience',
      'tags': ['Knee', 'Post-surgery', 'Sports injury'],
      'matchText': '96% match',
      'clinic': 'City Rehab Clinic',
    },
    {
      'id': 'doc_002',
      'name': 'Dr. Omar Sheikh',
      'subtitle': 'Sports Physio · 5 yrs experience',
      'tags': ['Knee', 'Sports injury', 'Ankle'],
      'matchText': '88% match',
      'clinic': 'Metro Sports Clinic',
    },
    {
      'id': 'doc_003',
      'name': 'Dr. Hina Malik',
      'subtitle': 'Orthopedic Rehab · 11 yrs experience',
      'tags': ['Shoulder', 'Hip', 'Spine'],
      'matchText': '71% match',
      'clinic': 'Orthocare Center',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filters = ['Best match', 'Knee', 'Sports injury', 'All doctors'];

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'Find doctors',
          style: RSText.headingH3.copyWith(color: RSColors.brandGreen),
        ),
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: RSSpacing.screenH,
                vertical: RSSpacing.sm,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((f) {
                    return Padding(
                      padding: const EdgeInsets.only(right: RSSpacing.sm),
                      child: RSChoiceChip(
                        label: f,
                        selected: _selectedFilter == f,
                        onSelected: (_) => setState(() => _selectedFilter = f),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(RSSpacing.screenH),
                itemCount: _doctors.length,
                separatorBuilder: (context, index) => const SizedBox(height: RSSpacing.md),
                itemBuilder: (context, index) {
                  final doc = _doctors[index];
                  return RSDoctorCard(
                    name: doc['name'] as String,
                    subtitle: doc['subtitle'] as String,
                    tags: List<String>.from(doc['tags'] as List),
                    matchText: doc['matchText'] as String?,
                    onTap: () => context.push('/connect/doctors/${doc['id']}'),
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

