import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: RSColors.overlayScrim,
      builder: (ctx) => RSDialog(
        icon: LucideIcons.logOut,
        iconBgColor: RSColors.surfaceCeramic,
        iconColor: RSColors.textPrimary,
        title: 'Log out?',
        body: 'Your rehabilitation progress and history remain safely saved to your account.',
        primaryButtonLabel: 'Log out',
        primaryIsDestructive: false,
        onPrimaryPressed: () async {
          await AuthRepository().logout();
          if (context.mounted) {
            context.go('/login');
          }
        },
        secondaryButtonLabel: 'Cancel',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthRepository().currentUser;
    final displayName = user?.name ?? 'Alex Rehabber';
    final displayEmail = user?.email.isNotEmpty == true ? user!.email : 'alex@rehab.test';
    final initials = displayName.trim().isNotEmpty
        ? displayName.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase()
        : 'AR';
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text('Profile', style: RSText.headingH1.copyWith(color: RSColors.textPrimary)),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // User card: Avatar 72, name, email, Edit profile
            RSCard(
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: RSColors.brandMint,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: RSText.headingH2.copyWith(color: RSColors.brandGreen, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName, style: RSText.headingH3),
                        const SizedBox(height: 2),
                        Text(
                          displayEmail,
                          style: RSText.caption.copyWith(color: RSColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: RSColors.statusSuccessTint,
                            borderRadius: BorderRadius.circular(RSRadius.pill),
                          ),
                          child: Text(
                            'Verified',
                            style: RSText.captionStrong.copyWith(color: RSColors.statusSuccess, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RSButton.secondary(
                    'Edit',
                    () => context.push('/profile/edit'),
                    size: RSButtonSize.medium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // Sync status row
            RSCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(LucideIcons.cloud, color: RSColors.statusSuccess, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All sessions synchronized with cloud',
                      style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // Menu card: Settings, Notifications, Help & FAQ, Privacy & data, About
            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.sliders,
                  title: 'Settings',
                  subtitle: 'Audio, haptics & camera options',
                  onTap: () => context.push('/profile/settings'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.bell,
                  title: 'Notification preferences',
                  subtitle: 'Reminders & weekly reports',
                  onTap: () => context.push('/profile/notifications'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.helpCircle,
                  title: 'Help & FAQ',
                  subtitle: 'Camera tips & guides',
                  onTap: () => context.push('/profile/help'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.shield,
                  title: 'Privacy & data',
                  subtitle: 'Export data & account options',
                  onTap: () => context.push('/profile/privacy'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.info,
                  title: 'About RehabSense',
                  subtitle: 'Version 2.0 • Team & Licences',
                  onTap: () => context.push('/profile/about'),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.lg),

            // Log out separate card
            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.logOut,
                  title: 'Log out',
                  danger: true,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
