// ---------------------------------------------------------------------------
// SHELL SCAFFOLD — RehabSense
// Modern floating bottom navigation bar & themed navigation drawer.
// ---------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/tokens.dart';
import '../core/widgets/rs_app_drawer.dart';

/// Wraps every tabbed screen with a floating, animated bottom navigation dock
/// and an integrated theme-aligned [RSAppDrawer].
class ShellScaffold extends StatelessWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Open the themed navigation drawer from anywhere in the app.
  static void openDrawer([BuildContext? context]) {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    } else if (context != null) {
      Scaffold.maybeOf(context)?.openDrawer();
    }
  }

  const ShellScaffold({
    super.key,
    required this.navigationShell,
    this.actionBar,
  });

  final StatefulNavigationShell navigationShell;

  /// Optional widget displayed directly above the bottom nav (e.g. a sticky
  /// action bar).
  final Widget? actionBar;

  // ── Tab definitions ──────────────────────────────────────────────────────
  static const _tabs = <_TabDef>[
    _TabDef(
      icon: LucideIcons.home,
      activeIcon: LucideIcons.home,
      label: 'Home',
    ),
    _TabDef(
      icon: LucideIcons.bookOpen,
      activeIcon: LucideIcons.bookOpen,
      label: 'Courses',
    ),
    _TabDef(
      icon: LucideIcons.barChart3,
      activeIcon: LucideIcons.trendingUp,
      label: 'Progress',
    ),
    _TabDef(
      icon: LucideIcons.user,
      activeIcon: LucideIcons.userCheck,
      label: 'Profile',
    ),
  ];

  static const double _navHeight = 66.0;

  /// Bottom scroll inset to ensure content scrolls above the floating dock.
  double scrollPaddingBottom(BuildContext context) {
    final safeArea = MediaQuery.of(context).padding.bottom;
    return (actionBar != null ? RSSizes.actionBar : 0) +
        _navHeight +
        safeArea +
        20;
  }

  void _onTap(int index) {
    HapticFeedback.selectionClick();
    if (index == navigationShell.currentIndex) {
      // Already on active branch — avoid duplicate pageKey collision
      return;
    }
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: RSColors.surfaceCanvas,
      drawer: const RSAppDrawer(),
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Optional action bar ────────────────────────────────────────
            if (actionBar != null) actionBar!,

            // ── Floating Attractive Bottom Nav Dock ────────────────────────
            Container(
              margin: EdgeInsets.fromLTRB(16, 4, 16, bottomSafe > 0 ? 6 : 14),
              height: _navHeight,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: const Color(0xFF00754A).withValues(alpha: 0.12),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0B3024).withValues(alpha: 0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final isActive = i == navigationShell.currentIndex;
                  return Expanded(
                    flex: isActive ? 2 : 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _onTap(i),
                      child: Center(
                        child: _CoolNavItem(
                          tab: _tabs[i],
                          isActive: isActive,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Private Tab Definitions & Interactive Item ────────────────────────────

class _TabDef {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _TabDef({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _CoolNavItem extends StatelessWidget {
  const _CoolNavItem({
    required this.tab,
    required this.isActive,
  });

  final _TabDef tab;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(
        horizontal: isActive ? 10 : 6,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? RSColors.brandMint.withValues(alpha: 0.85)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        border: isActive
            ? Border.all(
                color: RSColors.brandAction.withValues(alpha: 0.25),
                width: 1,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with subtle scale feedback
          AnimatedScale(
            scale: isActive ? 1.05 : 0.95,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            child: Icon(
              isActive ? tab.activeIcon : tab.icon,
              size: 20,
              color: isActive
                  ? RSColors.brandGreen
                  : const Color(0xFF6B7280),
            ),
          ),

          // Expanding active label with animated slide & fade
          if (isActive) ...[
            const SizedBox(width: 5),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                tab.label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontFamily: RSText.fontFamily,
                  color: RSColors.brandGreen,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
