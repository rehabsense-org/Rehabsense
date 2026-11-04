import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorGoLiveScreen extends StatelessWidget {
  final Map<String, dynamic>? profileData;

  const DoctorGoLiveScreen({super.key, this.profileData});

  @override
  Widget build(BuildContext context) {
    final title = profileData?['title'] as String? ?? 'Senior Physiotherapist';
    final clinic = profileData?['clinic'] as String? ?? 'Apex Physical Therapy Centre';
    final city = profileData?['city'] as String? ?? 'New York, NY';
    final bio = profileData?['bio'] as String? ??
        'Specializing in orthopedic rehabilitation and post-operative joint mobility with 8+ years of clinical experience.';
    final expertise = (profileData?['expertise'] as List?)?.map((e) => e.toString()).toList() ??
        ['Knee', 'Post-surgery', 'Sports injury'];
    final experience = profileData?['experience'] as int? ?? 8;

    final hasBio = bio.length >= 30;
    final hasTags = expertise.isNotEmpty;
    final canGoLive = hasBio && hasTags;

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Preview Profile', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RSButton.primary(
              'Go live (Publish profile)',
              canGoLive ? () => context.go('/doctor/home') : null,
              disabled: !canGoLive,
            ),
            const SizedBox(height: 8),
            RSButton.text(
              'Skip for now',
              () => context.go('/doctor/home'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            Text(
              'Patient View Preview',
              style: RSText.labelOverline.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'This is exactly how prospective patients will see your profile in the care directory.',
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── Live Doctor Card Preview ──────────────────────────────
            RSDoctorCard(
              name: 'Dr. Sara Khan',
              subtitle: '$title · $clinic',
              tags: expertise,
              matchText: '98% match',
              onTap: () {},
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Detailed Bio Card ─────────────────────────────────────
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.shieldCheck, color: RSColors.brandGreen, size: 20),
                      const SizedBox(width: 8),
                      Text('Verified Practitioner', style: RSText.bodySmallStrong.copyWith(color: RSColors.brandGreen)),
                      const Spacer(),
                      Text('$experience yrs experience', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(city, style: RSText.captionStrong.copyWith(color: RSColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(bio, style: RSText.bodyDefault),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Listing Criteria Checklist ────────────────────────────
            Text('DIRECTORY LISTING CRITERIA', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            RSCard(
              child: Column(
                children: [
                  _buildCheckItem('License verified by administrator', true),
                  const Divider(height: 16),
                  _buildCheckItem('At least one clinical expertise tag selected', hasTags),
                  const Divider(height: 16),
                  _buildCheckItem('Professional bio provided (30+ chars)', hasBio),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(String label, bool met) {
    return Row(
      children: [
        Icon(
          met ? LucideIcons.checkCircle : LucideIcons.xCircle,
          color: met ? RSColors.statusSuccess : RSColors.statusError,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: met ? RSText.bodySmall : RSText.bodySmall.copyWith(color: RSColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
