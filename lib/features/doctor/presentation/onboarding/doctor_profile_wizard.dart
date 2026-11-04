import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorProfileWizard extends StatefulWidget {
  const DoctorProfileWizard({super.key});

  @override
  State<DoctorProfileWizard> createState() => _DoctorProfileWizardState();
}

class _DoctorProfileWizardState extends State<DoctorProfileWizard> {
  int _step = 1;

  // Step 1: Basics
  final _titleController = TextEditingController(text: 'Senior Physiotherapist');
  final _clinicController = TextEditingController(text: 'Apex Physical Therapy Centre');
  final _cityController = TextEditingController(text: 'New York, NY');
  final _languagesController = TextEditingController(text: 'English, Spanish');

  // Step 2: Expertise
  final Set<String> _selectedExpertise = {'Knee', 'Post-surgery', 'Sports injury'};
  static const List<String> _availableExpertise = [
    'Knee',
    'Shoulder',
    'Back',
    'Neck',
    'Hip',
    'Ankle',
    'Post-surgery',
    'Sports injury',
    'Arthritis',
    'Balance',
    'Elderly care',
    'Yoga and wellness',
  ];

  // Step 3: About
  final _bioController = TextEditingController(
    text: 'Specializing in orthopedic rehabilitation and post-operative joint mobility with 8+ years of clinical experience.',
  );
  int _yearsExperience = 8;
  String _approach = 'Evidence-based exercise therapy focused on functional independence and strength.';

  // Step 4: Availability
  bool _acceptingNewPatients = true;
  double _maxPatients = 30;

  @override
  void dispose() {
    _titleController.dispose();
    _clinicController.dispose();
    _cityController.dispose();
    _languagesController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 4) {
      setState(() => _step++);
    } else {
      context.push('/doctor/onboarding/preview', extra: {
        'title': _titleController.text,
        'clinic': _clinicController.text,
        'city': _cityController.text,
        'languages': _languagesController.text,
        'expertise': _selectedExpertise.toList(),
        'bio': _bioController.text,
        'experience': _yearsExperience,
        'accepting': _acceptingNewPatients,
        'maxPatients': _maxPatients.toInt(),
      });
    }
  }

  void _prev() {
    if (_step > 1) {
      setState(() => _step--);
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
        title: Text('Profile Setup', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          _step == 4 ? 'Preview profile' : 'Next step',
          _next,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            RSStepHeader(
              currentStep: _step,
              totalSteps: 4,
              title: _stepTitle,
            ),
            const SizedBox(height: RSSpacing.md),

            if (_step == 1) _buildStep1Basics(),
            if (_step == 2) _buildStep2Expertise(),
            if (_step == 3) _buildStep3About(),
            if (_step == 4) _buildStep4Availability(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String get _stepTitle {
    switch (_step) {
      case 1:
        return 'Professional Basics';
      case 2:
        return 'Clinical Expertise';
      case 3:
        return 'About & Bio';
      case 4:
      default:
        return 'Practice Availability';
    }
  }

  Widget _buildStep1Basics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Introduce yourself and your practice location so patients can find you.',
          style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.lg),
        RSInput(
          label: 'Professional Title',
          hintText: 'e.g. Senior Physical Therapist',
          controller: _titleController,
          prefixIcon: LucideIcons.award,
        ),
        const SizedBox(height: RSSpacing.md),
        RSInput(
          label: 'Primary Clinic / Hospital',
          hintText: 'e.g. Apex Physical Therapy Centre',
          controller: _clinicController,
          prefixIcon: LucideIcons.building,
        ),
        const SizedBox(height: RSSpacing.md),
        RSInput(
          label: 'City, State / Region',
          hintText: 'e.g. New York, NY',
          controller: _cityController,
          prefixIcon: LucideIcons.mapPin,
        ),
        const SizedBox(height: RSSpacing.md),
        RSInput(
          label: 'Languages Spoken',
          hintText: 'e.g. English, Spanish',
          controller: _languagesController,
          prefixIcon: LucideIcons.globe,
        ),
      ],
    );
  }

  Widget _buildStep2Expertise() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select the body areas and clinical conditions you specialize in treating.',
          style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.lg),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableExpertise.map((item) {
            final isSelected = _selectedExpertise.contains(item);
            return RSChoiceChip(
              label: item,
              selected: isSelected,
              onSelected: (sel) {
                setState(() {
                  if (sel) {
                    _selectedExpertise.add(item);
                  } else {
                    _selectedExpertise.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep3About() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tell prospective patients about your background, training, and treatment philosophy.',
          style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.lg),
        RSInput(
          label: 'Professional Bio * (at least 30 characters)',
          hintText: 'Describe your clinical approach...',
          controller: _bioController,
        ),
        const SizedBox(height: RSSpacing.md),
        Text('Years of Clinical Experience: $_yearsExperience years', style: RSText.bodySmallStrong),
        Slider(
          value: _yearsExperience.toDouble(),
          min: 1,
          max: 40,
          divisions: 39,
          activeColor: RSColors.brandGreen,
          onChanged: (val) => setState(() => _yearsExperience = val.round()),
        ),
        const SizedBox(height: RSSpacing.md),
        Text('Consultation Approach', style: RSText.bodySmallStrong),
        const SizedBox(height: RSSpacing.xs),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: RSColors.surfaceCard,
            borderRadius: BorderRadius.circular(RSRadius.card),
            border: Border.all(color: RSColors.borderInput),
          ),
          child: Text(
            _approach,
            style: RSText.bodySmall.copyWith(color: RSColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4Availability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Set your patient caseload preferences and availability status.',
          style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.lg),
        RSCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accepting new patients', style: RSText.bodyStrong),
                    Text(
                      'Allow patients to send care connection requests',
                      style: RSText.caption.copyWith(color: RSColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _acceptingNewPatients,
                activeThumbColor: RSColors.brandGreen,
                onChanged: (val) => setState(() => _acceptingNewPatients = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: RSSpacing.md),
        RSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Maximum Patient Capacity: ${_maxPatients.toInt()}', style: RSText.bodyStrong),
              const SizedBox(height: 4),
              Text(
                'Default recommended limit is 30 active patients',
                style: RSText.caption.copyWith(color: RSColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Slider(
                value: _maxPatients,
                min: 5,
                max: 100,
                divisions: 19,
                activeColor: RSColors.brandGreen,
                onChanged: (val) => setState(() => _maxPatients = val),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

