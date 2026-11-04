import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

/// Interactive onboarding walkthrough guiding new users through RehabSense's
/// key clinical and computer-vision capabilities.
class AppOnboardingScreen extends StatefulWidget {
  const AppOnboardingScreen({super.key});

  @override
  State<AppOnboardingScreen> createState() => _AppOnboardingScreenState();
}

class _AppOnboardingScreenState extends State<AppOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      icon: LucideIcons.camera,
      badge: 'AI MOTION TRACKING',
      title: 'Rehab guided by\nyour camera',
      description:
          'Place your phone against a wall or water bottle. On-device pose detection tracks your joint angles and counts valid repetitions in real time.',
      highlight: 'Real-time joint angle & rep feedback',
    ),
    _OnboardingSlide(
      icon: LucideIcons.shieldCheck,
      badge: 'STRICT PRIVACY',
      title: '100% Private,\non-device processing',
      description:
          'Zero video frames or photos are ever saved, streamed, or uploaded to any cloud server. Movement metrics are calculated instantly on your phone.',
      highlight: 'Zero video or image storage',
    ),
    _OnboardingSlide(
      icon: LucideIcons.trendingUp,
      badge: 'CLINICAL PROGRESS',
      title: 'Objective recovery\nyou can measure',
      description:
          'Track Range of Motion (ROM), movement symmetry, pacing tempo, and log post-session discomfort so you and your doctor can observe steady recovery.',
      highlight: 'ROM, symmetry, and pain monitoring',
    ),
    _OnboardingSlide(
      icon: LucideIcons.stethoscope,
      badge: 'DOCTOR CONNECT',
      title: 'Connect with verified\nphysiotherapists',
      description:
          'Link with licensed clinicians to receive personalized rehabilitation prescriptions, guided exercise regimens, and certified medical feedback.',
      highlight: 'Prescriptions & clinical reviews',
    ),
  ];

  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rs_has_seen_onboarding', true);
    } catch (_) {}

    if (!mounted) return;
    context.go('/welcome');
  }

  void _nextPage() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == _slides.length - 1;

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar: Logo & Skip Action ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: RSSpacing.screenH,
                vertical: RSSpacing.xs,
              ),
              child: SizedBox(
                height: 48,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RSLogo(
                          variant: RSLogoVariant.lockup,
                          size: 34,
                        ),
                      ),
                    ),
                    if (!isLast)
                      TextButton(
                        onPressed: _completeOnboarding,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Skip',
                          style: RSText.bodySmallStrong.copyWith(
                            color: RSColors.textSecondary,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            // ── Page View Carousel (Responsive & Scroll-Safe) ───────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: RSSpacing.screenH,
                              vertical: RSSpacing.sm,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Hero Icon Circle with Mint Glow
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: RSColors.brandMint,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: RSColors.brandMint
                                            .withValues(alpha: 0.5),
                                        blurRadius: 24,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    slide.icon,
                                    size: 46,
                                    color: RSColors.brandGreen,
                                  ),
                                ),
                                const SizedBox(height: RSSpacing.lg),

                                // Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: RSColors.brandMint
                                        .withValues(alpha: 0.65),
                                    borderRadius:
                                        BorderRadius.circular(RSRadius.pill),
                                  ),
                                  child: Text(
                                    slide.badge,
                                    style: RSText.captionStrong.copyWith(
                                      color: RSColors.brandGreen,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: RSSpacing.sm),

                                // Title
                                Text(
                                  slide.title,
                                  style: RSText.headingH1,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: RSSpacing.sm),

                                // Description
                                Text(
                                  slide.description,
                                  style: RSText.bodyDefault.copyWith(
                                    color: RSColors.textSecondary,
                                    height: 1.45,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: RSSpacing.md),

                                // Highlight pill (Adaptive padding & soft wrap)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: RSSpacing.sm,
                                    vertical: RSSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: RSColors.surfaceCard,
                                    borderRadius:
                                        BorderRadius.circular(RSRadius.pill),
                                    border: Border.all(
                                      color: RSColors.borderHairline,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        LucideIcons.checkCircle2,
                                        size: 15,
                                        color: RSColors.brandGreen,
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          slide.highlight,
                                          style: RSText.captionStrong.copyWith(
                                            color: RSColors.textPrimary,
                                            fontSize: 11.5,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // ── Bottom Section: Dots + Next CTA ────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                RSSpacing.screenH,
                RSSpacing.xs,
                RSSpacing.screenH,
                RSSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      final isActive = i == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? RSColors.brandGreen
                              : RSColors.brandMint,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: RSSpacing.md),

                  // Action Button
                  RSButton.primary(
                    isLast ? 'Get started' : 'Continue',
                    _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final IconData icon;
  final String badge;
  final String title;
  final String description;
  final String highlight;

  const _OnboardingSlide({
    required this.icon,
    required this.badge,
    required this.title,
    required this.description,
    required this.highlight,
  });
}
