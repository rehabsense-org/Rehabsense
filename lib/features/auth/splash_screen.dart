import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../app/auth_notifier.dart';
import '../../core/tokens.dart';

// ---------------------------------------------------------------------------
// SplashScreen — Initialises auth, waits minimum 1.6 s, then routes.
// Guaranteed to navigate regardless of Supabase errors.
// ---------------------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initAndRoute();
  }

  Future<void> _initAndRoute() async {
    final startTime = DateTime.now();

    // Always initialize — catch everything so the splash never hangs
    try {
      await AuthNotifier.instance.initialize();
    } catch (_) {
      // Supabase unreachable → treat as unauthenticated
    }

    // Ensure minimum splash duration of 1.6 s
    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    final remaining = 1600 - elapsed;
    if (remaining > 0) {
      await Future.delayed(Duration(milliseconds: remaining));
    }

    if (!mounted) return;

    _navigate();
  }

  void _navigate() {
    final auth = AuthNotifier.instance;

    // Not signed in → welcome
    if (!auth.isAuthenticated) {
      context.go('/welcome');
      return;
    }

    // Signed in but disabled
    if (auth.isAccountDisabled) {
      context.go('/account-inactive');
      return;
    }

    // Route by role
    switch (auth.role) {
      case UserRole.doctor:
        if (auth.accountStatus == AccountStatus.pendingVerification) {
          context.go('/doctor/application-status');
        } else {
          context.go('/doctor/home');
        }
      case UserRole.admin:
        context.go('/admin/dashboard');
      case UserRole.patient:
      default:
        context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.brandDeep,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: RSColors.brandMint.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.activity,
                size: 44,
                color: RSColors.brandMint,
              ),
            ),
            const SizedBox(height: RSSpacing.md),
            Text(
              'RehabSense',
              style: RSText.displayMedium.copyWith(
                color: RSColors.textOnDark,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: RSSpacing.sm),
            Text(
              'Rehab, guided by your camera',
              style: RSText.bodyDefault.copyWith(
                color: RSColors.textOnDarkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
