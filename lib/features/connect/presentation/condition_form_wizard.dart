import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';
import 'red_flags_alert_sheet.dart';

class ConditionFormWizard extends StatefulWidget {
  const ConditionFormWizard({super.key});

  @override
  State<ConditionFormWizard> createState() => _ConditionFormWizardState();
}

class _ConditionFormWizardState extends State<ConditionFormWizard> {
  int _currentStep = 1;

  // Step 1: Body Area & Duration
  String _selectedBodyArea = 'Knee';
  String _selectedDuration = '2-6 weeks';
  final _diagnosisController = TextEditingController(text: 'ACL repair');

  // Step 2: Pain & Red Flags
  double _painLevel = 4.0;
  final Set<String> _selectedRedFlags = {};

  // Step 3: Goals & Notes
  String _selectedGoal = 'Walk without pain';
  final _notesController = TextEditingController(
    text: 'Right knee after ACL surgery 6 weeks ago.',
  );

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentStep == 2 && _selectedRedFlags.isNotEmpty) {
      RedFlagsAlertSheet.show(
        context,
        onContinue: () {
          setState(() => _currentStep = 3);
        },
      );
      return;
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      // Completed -> Find Doctors
      context.push('/connect/doctors');
    }
  }

  void _onBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'Your condition',
          style: RSText.headingH3.copyWith(color: RSColors.brandGreen),
        ),
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: _onBack,
          semanticLabel: 'Back',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: RSSpacing.screenH,
                vertical: RSSpacing.sm,
              ),
              child: RSStepHeader(
                currentStep: _currentStep,
                totalSteps: 3,
                title: _getStepTitle(_currentStep),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(RSSpacing.screenH),
                child: _buildStepContent(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(RSSpacing.screenH),
              child: RSButton.primary(
                _currentStep == 3 ? 'Find doctors' : 'Continue',
                _onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'Body area';
      case 2:
        return 'Symptoms & Pain';
      case 3:
      default:
        return 'Goals & Notes';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
      default:
        return _buildStep3();
    }
  }

  Widget _buildStep1() {
    final areas = ['Knee', 'Shoulder', 'Hip', 'Back', 'Ankle', 'Neck'];
    final durations = ['Under 2 weeks', '2-6 weeks', '6 weeks+'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Where does it hurt?', style: RSText.headingH2),
        const SizedBox(height: RSSpacing.xs),
        Text(
          'Pick the main area you want to rehabilitate.',
          style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.md),
        Wrap(
          spacing: RSSpacing.sm,
          runSpacing: RSSpacing.sm,
          children: areas.map((area) {
            return RSChoiceChip(
              label: area,
              selected: _selectedBodyArea == area,
              onSelected: (_) => setState(() => _selectedBodyArea = area),
            );
          }).toList(),
        ),
        const SizedBox(height: RSSpacing.xl),
        Text('How long have you had this?', style: RSText.bodyStrong),
        const SizedBox(height: RSSpacing.sm),
        Wrap(
          spacing: RSSpacing.sm,
          runSpacing: RSSpacing.sm,
          children: durations.map((dur) {
            return RSChoiceChip(
              label: dur,
              selected: _selectedDuration == dur,
              onSelected: (_) => setState(() => _selectedDuration = dur),
            );
          }).toList(),
        ),
        const SizedBox(height: RSSpacing.xl),
        RSInput(
          label: 'Diagnosis (if you know it)',
          controller: _diagnosisController,
          hintText: 'e.g. ACL reconstruction, Meniscus tear',
          prefixIcon: LucideIcons.fileText,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    final redFlagOptions = [
      'Numbness or tingling in the limb',
      'Fever, redness, or heat in joint',
      'Severe pain that wakes you up at night',
      'Recent sudden fall or physical accident',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current pain level', style: RSText.headingH2),
        const SizedBox(height: RSSpacing.xs),
        Text(
          'Be honest. This helps your doctor set the right initial dose.',
          style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.lg),
        RSSlider(
          value: _painLevel,
          title: 'Baseline pain',
          onChanged: (val) => setState(() => _painLevel = val),
        ),
        const SizedBox(height: RSSpacing.xl),
        Text('Safety check', style: RSText.bodyStrong),
        const SizedBox(height: RSSpacing.xs),
        Text(
          'Do you have any of the following symptoms?',
          style: RSText.caption.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.sm),
        ...redFlagOptions.map((rf) {
          final isChecked = _selectedRedFlags.contains(rf);
          return RSCard(
            padding: const EdgeInsets.symmetric(horizontal: RSSpacing.md, vertical: RSSpacing.sm),
            child: Row(
              children: [
                Checkbox(
                  value: isChecked,
                  activeColor: RSColors.brandAction,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedRedFlags.add(rf);
                      } else {
                        _selectedRedFlags.remove(rf);
                      }
                    });
                  },
                ),
                const SizedBox(width: RSSpacing.sm),
                Expanded(
                  child: Text(
                    rf,
                    style: RSText.bodySmall.copyWith(
                      color: isChecked ? RSColors.statusError : RSColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep3() {
    final goals = [
      'Walk without pain',
      'Return to sport',
      'Daily activities',
      'After surgery recovery',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What is your main goal?', style: RSText.headingH2),
        const SizedBox(height: RSSpacing.xs),
        Text(
          'Select your primary target for physical recovery.',
          style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.md),
        Wrap(
          spacing: RSSpacing.sm,
          runSpacing: RSSpacing.sm,
          children: goals.map((goal) {
            return RSChoiceChip(
              label: goal,
              selected: _selectedGoal == goal,
              onSelected: (_) => setState(() => _selectedGoal = goal),
            );
          }).toList(),
        ),
        const SizedBox(height: RSSpacing.xl),
        RSInput(
          label: 'Notes for your doctor',
          controller: _notesController,
          hintText: 'Share any surgery details or limitations...',
          maxLines: 4,
        ),
      ],
    );
  }
}

