import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/seed/seed_data.dart';

class ChecklistScreen extends StatefulWidget {
  final String exerciseId;

  const ChecklistScreen({super.key, required this.exerciseId});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<bool> _checked = [false, false, false, false, false, false];

  static const List<Map<String, dynamic>> _items = [
    {
      'icon': LucideIcons.smartphone,
      'title': 'Phone propped at hip height, ~2m away',
      'sub': 'Lean against a water bottle or stable object',
    },
    {
      'icon': LucideIcons.sun,
      'title': 'Bright, even room lighting',
      'sub': 'Avoid backlight from windows directly behind you',
    },
    {
      'icon': LucideIcons.maximize,
      'title': 'Clear space to move freely',
      'sub': 'Ensure no obstacles or tripping hazards',
    },
    {
      'icon': LucideIcons.user,
      'title': 'Full body visible in frame',
      'sub': 'From head to feet when standing',
    },
    {
      'icon': LucideIcons.shieldCheck,
      'title': 'Comfortable exercise clothing',
      'sub': 'Fitted clothing helps joint tracking accuracy',
    },
    {
      'icon': LucideIcons.heartPulse,
      'title': 'I am currently not in sharp pain',
      'sub': 'Stop immediately if pain occurs',
    },
  ];

  bool get _allChecked => _checked.every((c) => c);

  void _startCamera() {
    context.push('/session/${widget.exerciseId}/camera');
  }

  @override
  Widget build(BuildContext context) {
    final exercise = seedExercises.firstWhere(
      (e) => e.id == widget.exerciseId,
      orElse: () => seedExercises.first,
    );

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: const Text('Get ready'),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RSButton.primary(
              'Start camera',
              _allChecked ? _startCamera : null,
              disabled: !_allChecked,
            ),
            const SizedBox(height: 4),
            RSButton.text(
              'Skip tips',
              _startCamera,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            Text(exercise.name, style: RSText.headingH1),
            const SizedBox(height: 4),
            Text(
              'Take a moment to set up your environment for the most accurate tracking.',
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: RSSpacing.lg),

            RSCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: List.generate(_items.length, (i) {
                  final item = _items[i];
                  return Column(
                    children: [
                      CheckboxListTile(
                        value: _checked[i],
                        onChanged: (val) {
                          setState(() => _checked[i] = val ?? false);
                        },
                        secondary: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: RSColors.brandMint,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item['icon'] as IconData, size: 18, color: RSColors.brandGreen),
                        ),
                        title: Text(item['title'] as String, style: RSText.bodyStrong),
                        subtitle: Text(
                          item['sub'] as String,
                          style: RSText.caption.copyWith(color: RSColors.textSecondary),
                        ),
                        activeColor: RSColors.brandAction,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      ),
                      if (i < _items.length - 1)
                        const Divider(indent: 56, endIndent: 16, height: 1),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
