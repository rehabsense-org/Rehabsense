import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';
import '../../data/seed/seed_data.dart';
import '../../domain/models/models.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _selectedPeriod = 0; // 0=Week, 1=Month, 2=All time
  final _sessionRepo = SessionRepository();

  @override
  Widget build(BuildContext context) {
    final recentSessions = _sessionRepo.getRecentSessions();

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text('Progress', style: RSText.headingH1.copyWith(color: RSColors.textPrimary)),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH, vertical: 8),
          children: [
            Text(
              'Track your rehabilitation consistency and movement quality over time.',
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: RSSpacing.md),

            // SegmentedControl Week / Month / All time
            RSSegmentedControl(
              segments: const ['Week', 'Month', 'All time'],
              selectedIndex: _selectedPeriod,
              onValueChanged: (val) => setState(() => _selectedPeriod = val),
            ),
            const SizedBox(height: RSSpacing.lg),

            // 2x2 StatTiles (Sessions, Reps, Avg score, Streak)
            Row(
              children: const [
                Expanded(
                  child: RSStatTile(
                    label: 'Sessions',
                    value: '12',
                    delta: '+3 this week',
                    deltaPositive: true,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: RSStatTile(
                    label: 'Total Reps',
                    value: '140',
                    delta: '+40 vs last wk',
                    deltaPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(
                  child: RSStatTile(
                    label: 'Avg Score',
                    value: '84',
                    delta: '+5 pts improved',
                    deltaPositive: true,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: RSStatTile(
                    label: 'Current Streak',
                    value: '5d',
                    delta: 'Personal best!',
                    deltaPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.xl),

            // LineChart Movement score over time
            Text('Movement score over time', style: RSText.headingH3),
            const SizedBox(height: RSSpacing.sm),
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('WEEKLY TREND', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                      Text('Avg 84', style: RSText.captionStrong.copyWith(color: RSColors.brandAction)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _MiniTrendChartPainter(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Mon', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 11)),
                      Text('Tue', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 11)),
                      Text('Wed', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 11)),
                      Text('Thu', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 11)),
                      Text('Fri', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 11)),
                      Text('Sat', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 11)),
                      Text('Sun', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.xl),

            // Exercises List
            Text('Exercises', style: RSText.headingH3),
            const SizedBox(height: RSSpacing.sm),
            ...seedExercises.take(4).map((ex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RSCard(
                  onTap: () => context.push('/progress/exercise/${ex.id}'),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: RSColors.brandMint,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.activity, size: 20, color: RSColors.brandGreen),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex.name, style: RSText.bodyStrong),
                            const SizedBox(height: 2),
                            Text('4 sessions completed', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('88', style: RSText.bodyStrong.copyWith(color: RSColors.brandAction)),
                          Text('Best score', style: RSText.caption.copyWith(color: RSColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(width: 8),
                      const Icon(LucideIcons.chevronRight, size: 18, color: RSColors.borderInput),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: RSSpacing.xl),

            // Recent Sessions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent sessions', style: RSText.headingH3),
                GestureDetector(
                  onTap: () => context.push('/progress/history'),
                  child: Text(
                    'View all',
                    style: RSText.bodySmallStrong.copyWith(color: RSColors.brandAction),
                  ),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.sm),
            ...recentSessions.take(3).map((s) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RSCard(
                  onTap: () => context.push('/progress/session/${s.id}'),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mini Squat', style: RSText.bodyStrong),
                            const SizedBox(height: 2),
                            Text('Today • 10 reps', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                          ],
                        ),
                      ),
                      Text('Score ${s.score}', style: RSText.bodyStrong.copyWith(color: RSColors.brandAction)),
                      const SizedBox(width: 8),
                      RSStatusChip.fromOutcome(RepOutcome.correct, compact: true),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _MiniTrendChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.16, size.height * 0.65),
      Offset(size.width * 0.33, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.45),
      Offset(size.width * 0.66, size.height * 0.3),
      Offset(size.width * 0.83, size.height * 0.35),
      Offset(size.width, size.height * 0.2),
    ];

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // Line
    final linePaint = Paint()
      ..color = RSColors.brandAction
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Last point dot
    final dotPaint = Paint()..color = RSColors.brandAction;
    canvas.drawCircle(points.last, 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
