import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController(text: 'Alex Rehabber');
  String _selectedAgeRange = '25-34';
  String _selectedGoal = 'Knee recovery';

  final List<String> _ageRanges = const [
    'Under 18',
    '18-24',
    '25-34',
    '35-49',
    '50-64',
    '65+'
  ];

  final List<String> _goals = const [
    'Knee recovery',
    'Shoulder mobility',
    'General posture & balance',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continue() {
    context.push('/setup/safety');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Per spec B6: NO back button
        title: const Text('Step 1 of 2'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: RSProgressBar(value: 0.5, height: 4),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: RSSpacing.md),
              Text('Tell us a bit about yourself', style: RSText.headingH1),
              const SizedBox(height: RSSpacing.xs),
              Text(
                'This helps us personalize exercise recommendations and movement thresholds.',
                style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: RSSpacing.xl),
              RSInput(
                label: 'Display name',
                controller: _nameController,
                hintText: 'How should we call you?',
              ),
              const SizedBox(height: RSSpacing.lg),
              Text(
                'Age range',
                style: RSText.bodySmallStrong.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: RSSpacing.sm),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _ageRanges.map((range) {
                  final selected = range == _selectedAgeRange;
                  return ChoiceChip(
                    label: Text(range),
                    selected: selected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedAgeRange = range);
                    },
                    selectedColor: RSColors.brandMint,
                    backgroundColor: RSColors.surfaceCard,
                    labelStyle: TextStyle(
                      color: selected ? RSColors.brandGreen : RSColors.textPrimary,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: const StadiumBorder(
                      side: BorderSide(color: RSColors.borderInput),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: RSSpacing.lg),
              Text(
                'Primary rehabilitation goal',
                style: RSText.bodySmallStrong.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: RSSpacing.sm),
              Column(
                children: _goals.map((goal) {
                  final selected = goal == _selectedGoal;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: RSCard(
                      onTap: () => setState(() => _selectedGoal = goal),
                      color: selected ? RSColors.statusSuccessTint : RSColors.surfaceCard,
                      border: Border.all(
                        color: selected ? RSColors.brandAction : RSColors.borderInput,
                        width: selected ? 1.5 : 1,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              goal,
                              style: RSText.bodyStrong.copyWith(
                                color: selected ? RSColors.brandGreen : RSColors.textPrimary,
                              ),
                            ),
                          ),
                          if (selected)
                            const Icon(
                              Icons.check_circle,
                              color: RSColors.brandAction,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: RSSpacing.xl),
              RSButton.primary(
                'Save and continue',
                _continue,
              ),
              const SizedBox(height: RSSpacing.sm),
              RSButton.text(
                'Skip for now',
                _continue,
              ),
              const SizedBox(height: RSSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
