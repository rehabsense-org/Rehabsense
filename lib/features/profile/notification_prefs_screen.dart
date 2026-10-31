import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class NotificationPrefsScreen extends StatefulWidget {
  const NotificationPrefsScreen({super.key});

  @override
  State<NotificationPrefsScreen> createState() => _NotificationPrefsScreenState();
}

class _NotificationPrefsScreenState extends State<NotificationPrefsScreen> {
  bool _exerciseReminders = true;
  bool _weeklySummary = true;
  bool _recoveryTips = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  final List<String> _days = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final Set<String> _selectedDays = {'Mon', 'Wed', 'Fri'};
  bool _isDirty = false;

  void _onBack() {
    if (_isDirty) {
      showDialog(
        context: context,
        builder: (ctx) => RSDialog(
          icon: LucideIcons.alertTriangle,
          iconBgColor: RSColors.statusWarningTint,
          iconColor: RSColors.statusWarningInk,
          title: 'Discard changes?',
          body: 'You have unsaved changes to your notification preferences.',
          primaryButtonLabel: 'Keep editing',
          onPrimaryPressed: () {},
          secondaryButtonLabel: 'Discard',
          isSecondaryDestructive: true,
          onSecondaryPressed: () => context.pop(),
        ),
      );
    } else {
      context.pop();
    }
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification preferences saved.')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _onBack();
      },
      child: Scaffold(
        backgroundColor: RSColors.surfaceCanvas,
        appBar: AppBar(
          leading: RSIconButton.plain(
            icon: LucideIcons.chevronLeft,
            onPressed: _onBack,
            semanticLabel: 'Back',
          ),
          title: const Text('Notifications'),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: RSColors.surfaceCard,
            boxShadow: RSShadows.nav,
          ),
          child: RSButton.primary(
            'Save preferences',
            _isDirty ? _save : null,
            disabled: !_isDirty,
          ),
        ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            RSCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    value: _exerciseReminders,
                    onChanged: (val) => setState(() {
                      _exerciseReminders = val;
                      _isDirty = true;
                    }),
                    title: Text('Exercise reminders', style: RSText.bodyStrong),
                    subtitle: Text('Get notified when it’s time for your session', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                    activeColor: RSColors.brandAction,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _weeklySummary,
                    onChanged: (val) => setState(() {
                      _weeklySummary = val;
                      _isDirty = true;
                    }),
                    title: Text('Weekly progress summary', style: RSText.bodyStrong),
                    subtitle: Text('Review your streak, consistency and improvement', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                    activeColor: RSColors.brandAction,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _recoveryTips,
                    onChanged: (val) => setState(() {
                      _recoveryTips = val;
                      _isDirty = true;
                    }),
                    title: Text('Recovery & posture tips', style: RSText.bodyStrong),
                    subtitle: Text('Occasional suggestions from physiotherapists', style: RSText.caption.copyWith(color: RSColors.textSecondary)),
                    activeColor: RSColors.brandAction,
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.xl),

            if (_exerciseReminders) ...[
              Text('REMINDER TIME', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
              const SizedBox(height: 8),
              RSCard(
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _reminderTime);
                  if (picked != null) {
                    setState(() {
                      _reminderTime = picked;
                      _isDirty = true;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Preferred time', style: RSText.bodyDefault),
                    Text(
                      _reminderTime.format(context),
                      style: RSText.bodyStrong.copyWith(color: RSColors.brandAction),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.lg),

              Text('SCHEDULE DAYS', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _days.map((d) {
                  final isSelected = _selectedDays.contains(d);
                  return FilterChip(
                    label: Text(d),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedDays.add(d);
                        } else {
                          _selectedDays.remove(d);
                        }
                        _isDirty = true;
                      });
                    },
                    selectedColor: RSColors.brandMint,
                    backgroundColor: RSColors.surfaceCard,
                    labelStyle: TextStyle(
                      color: isSelected ? RSColors.brandGreen : RSColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
    ),
  );
}
}
