import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/auth_notifier.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

// ---------------------------------------------------------------------------
// SplashScreen — Initialises auth, waits minimum 1.6 s, then routes.
// Guaranteed to navigate safely to Onboarding, Welcome, or user's portal.
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
      await AuthNotifier.instance.initialize().timeout(const Duration(seconds: 2));
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

    await _navigate();
  }

  Future<void> _navigate() async {
    final auth = AuthNotifier.instance;

    // Not signed in → check if onboarding has been seen
    if (!auth.isAuthenticated) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final hasSeenOnboarding = prefs.getBool('rs_has_seen_onboarding') ?? false;
        if (!hasSeenOnboarding) {
          if (mounted) context.go('/onboarding');
          return;
        }
      } catch (_) {}

      if (mounted) context.go('/welcome');
      return;
    }

    // Signed in but disabled
    if (auth.isAccountDisabled) {
      if (mounted) context.go('/account-inactive');
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
            const RSLogo(
              variant: RSLogoVariant.mark,
              size: 96,
              onDark: true,
            ),
            const SizedBox(height: RSSpacing.lg),
            Text(
              'RehabSense',
              style: RSText.displayMedium.copyWith(
                color: RSColors.textOnDark,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: RSSpacing.xs),
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

