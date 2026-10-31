import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';

class PauseScreen extends StatelessWidget {
  final String exerciseId;

  const PauseScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.brandDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.eyeOff,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: RSSpacing.md),
              Text(
                'Camera paused • Preview hidden',
                style: RSText.caption.copyWith(color: RSColors.textOnDarkSoft),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.lg),
              Text(
                'Paused',
                style: RSText.displayLarge.copyWith(color: RSColors.textOnDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: RSSpacing.xl),

              // 3-stat strip (Reps, Time, Set)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: RSRadius.cardBR,
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol('REPS', '4 / 10'),
                    _buildDivider(),
                    _buildStatCol('TIME', '01:42'),
                    _buildDivider(),
                    _buildStatCol('SET', '1 of 2'),
                  ],
                ),
              ),

              const Spacer(),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: RSColors.brandDeep,
                  minimumSize: const Size(double.infinity, RSSizes.buttonLarge),
                  shape: const StadiumBorder(),
                  textStyle: RSText.buttonLarge,
                ),
                child: const Text('Resume'),
              ),
              const SizedBox(height: RSSpacing.sm),
              OutlinedButton(
                onPressed: () {
                  context.pushReplacement('/session/$exerciseId/summary');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, RSSizes.buttonLarge),
                  shape: const StadiumBorder(),
                  side: const BorderSide(color: Colors.white, width: 1.5),
                  textStyle: RSText.buttonLarge,
                ),
                child: const Text('End session'),
              ),
              const SizedBox(height: RSSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String value) {
    return Column(
      children: [
        Text(label, style: RSText.labelOverline.copyWith(color: RSColors.brandMint, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: RSText.headingH3.copyWith(color: Colors.white)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withOpacity(0.2),
    );
  }
}
