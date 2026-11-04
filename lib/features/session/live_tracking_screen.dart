import 'package:flutter/material.dart';
import 'camera_setup_screen.dart';

class LiveTrackingScreen extends StatelessWidget {
  final String exerciseId;

  const LiveTrackingScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return CameraSetupScreen(
      exerciseId: exerciseId,
      initialIsExercising: true,
    );
  }
}
