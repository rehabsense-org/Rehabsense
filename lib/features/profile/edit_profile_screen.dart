import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  String _selectedAge = '25-34';
  String _selectedGoal = 'Knee recovery';
  bool _isDirty = false;

  final List<String> _ageRanges = const ['Under 18', '18-24', '25-34', '35-49', '50-64', '65+'];
  final List<String> _goals = const ['Knee recovery', 'Shoulder mobility', 'General posture & balance'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Alex Rehabber');
    _nameController.addListener(() {
      if (!_isDirty) setState(() => _isDirty = true);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (_isDirty) {
      showDialog(
        context: context,
        builder: (ctx) => RSDialog(
          icon: LucideIcons.alertTriangle,
          iconBgColor: RSColors.statusWarningTint,
          iconColor: RSColors.statusWarningInk,
          title: 'Discard changes?',
          body: 'You have unsaved edits in your profile. Are you sure you want to discard them?',
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
      const SnackBar(content: Text('Profile updated successfully.')),
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
          title: const Text('Edit profile'),
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
                'Save changes',
                _isDirty ? _save : null,
                disabled: !_isDirty,
              ),
              const SizedBox(height: 4),
              RSButton.text('Cancel', _onBack),
            ],
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(RSSpacing.screenH),
            children: [
              // Avatar with tap to change
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: RSColors.brandMint,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'AR',
                        style: RSText.headingH1.copyWith(color: RSColors.brandGreen),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: RSColors.brandAction,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.camera, size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.xl),

              RSInput(
                label: 'Display name',
                controller: _nameController,
                prefixIcon: LucideIcons.user,
              ),
              const SizedBox(height: RSSpacing.md),

              // Email read-only
              RSInput(
                label: 'Email address',
                controller: TextEditingController(text: 'alex@rehab.test'),
                enabled: false,
                prefixIcon: LucideIcons.mail,
                suffixIcon: LucideIcons.checkCheck,
              ),
              const SizedBox(height: RSSpacing.lg),

              Text('Age range', style: RSText.bodySmallStrong.copyWith(color: RSColors.textSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _ageRanges.map((range) {
                  final selected = range == _selectedAge;
                  return ChoiceChip(
                    label: Text(range),
                    selected: selected,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedAge = range;
                          _isDirty = true;
                        });
                      }
                    },
                    selectedColor: RSColors.brandMint,
                    backgroundColor: RSColors.surfaceCard,
                    labelStyle: TextStyle(
                      color: selected ? RSColors.brandGreen : RSColors.textPrimary,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: RSSpacing.lg),

              Text('Primary rehabilitation goal', style: RSText.bodySmallStrong.copyWith(color: RSColors.textSecondary)),
              const SizedBox(height: 8),
              ..._goals.map((g) {
                final isSelected = g == _selectedGoal;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RSCard(
                    onTap: () {
                      setState(() {
                        _selectedGoal = g;
                        _isDirty = true;
                      });
                    },
                    color: isSelected ? RSColors.statusSuccessTint : RSColors.surfaceCard,
                    border: Border.all(
                      color: isSelected ? RSColors.brandAction : RSColors.borderInput,
                      width: isSelected ? 1.5 : 1,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(g, style: RSText.bodyStrong)),
                        if (isSelected) const Icon(LucideIcons.checkCircle, color: RSColors.brandAction, size: 20),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
