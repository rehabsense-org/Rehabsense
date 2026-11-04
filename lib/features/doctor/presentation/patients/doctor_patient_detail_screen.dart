import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorPatientDetailScreen extends StatelessWidget {
  final String patientId;

  const DoctorPatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Patient Overview', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Assign exercise',
          () => context.push('/doctor/patients/$patientId/assign'),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Patient Profile Header Card ───────────────────────────
            RSCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: RSColors.brandMint,
                    child: Text('AM', style: TextStyle(color: RSColors.brandGreen, fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alex Mercer', style: RSText.headingH2),
                        const SizedBox(height: 2),
                        Text('Active patient · Connected 12 days ago',
                            style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                        const SizedBox(height: 6),
                        const RSStatusChip(
                          type: RSStatusChipType.correct,
                          customLabel: 'Right Knee Rehabilitation',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── KPI Stats Row ─────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: RSStatTile(
                    label: 'Adherence',
                    value: '90%',
                    delta: '3/3 this wk',
                    deltaPositive: true,
                  ),
                ),
                const SizedBox(width: RSSpacing.sm),
                Expanded(
                  child: RSStatTile(
                    label: 'Movement score',
                    value: '86',
                    delta: '+4 pts',
                    deltaPositive: true,
                  ),
                ),
                const SizedBox(width: RSSpacing.sm),
                Expanded(
                  child: RSStatTile(
                    label: 'Pain level',
                    value: '5/10',
                    delta: 'Moderate',
                    deltaPositive: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Sub-Navigation Section ────────────────────────────────
            Text('PATIENT RECORDS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.calendarCheck,
                  title: 'Prescribed Exercise Plan',
                  subtitle: '2 active assignments • 1 completed',
                  onTap: () => context.push('/doctor/patients/$patientId/plan'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.activity,
                  title: 'Session History & Reviews',
                  subtitle: '4 completed sessions • 1 pending feedback',
                  onTap: () => context.push('/doctor/patients/$patientId/sessions'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.clipboardList,
                  title: 'Condition Intake & Safety',
                  subtitle: 'Initial patient form, reported symptoms, disconnect',
                  onTap: () => context.push('/doctor/patients/$patientId/condition'),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Clinical Disclaimer ───────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RSColors.surfaceCeramic,
                borderRadius: BorderRadius.circular(RSRadius.card),
              ),
              child: Text(
                'RehabSense is a guidance tool. It does not diagnose or replace your physiotherapist.',
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

