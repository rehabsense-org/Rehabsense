import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../app/auth_notifier.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'Staff Console',
          style: RSText.headingH3.copyWith(color: RSColors.brandGreen),
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.bell),
            onPressed: () => context.push('/admin/notifications'),
            color: RSColors.brandGreen,
          ),
          IconButton(
            icon: Icon(LucideIcons.logOut),
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
                      label: 'Pending apps',
                      value: '4',
                      delta: 'Review waiting',
                      deltaPositive: false,
                    ),
                  ),
                  const SizedBox(width: RSSpacing.md),
                  Expanded(
                    child: RSStatTile(
                      label: 'Active doctors',
                      value: '18',
                      delta: 'Verified',
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
                      label: 'Patients',
                      value: '246',
                      delta: '+12 this month',
                      deltaPositive: true,
                    ),
                  ),
                  const SizedBox(width: RSSpacing.md),
                  Expanded(
                    child: RSStatTile(
                      label: 'Public exercises',
                      value: '12',
                      delta: 'In library',
                      deltaPositive: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.lg),
              RSCard(
                padding: const EdgeInsets.all(RSSpacing.md),
                child: Row(
                  children: [
                    Icon(LucideIcons.shieldAlert, color: RSColors.brandGreen, size: 28),
                    const SizedBox(width: RSSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Privacy Boundary Enforced', style: RSText.bodyStrong),
                          const SizedBox(height: 2),
                          Text(
                            'Admins cannot access patient sessions, pain logs, or health conditions.',
                            style: RSText.caption.copyWith(color: RSColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.lg),

              // ── Pending Doctor Applications ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PENDING APPLICATIONS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                  InkWell(
                    onTap: () => context.push('/admin/applications'),
                    child: Text('See all', style: RSText.captionStrong.copyWith(color: RSColors.brandGreen)),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.xs),
              RSCard(
                onTap: () => context.push('/admin/applications/app_001'),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: RSColors.brandMint,
                      child: Text('SK', style: TextStyle(color: RSColors.brandGreen, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dr. Sara Khan', style: RSText.bodyStrong),
                          Text('Physiotherapist · Submitted today', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                        ],
                      ),
                    ),
                    const RSStatusChip(
                      type: RSStatusChipType.incomplete,
                      customLabel: 'Pending',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RSCard(
                onTap: () => context.push('/admin/applications/app_002'),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: RSColors.brandMint,
                      child: Text('OS', style: TextStyle(color: RSColors.brandGreen, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dr. Omar Sheikh', style: RSText.bodyStrong),
                          Text('Sports Physio · Submitted 2d ago', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                        ],
                      ),
                    ),
                    const RSStatusChip(
                      type: RSStatusChipType.incomplete,
                      customLabel: 'Pending',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.lg),

              // ── Quick Links ──────────────────────────────────────────
              Text('QUICK LINKS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
              const SizedBox(height: RSSpacing.xs),
              RSMenuCard(
                items: [
                  RSMenuRowItem(
                    icon: LucideIcons.userCheck,
                    title: 'Manage doctors',
                    subtitle: 'Doctor accounts, status & clinical oversight',
                    onTap: () => context.push('/admin/doctors'),
                  ),
                  RSMenuRowItem(
                    icon: LucideIcons.users,
                    title: 'Manage patients',
                    subtitle: 'Account status only (no clinical data)',
                    onTap: () => context.push('/admin/patients'),
                  ),
                  RSMenuRowItem(
                    icon: LucideIcons.activity,
                    title: 'Exercise library',
                    subtitle: 'Public poses & movement tracking configs',
                    onTap: () => context.push('/admin/exercises'),
                  ),
                  RSMenuRowItem(
                    icon: LucideIcons.fileText,
                    title: 'Audit log',
                    subtitle: 'Immutable record of staff actions',
                    onTap: () => context.push('/admin/audit'),
                  ),
                  RSMenuRowItem(
                    icon: LucideIcons.shield,
                    title: 'Admin profile',
                    subtitle: 'Security, password, notifications',
                    onTap: () => context.push('/admin/profile'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
