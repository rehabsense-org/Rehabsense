import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';
import 'admin_logout_dialog.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

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
        title: Text('Staff Profile', style: RSText.bodyStrong),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Admin Avatar Card ─────────────────────────────────────
            RSCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: RSColors.brandMint,
                    child: Text(
                      'AD',
                      style: TextStyle(
                        color: RSColors.brandGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Operations Administrator', style: RSText.headingH3),
                        const SizedBox(height: 2),
                        Text(
                          'admin@rehabsense.test',
                          style: RSText.caption.copyWith(color: RSColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        const RSStatusChip(
                          type: RSStatusChipType.correct,
                          customLabel: 'System Administrator',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Admin Menu Items ──────────────────────────────────────
            Text('STAFF CONSOLE TOOLS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.bell,
                  title: 'Notifications',
                  subtitle: 'Pending doctor reviews & resubmissions',
                  onTap: () => context.push('/admin/notifications'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.fileText,
                  title: 'Audit log',
                  subtitle: 'Immutable record of staff actions',
                  onTap: () => context.push('/admin/audit'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.lock,
                  title: 'Change password',
                  subtitle: 'Update staff security credentials',
                  onTap: () => context.push('/admin/change-password'),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Sign Out ──────────────────────────────────────────────
            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.logOut,
                  title: 'Log out',
                  danger: true,
                  onTap: () => AdminLogoutDialog.show(context),
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

