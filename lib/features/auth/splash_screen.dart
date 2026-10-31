import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      // Per spec A 5.6: if not authenticated -> /welcome
      context.go('/welcome');
    });
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
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: RSColors.brandMint.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.activity,
                size: 42,
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
