import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mp_pose_landmarker/flutter_mp_pose_landmarker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/router.dart';
import 'app/theme/app_theme.dart';
import 'core/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
  }

  // Camera permissions
  try {
    final granted = await PoseLandmarker.checkCameraPermission();
    if (!granted) {
      await PoseLandmarker.requestCameraPermission();
    }
  } catch (e) {
    debugPrint('Camera permission check: $e');
  }

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
