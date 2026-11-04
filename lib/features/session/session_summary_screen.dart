import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/seed/seed_data.dart';
import 'pain_alert_sheet.dart';

class SessionSummaryScreen extends StatefulWidget {
  final String exerciseId;

  const SessionSummaryScreen({super.key, required this.exerciseId});

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen> {
  bool _saved = false;
  final int _score = 86;
  final bool _isPersonalBest = true;
  double _painLevel = 2.0;
  final TextEditingController _commentController = TextEditingController();
  bool _alertShown = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onPainChanged(double val) {
    setState(() => _painLevel = val);
    if (val >= 7.0 && !_alertShown) {
      _alertShown = true;
      PainAlertSheet.show(context, painLevel: val.round());
    }
  }

  void _showLeaveSheet() {
    if (_saved) {
      context.go('/home');
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: RSColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: RSColors.statusWarningTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.alertTriangle, color: RSColors.statusWarningInk),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Leave without saving?',
              style: RSText.headingH3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your movement metrics and score from this session will be lost if you discard.',
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            RSButton.primary(
              'Save and leave',
              () {
                Navigator.pop(ctx);
                context.go('/home');
              },
            ),
            const SizedBox(height: 8),
            RSButton.destructiveOutline(
              'Discard result',
              () {
                Navigator.pop(ctx);
                context.go('/home');
              },
            ),
            const SizedBox(height: 4),
            RSButton.text(
              'Stay',
              () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _saveResult() {
    setState(() => _saved = true);
    context.pushReplacement('/session/${widget.exerciseId}/saved');
  }

  @override
  Widget build(BuildContext context) {
    final exercise = seedExercises.firstWhere(
      (e) => e.id == widget.exerciseId,
      orElse: () => seedExercises.first,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showLeaveSheet();
        }
      },
      child: Scaffold(
        backgroundColor: RSColors.surfaceCanvas,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Session summary'),
          actions: [
            RSIconButton.plain(
              icon: LucideIcons.x,
              onPressed: _showLeaveSheet,
              semanticLabel: 'Close',
            ),
          ],
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
                'Save result',
                _saveResult,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RSButton.secondary(
                      'Retry',
                      () => context.pushReplacement('/session/${widget.exerciseId}/checklist'),
                      size: RSButtonSize.medium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RSButton.secondary(
                      'Next exercise',
                      () => context.pushReplacement('/courses/knee_rehab/exercise/knee_straight_leg_raise'),
                      size: RSButtonSize.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(RSSpacing.screenH),
            children: [
              // ── Milestone Banner (Gold rule 5: ONLY on personal best) ──
              if (_isPersonalBest) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: RSColors.accentGoldWash,
                    borderRadius: RSRadius.cardBR,
                    border: Border.all(color: RSColors.accentGold),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.award, color: RSColors.accentGoldDeep, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal best score!',
                              style: RSText.bodyStrong.copyWith(color: RSColors.accentGoldDeep),
                            ),
                            Text(
                              'You beat your previous score by 4 points.',
                              style: RSText.caption.copyWith(color: RSColors.accentGoldDeep),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: RSSpacing.md),
              ],

              // ── Circular Score Ring ──────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Text(exercise.name, style: RSText.headingH3),
                    const SizedBox(height: 2),
                    Text('10 reps completed', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                    const SizedBox(height: 12),
                    RSScoreRing(
                      score: _score,
                      size: 150,
                      isPersonalBest: _isPersonalBest,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.lg),

              // ── Outcome Trio Tiles ───────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _buildOutcomeTile(
                      label: 'Correct',
                      count: 7,
                      color: RSColors.statusSuccess,
                      bgColor: RSColors.statusSuccessTint,
                      icon: LucideIcons.checkCircle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOutcomeTile(
                      label: 'Incorrect',
                      count: 2,
                      color: RSColors.statusError,
                      bgColor: RSColors.statusErrorTint,
                      icon: LucideIcons.xCircle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOutcomeTile(
                      label: 'Incomplete',
                      count: 1,
                      color: RSColors.statusWarningInk,
                      bgColor: RSColors.statusWarningTint,
                      icon: LucideIcons.minusCircle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.lg),

              // ── Post-Session Pain Rating ─────────────────────────────
              RSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PAIN ASSESSMENT', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                    const SizedBox(height: 12),
                    RSSlider(
                      title: 'Pain level during exercise',
                      value: _painLevel,
                      onChanged: _onPainChanged,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      minLabel: '0 - No pain',
                      maxLabel: '10 - Severe',
                    ),
                    const SizedBox(height: 16),
                    RSInput(
                      label: 'Notes / Comments (Optional)',
                      hintText: 'Describe how your joint felt or any discomfort...',
                      controller: _commentController,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.lg),

              // ── Metrics Card ─────────────────────────────────────────
              RSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SESSION METRICS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                    const SizedBox(height: 12),
                    _buildMetricRow('Duration', '02:45'),
                    const Divider(height: 16),
                    _buildMetricRow('Average ROM', '88° (Target 90°)'),
                    const Divider(height: 16),
                    _buildMetricRow('Tempo', '2.8s per rep'),
                    const Divider(height: 16),
                    _buildMetricRow('Left/Right Symmetry', '94% balanced'),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.lg),

              // ── Tips For Next Time ───────────────────────────────────
              RSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TIPS FOR NEXT TIME', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                    const SizedBox(height: 10),
                    _buildTipBullet('Keep your knees aligned with your second toe during squats.'),
                    const SizedBox(height: 6),
                    _buildTipBullet('Maintain an upright posture at the bottom of the movement.'),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.lg),

              // ── Disclaimer per spec rule 3 ───────────────────────────
              Text(
                'RehabSense is a guidance tool. It does not diagnose or replace your physiotherapist.',
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutcomeTile({
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: RSRadius.cardBR,
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 6),
          Text('$count', style: RSText.headingH3.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label, style: RSText.captionStrong.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary)),
        Text(value, style: RSText.bodyStrong),
      ],
    );
  }

  Widget _buildTipBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(LucideIcons.check, size: 14, color: RSColors.brandAction),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: RSText.bodySmall)),
      ],
    );
  }
}
