import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../app/auth_notifier.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'Good morning, Doctor',
          style: RSText.headingH3.copyWith(color: RSColors.brandGreen),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () => context.push('/doctor/notifications'),
            color: RSColors.brandGreen,
          ),
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            onPressed: () async {
              await AuthNotifier.instance.signOut();
              if (context.mounted) context.go('/welcome');
            },
            color: RSColors.textSecondary,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: RSSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: RSStatTile(
                      label: 'New requests',
                      value: '3',
                      delta: '3 waiting',
                      deltaPositive: true,
                    ),
                  ),
                  const SizedBox(width: RSSpacing.md),
                  Expanded(
                    child: RSStatTile(
                      label: 'Active patients',
                      value: '12',
                      delta: '+2 this week',
                      deltaPositive: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: RSStatTile(
                      label: 'Pain alerts',
                      value: '1',
                      delta: 'Action needed',
                      deltaPositive: false,
                    ),
                  ),
                  const SizedBox(width: RSSpacing.md),
                  Expanded(
                    child: RSStatTile(
                      label: 'Inactive 3d+',
                      value: '2',
                      delta: 'Follow up',
                      deltaPositive: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.md),

              // ── Priority Pain Alert ──────────────────────────────────
              RSCard(
                color: RSColors.statusErrorTint,
                onTap: () => context.push('/doctor/patients/patient_003/sessions'),
                child: Row(
                  children: [
                    const Icon(LucideIcons.alertTriangle, color: RSColors.statusError, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'High Pain Alert: Marcus Vance (8/10)',
                            style: RSText.bodySmallStrong.copyWith(color: RSColors.statusError),
                          ),
                          Text(
                            'Reported sharp discomfort during shoulder mobility session.',
                            style: RSText.caption.copyWith(color: RSColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, color: RSColors.statusError, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.lg),

              // ── Quick Navigation Cards ───────────────────────────────
              Text('CLINICAL WORKSPACE', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
              const SizedBox(height: RSSpacing.xs),
              RSMenuCard(
                items: [
                  RSMenuRowItem(
                    title: 'Review Patient Requests',
                    subtitle: '2 new patient connection requests pending review',
                    icon: LucideIcons.userPlus,
                    onTap: () => context.push('/doctor/requests'),
                  ),
                  RSMenuRowItem(
                    title: 'My Patients Caseload',
                    subtitle: '12 active patients • Adherence & prescribed plans',
                    icon: LucideIcons.users,
                    onTap: () => context.push('/doctor/patients'),
                  ),
                  RSMenuRowItem(
                    title: 'Exercise Library & Builder',
                    subtitle: 'Manage rehab poses and test custom movements',
                    icon: LucideIcons.activity,
                    onTap: () => context.push('/doctor/exercises'),
                  ),
                  RSMenuRowItem(
                    title: 'Clinical Profile & Settings',
                    subtitle: 'Practice credentials, verification, and preferences',
                    icon: LucideIcons.userCheck,
                    onTap: () => context.push('/doctor/profile'),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.lg),

              // Canonical disclaimer
              Text(
                'RehabSense is a guidance tool. It does not diagnose or replace your clinical judgment.',
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
