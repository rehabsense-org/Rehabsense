import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/models/models.dart';

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({super.key});

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  final _sessionRepo = SessionRepository();
  String _selectedFilter = 'All';
  final _searchController = TextEditingController();

  final List<String> _filters = const ['All', 'Knee Rehab', 'Shoulder', 'This week'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessions = _sessionRepo.getRecentSessions();

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: const Text('Session history'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // Search field
            RSInput(
              controller: _searchController,
              hintText: 'Search exercise or course...',
              prefixIcon: LucideIcons.search,
            ),
            const SizedBox(height: RSSpacing.md),

            // FilterChips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final isSelected = f == _selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() => _selectedFilter = f);
                      },
                      selectedColor: RSColors.brandMint,
                      backgroundColor: RSColors.surfaceCard,
                      labelStyle: TextStyle(
                        color: isSelected ? RSColors.brandGreen : RSColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: const StadiumBorder(
                        side: BorderSide(color: RSColors.borderInput),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            if (sessions.isEmpty)
              const RSEmptyState(
                icon: LucideIcons.calendar,
                title: 'Your sessions will appear here',
                body: 'Complete your first exercise to start building your rehabilitation log.',
              )
            else ...[
              Text('TODAY', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
              const SizedBox(height: 8),
              ...sessions.take(2).map((s) => _buildSessionItem(s, 'Today')),
              const SizedBox(height: 16),
              Text('YESTERDAY', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
              const SizedBox(height: 8),
              ...sessions.skip(2).map((s) => _buildSessionItem(s, 'Yesterday')),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(RSSession s, String dayGroup) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RSCard(
        onTap: () => context.push('/progress/session/${s.id}'),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: RSColors.brandMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.activity, color: RSColors.brandGreen, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mini Squat', style: RSText.bodyStrong),
                  const SizedBox(height: 2),
                  Text(
                    'Knee Rehab • 10:30 AM • 02:45',
                    style: RSText.caption.copyWith(color: RSColors.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Score ${s.score}',
                  style: RSText.bodyStrong.copyWith(color: RSColors.brandAction),
                ),
                const SizedBox(height: 4),
                RSStatusChip.fromOutcome(RepOutcome.correct, compact: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
