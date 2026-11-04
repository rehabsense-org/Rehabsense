import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorExerciseBuilderWizard extends StatefulWidget {
  const DoctorExerciseBuilderWizard({super.key});

  @override
  State<DoctorExerciseBuilderWizard> createState() => _DoctorExerciseBuilderWizardState();
}

class _DoctorExerciseBuilderWizardState extends State<DoctorExerciseBuilderWizard> {
  int _currentStep = 1;

  // Step 1: Basics
  final _nameController = TextEditingController(text: 'Wall Sit');
  String _category = 'Rehab';
  final _stepsController = TextEditingController(
    text: 'Lean against a wall and slide down until knees are bent to approximately 90 degrees.',
  );

  // Step 2: Camera & Kind
  int _typeIndex = 1; // 0: Rep, 1: Hold
  int _viewIndex = 0; // 0: Side, 1: Front

  // Step 3: Tracking config
  final _jointController = TextEditingController(text: 'Right knee');
  final _angleRangeController = TextEditingController(text: '80 to 100');
  final _holdDurationController = TextEditingController(text: '30');
  final _gracePeriodController = TextEditingController(text: '2');

  @override
  void dispose() {
    _nameController.dispose();
    _stepsController.dispose();
    _jointController.dispose();
    _angleRangeController.dispose();
    _holdDurationController.dispose();
    _gracePeriodController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise saved as Private successfully!')),
      );
      context.pop();
    }
  }

  void _prev() {
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
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: _prev,
          semanticLabel: 'Back',
        ),
        title: Text('Exercise Builder', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          _currentStep == 4 ? 'Save exercise' : 'Continue',
          _next,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            RSStepHeader(
              currentStep: _currentStep,
              totalSteps: 4,
              title: _stepTitle,
            ),
            const SizedBox(height: RSSpacing.md),
            if (_currentStep == 1) _buildStep1Basics(),
            if (_currentStep == 2) _buildStep2CameraKind(),
            if (_currentStep == 3) _buildStep3TrackingConfig(),
            if (_currentStep == 4) _buildStep4Review(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String get _stepTitle {
    switch (_currentStep) {
      case 1:
        return 'Basics';
      case 2:
        return 'Camera & Kind';
      case 3:
        return 'Tracking Configuration';
      case 4:
      default:
        return 'Review & Save';
    }
  }

  Widget _buildStep1Basics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RSInput(
          label: 'Exercise Name',
          controller: _nameController,
          hintText: 'e.g. Wall Sit hold',
        ),
        const SizedBox(height: RSSpacing.md),
        Text('Category', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
        const SizedBox(height: 8),
        Row(
          children: ['Rehab', 'Yoga', 'General'].map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: RSChoiceChip(
                label: cat,
                selected: _category == cat,
                onSelected: (sel) => setState(() => _category = cat),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: RSSpacing.md),
        RSInput(
          label: 'Steps for the patient',
          controller: _stepsController,
          hintText: 'Provide step-by-step guidance...',
        ),
        const SizedBox(height: RSSpacing.md),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: RSColors.brandMint,
            borderRadius: BorderRadius.circular(RSRadius.card),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.info, color: RSColors.brandGreen, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Visibility: Private. Only you and your assigned patients can see this exercise.',
                  style: RSText.caption.copyWith(color: RSColors.brandGreen),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2CameraKind() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Tracking Type', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
        const SizedBox(height: 8),
        RSSegmentedControl(
          segments: const ['Rep Count', 'Hold Duration'],
          selectedIndex: _typeIndex,
          onValueChanged: (idx) => setState(() => _typeIndex = idx),
        ),
        const SizedBox(height: RSSpacing.lg),
        Text('Camera View Angle', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
        const SizedBox(height: 8),
        RSSegmentedControl(
          segments: const ['Side View', 'Front View'],
          selectedIndex: _viewIndex,
          onValueChanged: (idx) => setState(() => _viewIndex = idx),
        ),
        const SizedBox(height: RSSpacing.lg),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: RSColors.surfaceCeramic,
            borderRadius: BorderRadius.circular(RSRadius.card),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.shieldCheck, color: RSColors.textSecondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tracking uses 2D kinematic angles only. No video or camera imagery is ever stored on servers.',
                  style: RSText.caption.copyWith(color: RSColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3TrackingConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RSInput(
          label: 'Primary Joint',
          controller: _jointController,
          hintText: 'e.g. Right knee',
        ),
        const SizedBox(height: RSSpacing.md),
        RSInput(
          label: 'Angle Range (degrees)',
          controller: _angleRangeController,
          hintText: 'e.g. 80 to 100',
        ),
        const SizedBox(height: RSSpacing.md),
        RSInput(
          label: _typeIndex == 1 ? 'Target Hold Duration (seconds)' : 'Target Reps',
          controller: _holdDurationController,
          hintText: 'e.g. 30',
        ),
        const SizedBox(height: RSSpacing.md),
        RSInput(
          label: 'Grace Period (seconds)',
          controller: _gracePeriodController,
          hintText: 'e.g. 2',
        ),
        const SizedBox(height: RSSpacing.lg),
        RSButton.secondary(
          'Test on camera',
          () => context.push('/doctor/exercises/new/test'),
        ),
      ],
    );
  }

  Widget _buildStep4Review() {
    final isHold = _typeIndex == 1;
    final isSide = _viewIndex == 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReviewRow('Name', _nameController.text),
              const Divider(height: 16),
              _buildReviewRow('Category', _category),
              const Divider(height: 16),
              _buildReviewRow('Type', isHold ? 'Hold' : 'Rep'),
              const Divider(height: 16),
              _buildReviewRow('Camera View', isSide ? 'Side' : 'Front'),
              const Divider(height: 16),
              _buildReviewRow('Angle Range', '${_angleRangeController.text}°'),
              const Divider(height: 16),
              _buildReviewRow(isHold ? 'Target Hold' : 'Target Reps', '${_holdDurationController.text} ${isHold ? 's' : 'reps'}'),
              const Divider(height: 16),
              _buildReviewRow('Visibility', 'Private (Doctor-specific)'),
            ],
          ),
        ),
        const SizedBox(height: RSSpacing.md),
        const Align(
          alignment: Alignment.centerLeft,
          child: RSStatusChip(
            type: RSStatusChipType.incomplete,
            customLabel: 'Untested - Run test on camera',
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: RSText.bodySmall.copyWith(color: RSColors.textSecondary)),
        Text(value, style: RSText.bodySmallStrong),
      ],
    );
  }
}
