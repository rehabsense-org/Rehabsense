import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
        title: const Text('About'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            const SizedBox(height: 16),
            const Center(
              child: RSLogo(
                variant: RSLogoVariant.lockup,
                size: 54,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Version 2.0.0 (Build 12)',
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
              ),
            ),
            const SizedBox(height: RSSpacing.xl),

            // Mission Card
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OUR MISSION', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(
                    'RehabSense empowers patients recovering from musculoskeletal injuries with computer-vision assisted rehabilitation guidance right from their smartphone.',
                    style: RSText.bodyDefault,
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // Team List (names configurable per spec 30)
            RSCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DEVELOPMENT & CLINICAL TEAM', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
                  const SizedBox(height: 12),
                  _buildMemberRow('Muhammad Rizwan Shahzad', 'Lead AI & Biomechanics'),
                  const Divider(height: 16),
                  _buildMemberRow('Muhammad Shariq Khan', 'Computer Vision & Mobile'),
                  const Divider(height: 16),
                  _buildMemberRow('Manahil Tariq', 'Clinical Systems & UI/UX'),
                  const Divider(height: 16),
                  _buildMemberRow('Quratulain Muqaddas', 'Physiotherapy & Evaluation'),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // Disclaimer per spec rule 3
            RSCard(
              color: RSColors.surfaceCeramic,
              flat: true,
              child: Text(
                'RehabSense is a guidance tool. It does not diagnose or replace your physiotherapist.',
                style: RSText.caption.copyWith(color: RSColors.textMutedGreen),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            Center(
              child: TextButton(
                onPressed: () => showLicensePage(context: context),
                child: const Text('View open source licences'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberRow(String name, String role) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: RSColors.brandMint,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            name[0],
            style: const TextStyle(color: RSColors.brandGreen, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: RSText.bodyStrong),
              Text(role, style: RSText.caption.copyWith(color: RSColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
