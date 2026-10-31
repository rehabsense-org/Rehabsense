import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _audioFeedback = true;
  bool _hapticFeedback = true;
  bool _showSkeletonOverlay = true;

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
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // Exercise Group
            Text('EXERCISE & FEEDBACK', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: 8),
            RSCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    value: _audioFeedback,
                    onChanged: (val) => setState(() => _audioFeedback = val),
                    title: Text('Spoken cues', style: RSText.bodyStrong),
                    subtitle: Text('Voice prompts during repetition counting', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                    activeColor: RSColors.brandAction,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _hapticFeedback,
                    onChanged: (val) => setState(() => _hapticFeedback = val),
                    title: Text('Haptic vibration', style: RSText.bodyStrong),
                    subtitle: Text('Tactile pulse when a rep is counted', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                    activeColor: RSColors.brandAction,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _showSkeletonOverlay,
                    onChanged: (val) => setState(() => _showSkeletonOverlay = val),
                    title: Text('Skeleton overlay', style: RSText.bodyStrong),
                    subtitle: Text('Show live tracking lines over camera feed', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                    activeColor: RSColors.brandAction,
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.xl),

            // Account Group
            Text('ACCOUNT', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: 8),
            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.lock,
                  title: 'Change password',
                  subtitle: 'Update your login password',
                  onTap: () => context.push('/profile/settings/password'),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.xl),

            // More Group
            Text('MORE', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: 8),
            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.bell,
                  title: 'Notification preferences',
                  onTap: () => context.push('/profile/notifications'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.helpCircle,
                  title: 'Help & FAQ',
                  onTap: () => context.push('/profile/help'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.shield,
                  title: 'Privacy & data',
                  onTap: () => context.push('/profile/privacy'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.info,
                  title: 'About RehabSense',
                  onTap: () => context.push('/profile/about'),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
