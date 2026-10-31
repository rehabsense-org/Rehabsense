// ---------------------------------------------------------------------------
// SHELL SCAFFOLD — RehabSense
// Bottom-nav wrapper for all tabbed screens.
// ---------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/tokens.dart';

/// Wraps every tabbed screen with a shared [BottomNavigationBar] and an
/// optional [actionBar] (e.g. "Start Session" sticky bar).
class ShellScaffold extends StatelessWidget {
  const ShellScaffold({
    super.key,
    required this.navigationShell,
    this.actionBar,
  });

  final StatefulNavigationShell navigationShell;

  /// Optional widget displayed directly above the bottom nav (e.g. a sticky
  /// action bar). When present, extra bottom padding is added to content.
  final Widget? actionBar;

  // ── Tab definitions ──────────────────────────────────────────────────────
  static const _tabs = <_TabDef>[
    _TabDef(icon: LucideIcons.home, label: 'Home'),
    _TabDef(icon: LucideIcons.bookOpen, label: 'Courses'),
    _TabDef(icon: LucideIcons.barChart3, label: 'Progress'),
    _TabDef(icon: LucideIcons.user, label: 'Profile'),
  ];

  // ── Colours ──────────────────────────────────────────────────────────────
  static const Color _activePillColor = RSColors.brandMint; // D4E9E2
  static const Color _activeIconColor = RSColors.brandGreen;
  static const Color _inactiveIconColor = Color(0xFF9E9E9E); // grey 500

  // ── Layout constants ─────────────────────────────────────────────────────
  static const double _navHeight = RSSizes.bottomNav; // 80
  static const double _pillWidth = 56;
  static const double _pillHeight = 32;

  /// How much bottom inset child content should reserve so it doesn't sit
  /// behind the nav bar + optional action bar.
  double scrollPaddingBottom(BuildContext context) {
    final safeArea = MediaQuery.of(context).padding.bottom;
    return 24 +
        (actionBar != null ? RSSizes.actionBar : 0) +
        _navHeight +
        safeArea;
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Optional action bar ────────────────────────────────────────
          if (actionBar != null) actionBar!,

          // ── Bottom nav bar ─────────────────────────────────────────────
          Container(
            height: _navHeight + bottomSafe,
            padding: EdgeInsets.only(bottom: bottomSafe),
            decoration: BoxDecoration(
              color: RSColors.surfaceCard, // white
              boxShadow: RSShadows.nav,
            ),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final isActive = i == navigationShell.currentIndex;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTap(i),
                    child: _NavItem(
                      tab: _tabs[i],
                      isActive: isActive,
                      activeIconColor: _activeIconColor,
                      inactiveIconColor: _inactiveIconColor,
                      activePillColor: _activePillColor,
                      pillWidth: _pillWidth,
                      pillHeight: _pillHeight,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Private helpers ──────────────────────────────────────────────────────────

class _TabDef {
  final IconData icon;
  final String label;
  const _TabDef({required this.icon, required this.label});
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.activeIconColor,
    required this.inactiveIconColor,
    required this.activePillColor,
    required this.pillWidth,
    required this.pillHeight,
  });

  final _TabDef tab;
  final bool isActive;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final Color activePillColor;
  final double pillWidth;
  final double pillHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pill indicator + icon
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: pillWidth,
          height: pillHeight,
          decoration: BoxDecoration(
            color: isActive ? activePillColor : Colors.transparent,
            borderRadius: BorderRadius.circular(RSRadius.pill),
          ),
          alignment: Alignment.center,
          child: Icon(
            tab.icon,
            size: 22,
            color: isActive ? activeIconColor : inactiveIconColor,
          ),
        ),

        // Label — only shown when active
        if (isActive) ...[
          const SizedBox(height: 2),
          Text(
            tab.label,
            style: RSText.captionStrong.copyWith(color: activeIconColor),
          ),
        ],
      ],
    );
  }
}
