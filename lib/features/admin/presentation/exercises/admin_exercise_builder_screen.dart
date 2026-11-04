import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminExerciseBuilderScreen extends StatefulWidget {
  const AdminExerciseBuilderScreen({super.key});

  @override
  State<AdminExerciseBuilderScreen> createState() => _AdminExerciseBuilderScreenState();
}

class _AdminExerciseBuilderScreenState extends State<AdminExerciseBuilderScreen> {
  int _currentStep = 1;

  // Step 1: Basics
  final _nameController = TextEditingController(text: 'Tree pose');
  String _category = 'Yoga';
  int _visibilityIndex = 0; // 0: Public, 1: Private
  final _stepsController = TextEditingController(
    text: 'Stand tall with weight balanced. Place one foot against inner thigh or calf.',
  );

  // Step 2: Camera & Kind
  int _typeIndex = 1; // 0: Rep, 1: Hold
  int _viewIndex = 1; // 0: Side, 1: Front

  // Step 3: Tracking config
  final _jointController = TextEditingController(text: 'Standing knee');
  final _angleRangeController = TextEditingController(text: '60 to 90');
  final _holdDurationController = TextEditingController(text: '20');

  @override
  void dispose() {
    _nameController.dispose();
    _stepsController.dispose();
    _jointController.dispose();
    _angleRangeController.dispose();
    _holdDurationController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise published to public catalog. Event recorded in audit log.')),
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
        title: Text('Exercise Builder (Admin)', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          _currentStep == 4 ? 'Publish exercise' : 'Continue',
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
        return 'Review & Publish';
    }
  }

  Widget _buildStep1Basics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RSInput(
          label: 'Exercise Name',
          controller: _nameController,
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
        Text('Visibility', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
        const SizedBox(height: 8),
        RSSegmentedControl(
          segments: const ['Public', 'Private'],
          selectedIndex: _visibilityIndex,
          onValueChanged: (idx) => setState(() => _visibilityIndex = idx),
        ),
        const SizedBox(height: RSSpacing.md),
        RSInput(
          label: 'Steps for the patient',
          controller: _stepsController,
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
                  'Privacy rule: No video or images are stored. Only 2D joint landmarks are processed in real-time.',
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
          label: 'Joint',
          controller: _jointController,
        ),
        const SizedBox(height: RSSpacing.md),
        RSInput(
          label: 'Angle Range (degrees)',
          controller: _angleRangeController,
        ),
        const SizedBox(height: RSSpacing.md),
        RSInput(
          label: 'Hold Time (seconds)',
          controller: _holdDurationController,
        ),
        const SizedBox(height: RSSpacing.lg),
        RSButton.secondary(
          'Test on camera',
          () => context.push('/admin/exercises/new/test'),
        ),
      ],
    );
  }

  Widget _buildStep4Review() {
    final isHold = _typeIndex == 1;
    final isFront = _viewIndex == 1;
    final isPublic = _visibilityIndex == 0;

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
              _buildReviewRow('Camera View', isFront ? 'Front' : 'Side'),
              const Divider(height: 16),
              _buildReviewRow('Angle Range', '${_angleRangeController.text}°'),
              const Divider(height: 16),
              _buildReviewRow('Hold Time', '${_holdDurationController.text} s'),
              const Divider(height: 16),
              _buildReviewRow('Visibility', isPublic ? 'Public' : 'Private'),
            ],
          ),
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
                  'Publishing makes this pose available to all doctors and patients worldwide.',
                  style: RSText.caption.copyWith(color: RSColors.brandGreen),
                ),
              ),
            ],
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

