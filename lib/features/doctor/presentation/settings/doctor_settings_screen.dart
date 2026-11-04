import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorSettingsScreen extends StatefulWidget {
  const DoctorSettingsScreen({super.key});

  @override
  State<DoctorSettingsScreen> createState() => _DoctorSettingsScreenState();
}

class _DoctorSettingsScreenState extends State<DoctorSettingsScreen> {
  bool _emailAlertsRequests = true;
  bool _painAlerts = true;
  bool _inactivePatientAlerts = true;

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
        title: Text('Settings', style: RSText.bodyStrong),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            Text('SECURITY & ACCOUNT', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            RSMenuCard(
              items: [
                RSMenuRowItem(
                  icon: LucideIcons.lock,
                  title: 'Change password',
                  subtitle: 'Update your login credentials',
                  onTap: () => context.push('/doctor/reset-password'),
                ),
                RSMenuRowItem(
                  icon: LucideIcons.helpCircle,
                  title: 'Help and clinical support',
                  subtitle: 'Contact RehabSense clinical operations',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Support email: clinical@rehabsense.org')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.lg),

            Text('NOTIFICATION PREFERENCES', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: RSSpacing.xs),
            RSCard(
              child: Column(
                children: [
                  _buildToggleRow(
                    title: 'Email alerts for requests',
                    subtitle: 'Notify immediately when a new patient submits a request',
                    value: _emailAlertsRequests,
                    onChanged: (val) => setState(() => _emailAlertsRequests = val),
                  ),
                  const Divider(height: 16),
                  _buildToggleRow(
                    title: 'High pain alerts',
                    subtitle: 'Push notification when a patient reports pain >= 7',
                    value: _painAlerts,
                    onChanged: (val) => setState(() => _painAlerts = val),
                  ),
                  const Divider(height: 16),
                  _buildToggleRow(
                    title: 'Inactive patient alerts',
                    subtitle: 'Reminder when an active patient misses sessions for 3 days',
                    value: _inactivePatientAlerts,
                    onChanged: (val) => setState(() => _inactivePatientAlerts = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // App version info
            Center(
              child: Text(
                'RehabSense Clinical Portal v2.0.0',
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: RSText.bodyStrong),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: value,
          activeTrackColor: RSColors.brandGreen,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

