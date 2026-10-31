import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/seed/seed_data.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text('Courses', style: RSText.headingH1.copyWith(color: RSColors.textPrimary)),
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH, vertical: 8),
          children: [
            Text(
              'Select a physiotherapy programme to begin your movement sessions.',
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: RSSpacing.lg),
            ...seedCourses.map((c) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RSCard(
                  onTap: () => context.push('/courses/${c.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: RSColors.brandMint,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.activity,
                              size: 28,
                              color: RSColors.brandGreen,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name, style: RSText.headingH3),
                                const SizedBox(height: 2),
                                Text(
                                  '${c.level} • 5 exercises • ~15 mins',
                                  style: RSText.caption.copyWith(color: RSColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        c.description,
                        style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '2 of 5 completed',
                            style: RSText.captionStrong.copyWith(color: RSColors.brandAction),
                          ),
                          Text('40%', style: TextStyle(color: RSColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const RSProgressBar(value: 0.4, height: 6),
                      const SizedBox(height: 16),
                      RSButton.primary(
                        'Continue course',
                        () => context.push('/courses/${c.id}'),
                        size: RSButtonSize.medium,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
