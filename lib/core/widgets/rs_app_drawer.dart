import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../data/repositories/repositories.dart';
import '../tokens.dart';
import 'rs_button.dart';
import 'rs_dialog.dart';
import 'rs_logo.dart';

/// Full-featured, theme-aligned navigation drawer for RehabSense.
class RSAppDrawer extends StatelessWidget {
  const RSAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthRepository().currentUser;
    final userName = user?.name ?? 'Alex Rehabber';
    final userEmail = (user?.email.isNotEmpty == true) ? user!.email : 'alex@rehab.test';
    final userInitials = userName.trim().isNotEmpty
        ? userName.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase()
        : 'AR';

    return Drawer(
      backgroundColor: RSColors.brandDeep,
      surfaceTintColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top Header with Logo & Close ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: RSLogo(
                      variant: RSLogoVariant.lockup,
                      onDark: true,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, color: Colors.white70, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close menu',
                  ),
                ],
              ),
            ),

            // ── User Profile Card ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: RSRadius.cardBR,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: RSColors.brandMint,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        userInitials,
                        style: const TextStyle(
                          color: RSColors.brandGreen,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: RSText.bodyStrong.copyWith(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userEmail,
                            style: RSText.caption.copyWith(color: RSColors.textOnDarkSoft),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: RSColors.brandAction.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(RSRadius.pill),
                        border: Border.all(color: const Color(0xFF00E5A8).withValues(alpha: 0.5)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.checkCircle, size: 10, color: Color(0xFF00E5A8)),
                          SizedBox(width: 4),
                          Text(
                            'Active',
                            style: TextStyle(
                              color: Color(0xFF00E5A8),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Scrollable Menu Options ─────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                children: [
                  _buildSectionHeader('CORE NAVIGATION'),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.home,
                    title: 'Home Dashboard',
                    route: '/home',
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.bookOpen,
                    title: 'Exercise Courses',
                    route: '/courses',
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.barChart3,
                    title: 'Recovery & Progress',
                    route: '/progress',
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.user,
                    title: 'My Profile',
                    route: '/profile',
                  ),

                  const SizedBox(height: 10),
                  _buildSectionHeader('CLINICAL & SENSING'),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.stethoscope,
                    title: 'Connect with Doctor',
                    route: '/connect',
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.clipboardList,
                    title: 'Prescribed Regimens',
                    route: '/courses/prescribed',
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.camera,
                    title: 'Camera Setup Guide',
                    route: '/setup/camera-help',
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.shieldCheck,
                    title: 'Safety Precautions',
                    route: '/setup/safety',
                  ),

                  const SizedBox(height: 10),
                  _buildSectionHeader('PREFERENCES & SUPPORT'),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.bell,
                    title: 'Notification Preferences',
                    route: '/profile/notifications',
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.settings,
                    title: 'Settings',
                    route: '/profile/settings',
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.helpCircle,
                    title: 'Help & FAQ',
                    route: '/profile/help',
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.lock,
                    title: 'Privacy & Data Protection',
                    route: '/profile/privacy',
                  ),
                  _buildDrawerTile(
                    context: context,
                    icon: LucideIcons.info,
                    title: 'About RehabSense',
                    route: '/profile/about',
                  ),
                ],
              ),
            ),

            // ── Footer: Log Out & Compliance ────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
              ),
              child: Column(
                children: [
                  RSButton.outlineOnDark(
                    'Log out',
                    () => _showLogoutDialog(context),
                    size: RSButtonSize.medium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'RehabSense v2.0 • On-Device AI Engine',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF00E5A8).withValues(alpha: 0.75),
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildDrawerTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        dense: true,
        leading: Icon(icon, color: const Color(0xFFD4E9E2), size: 20),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          LucideIcons.chevronRight,
          color: Colors.white.withValues(alpha: 0.25),
          size: 16,
        ),
        onTap: () {
          Navigator.of(context).pop(); // Close drawer
          final currentUri = GoRouterState.of(context).uri.toString();
          if (currentUri != route) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.go(route);
              }
            });
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: RSColors.overlayScrim,
      builder: (ctx) => RSDialog(
        icon: LucideIcons.logOut,
        iconBgColor: RSColors.statusErrorTint,
        iconColor: RSColors.statusError,
        title: 'Log out of RehabSense?',
        body: 'Your rehabilitation progress and history remain safely saved to your account.',
        primaryButtonLabel: 'Log out',
        primaryIsDestructive: true,
        onPrimaryPressed: () async {
          Navigator.of(ctx).pop(); // Close dialog
          await AuthRepository().logout();
          if (context.mounted) {
            context.go('/login');
          }
        },
        secondaryButtonLabel: 'Cancel',
      ),
    );
  }
}
