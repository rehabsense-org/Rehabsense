import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/router.dart';
import 'app/theme/app_theme.dart';
import 'core/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Supabase safely with a strict timeout so app launch is never blocked
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    ).timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('Supabase initialization notice (offline or timeout): $e');
  }

  // Launch app immediately — camera permissions are handled in session setup
  // and onboarding to avoid blocking OS window drawing with a white screen.
  runApp(const RehabSenseApp());
}

class RehabSenseApp extends StatelessWidget {
  const RehabSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RehabSense',
      theme: buildAppTheme(),
      routerConfig: appRouter,
    );
  }
}
