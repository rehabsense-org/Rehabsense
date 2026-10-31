import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  final List<Map<String, String>> _faqs = const [
    {
      'q': "Why won't the camera detect my body?",
      'a':
          'Make sure you stand approximately 2 meters away from your phone so that your head and feet are in the camera view. Avoid backlighting from direct windows behind you.',
    },
    {
      'q': 'How are repetitions counted?',
      'a':
          'RehabSense computes the geometric angle between joints in real-time. For a squat, it checks when your knee angle bends past the target threshold and returns up smoothly.',
    },
    {
      'q': 'Why was my rep marked as "Incorrect"?',
      'a':
          'A rep is marked incorrect if the required range of motion was insufficient, or if form rules (such as knee alignment or back posture) were violated during the repetition.',
    },
    {
      'q': 'Is my camera video ever recorded or saved?',
      'a':
          'Never. All MediaPipe pose detection runs locally on your device in real-time. Only numerical angle measurements and rep counts are stored.',
    },
    {
      'q': 'What does "Incomplete" mean?',
      'a':
          'If you exit an exercise early or tracking is lost before completing a full rep cycle, the remaining repetitions are stored as Incomplete to preserve data integrity.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: const Text('Help & FAQ'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // Camera Tips Card
            Container(
              padding: const EdgeInsets.all(RSSpacing.md),
              decoration: BoxDecoration(
                color: RSColors.brandMint,
                borderRadius: RSRadius.cardBR,
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.camera, size: 28, color: RSColors.brandGreen),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Camera Setup Best Practices', style: RSText.bodyStrong.copyWith(color: RSColors.brandGreen)),
                        const SizedBox(height: 2),
                        Text(
                          'Place phone at hip height, 2 meters away with full body in frame.',
                          style: RSText.caption.copyWith(color: RSColors.textMutedGreen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.xl),

            Text('FREQUENTLY ASKED QUESTIONS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: 8),

            RSCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: List.generate(_faqs.length, (i) {
                  final faq = _faqs[i];
                  return Column(
                    children: [
                      ExpansionTile(
                        title: Text(faq['q']!, style: RSText.bodyStrong),
                        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        children: [
                          Text(
                            faq['a']!,
                            style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                          ),
                        ],
                      ),
                      if (i < _faqs.length - 1)
                        const Divider(height: 1),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: RSSpacing.xl),

            // Contact Card
            Container(
              padding: const EdgeInsets.all(RSSpacing.lg),
              decoration: BoxDecoration(
                color: RSColors.brandDeep,
                borderRadius: RSRadius.cardBR,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Need more help?', style: RSText.headingH3.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(
                    'Our support team and clinical advisors are here to assist you.',
                    style: RSText.bodySmall.copyWith(color: RSColors.textOnDarkSoft),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening email to support@rehabsense.health')),
                      );
                    },
                    icon: const Icon(LucideIcons.mail, size: 18),
                    label: const Text('Contact support'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: RSColors.brandDeep,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
