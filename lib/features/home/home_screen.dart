import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';
import '../../data/seed/seed_data.dart';
import '../../domain/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final sessionRepo = SessionRepository();
  final notifRepo = NotificationRepository();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _buildSkeletonState();
    }

    final recentSessions = sessionRepo.getRecentSessions();
    final hasUnreadNotifs = notifRepo.hasUnread;
    final user = AuthRepository().currentUser;
    final userName = user?.name.split(' ').first ?? 'Alex';
    final userInitials = (user?.name ?? 'Alex Rehabber')
        .trim()
        .split(' ')
        .map((p) => p.isNotEmpty ? p[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: RSSpacing.md),

              // ── Header: Greeting + Bell + Avatar ───────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning,',
                          style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
                        ),
                        Text(
                          userName,
                          style: RSText.headingH1.copyWith(color: RSColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  // Bell with unread badge -> 41
                  Stack(
                    children: [
                      RSIconButton.soft(
                        icon: LucideIcons.bell,
                        onPressed: () => context.push('/home/notifications'),
                        semanticLabel: 'Notifications',
                      ),
                      if (hasUnreadNotifs)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: RSColors.statusError,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Avatar -> Profile tab
                  GestureDetector(
                    onTap: () => context.go('/profile'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: RSColors.brandMint,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        userInitials,
                        style: RSText.bodySmallStrong.copyWith(color: RSColors.brandGreen),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.md),

              // ── Clinical Care Banner / Connect with Doctor CTA ───────
              RSCard(
                onTap: () => context.push('/connect'),
                padding: const EdgeInsets.all(RSSpacing.md),
                color: RSColors.brandMint,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: RSColors.surfaceCard,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.heartHandshake, color: RSColors.brandGreen, size: 22),
                    ),
                    const SizedBox(width: RSSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connect with a physiotherapist',
                            style: RSText.bodySmallStrong.copyWith(color: RSColors.brandGreen),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Get a tailored plan prescribed for your condition.',
                            style: RSText.caption.copyWith(color: RSColors.brandDeep),
                          ),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, color: RSColors.brandGreen, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.md),

              // ── Continue where you left off Card ───────────────────────
              Container(
                padding: const EdgeInsets.all(RSSpacing.md),
                decoration: BoxDecoration(
                  color: RSColors.brandDeep,
                  borderRadius: RSRadius.heroCardBR,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTINUE WHERE YOU LEFT OFF',
                      style: RSText.labelOverline.copyWith(color: RSColors.brandMint),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mini Squats',
                      style: RSText.headingH3.copyWith(color: RSColors.textOnDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Knee Rehabilitation • 4 of 10 reps done',
                      style: RSText.caption.copyWith(color: RSColors.textOnDarkSoft),
                    ),
                    const SizedBox(height: 12),
                    const RSProgressBar(
                      value: 0.4,
                      fillColor: RSColors.brandMint,
                      trackColor: RSColors.brandUplift,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '~3 min left',
                          style: RSText.caption.copyWith(color: RSColors.textOnDarkSoft),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.push('/session/knee_mini_squat/camera');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: RSColors.brandDeep,
                            minimumSize: const Size(100, 38),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: const StadiumBorder(),
                          ),
                          child: Text('Resume', style: RSText.buttonMedium),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.xl),

              // ── Today's Plan ──────────────────────────────────────────
              Text('Today’s plan', style: RSText.headingH3),
              const SizedBox(height: RSSpacing.sm),
              RSCard(
                onTap: () => context.push('/courses/knee_rehab/exercise/knee_mini_squat'),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: RSColors.brandMint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.play, color: RSColors.brandGreen, size: 24),
                    ),
                    const SizedBox(width: RSSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mini Squats', style: RSText.bodyStrong),
                          const SizedBox(height: 2),
                          Text(
                            '10 reps • 2 sets • Target angle 90°',
                            style: RSText.caption.copyWith(color: RSColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    RSButton.primary(
                      'Start',
                      () => context.push('/courses/knee_rehab/exercise/knee_mini_squat'),
                      size: RSButtonSize.medium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.xl),

              // ── Courses Section ───────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Courses', style: RSText.headingH3),
                  GestureDetector(
                    onTap: () => context.go('/courses'),
                    child: Text(
                      'See all',
                      style: RSText.bodySmallStrong.copyWith(color: RSColors.brandAction),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.sm),
              ...seedCourses.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RSCard(
                      onTap: () => context.push('/courses/${c.id}'),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: RSColors.brandMint,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.activity, color: RSColors.brandGreen, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name, style: RSText.bodyStrong),
                                const SizedBox(height: 2),
                                Text(
                                  '5 exercises • 12 min',
                                  style: RSText.caption.copyWith(color: RSColors.textSecondary),
                                ),
                                const SizedBox(height: 8),
                                const RSProgressBar(value: 0.4, height: 6),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(LucideIcons.chevronRight, size: 20, color: RSColors.borderInput),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: RSSpacing.lg),

              // ── Recent Activity Section ───────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent activity', style: RSText.headingH3),
                  GestureDetector(
                    onTap: () => context.push('/progress/history'),
                    child: Text(
                      'View all',
                      style: RSText.bodySmallStrong.copyWith(color: RSColors.brandAction),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RSSpacing.sm),

              if (recentSessions.isEmpty)
                RSEmptyState(
                  icon: LucideIcons.calendar,
                  title: 'No sessions yet',
                  body: 'Complete your first exercise to see your session history here.',
                  ctaLabel: 'Browse courses',
                  onCtaPressed: () => context.go('/courses'),
                )
              else
                ...recentSessions.take(3).map((s) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RSCard(
                      onTap: () => context.push('/progress/session/${s.id}'),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: RSColors.surfaceCeramic,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.activity, size: 20, color: RSColors.brandGreen),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mini Squat', style: RSText.bodyStrong),
                                const SizedBox(height: 2),
                                Text(
                                  'Score ${s.score} • 10 reps',
                                  style: RSText.caption.copyWith(color: RSColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          RSStatusChip.fromOutcome(
                            s.score >= 70 ? RepOutcome.correct : RepOutcome.incomplete,
                            compact: true,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 100), // Reserve bottom space for nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonState() {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 16),
              RSSkeletonBlock.line(width: 140, height: 16),
              SizedBox(height: 8),
              RSSkeletonBlock.line(width: 180, height: 28),
              SizedBox(height: 24),
              RSSkeletonBlock(width: double.infinity, height: 140),
              SizedBox(height: 24),
              RSSkeletonBlock.line(width: 120, height: 20),
              SizedBox(height: 12),
              RSSkeletonBlock(width: double.infinity, height: 80),
              SizedBox(height: 12),
              RSSkeletonBlock(width: double.infinity, height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
