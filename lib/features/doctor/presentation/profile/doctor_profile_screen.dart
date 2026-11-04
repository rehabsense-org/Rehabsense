import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';
import '../settings/doctor_logout_dialog.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text('Doctor Profile', style: RSText.bodyStrong),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Doctor Info Header Card ───────────────────────────────
            RSCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: RSColors.brandMint,
                    child: Text(
                      'SK',
                      style: TextStyle(
                        color: RSColors.brandGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dr. Sara Khan', style: RSText.headingH3),
                        const SizedBox(height: 2),
                        Text(
                          'Physiotherapist · City Rehab Clinic',
                          style: RSText.caption.copyWith(color: RSColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        const RSStatusChip(
                          type: RSStatusChipType.correct,
                          customLabel: 'Listed & Verified',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Management Navigation ─────────────────────────────────
            Text('ACCOUNT & CLINICAL PROFILE', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.userCheck,
                  title: 'Edit profile and expertise',
                  subtitle: 'Bio, clinical specialties, and patient capacity',
                  onTap: () => context.push('/doctor/profile/edit'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.fileText,
                  title: 'Update credentials',
                  subtitle: 'License number, degree certificates (re-review)',
                  onTap: () => context.push('/doctor/profile/credentials'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.bell,
                  title: 'Notifications',
                  subtitle: 'Clinical alerts, connection requests',
                  onTap: () => context.push('/doctor/notifications'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.settings,
                  title: 'Settings',
                  subtitle: 'Security, password, notification preferences',
                  onTap: () => context.push('/doctor/settings'),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Sign Out Section ──────────────────────────────────────
            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.logOut,
                  title: 'Log out',
                  danger: true,
                  onTap: () => DoctorLogoutDialog.show(context),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

