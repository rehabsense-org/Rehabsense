import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../data/seed/seed_data.dart';


class DoctorAssignWizard extends StatefulWidget {
  final String patientId;

  const DoctorAssignWizard({super.key, required this.patientId});

  @override
  State<DoctorAssignWizard> createState() => _DoctorAssignWizardState();
}

class _DoctorAssignWizardState extends State<DoctorAssignWizard> {
  int _step = 1;

  // Step 1: Exercise Selection
  String _selectedExerciseId = 'knee_mini_squat';

  // Step 2: Dosage
  double _reps = 10;
  double _sets = 3;
  double _restSeconds = 30;

  // Step 3: Schedule & Notes
  final Set<String> _selectedDays = {'Mon', 'Wed', 'Fri'};
  final _notesController = TextEditingController(
    text: 'Keep weight on heels and control movement descent. Stop if sharp pain occurs.',
  );

  static const List<String> _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise prescribed successfully!')),
      );
      context.pop();
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
        title: Text('Assign Exercise', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          _step == 3 ? 'Confirm & Prescribe' : 'Continue',
          _next,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            RSStepHeader(
              currentStep: _step,
              totalSteps: 3,
              title: _stepTitle,
            ),
            const SizedBox(height: RSSpacing.md),

            if (_step == 1) _buildStep1ExerciseSelection(),
            if (_step == 2) _buildStep2Dosage(),
            if (_step == 3) _buildStep3Schedule(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  String get _stepTitle {
    switch (_step) {
      case 1:
        return 'Choose Exercise';
      case 2:
        return 'Prescribe Dosage';
      case 3:
      default:
        return 'Schedule & Notes';
    }
  }

  Widget _buildStep1ExerciseSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select an exercise from your library to prescribe to this patient.',
          style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.md),
        ...seedExercises.take(4).map((ex) {
          final isSelected = _selectedExerciseId == ex.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedExerciseId = ex.id),
              borderRadius: BorderRadius.circular(RSRadius.card),
              child: RSCard(
                color: isSelected ? RSColors.brandMint : RSColors.surfaceCard,
                child: Row(
                  children: [
                    Icon(
                      isSelected ? LucideIcons.checkCircle : LucideIcons.circle,
                      color: isSelected ? RSColors.brandGreen : RSColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ex.name, style: RSText.bodyStrong),
                          Text(
                            '${ex.trackingType == 'hold' ? 'Hold exercise' : 'Rep exercise'} • ${ex.cameraView.toUpperCase()} view',
                            style: RSText.caption.copyWith(color: RSColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep2Dosage() {
    final ex = seedExercises.firstWhere((e) => e.id == _selectedExerciseId, orElse: () => seedExercises.first);
    final isHold = ex.trackingType == 'hold';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Configure targets tailored to this patient\'s rehabilitation stage.',
          style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.lg),
        RSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isHold ? 'Target Hold Duration: ${_reps.toInt()} seconds' : 'Target Reps: ${_reps.toInt()} reps',
                style: RSText.bodyStrong,
              ),
              Slider(
                value: _reps,
                min: 3,
                max: isHold ? 60 : 30,
                divisions: isHold ? 57 : 27,
                activeColor: RSColors.brandGreen,
                onChanged: (val) => setState(() => _reps = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: RSSpacing.md),
        RSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Target Sets: ${_sets.toInt()} sets', style: RSText.bodyStrong),
              Slider(
                value: _sets,
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: RSColors.brandGreen,
                onChanged: (val) => setState(() => _sets = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: RSSpacing.md),
        RSCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rest Between Sets: ${_restSeconds.toInt()}s', style: RSText.bodyStrong),
              Slider(
                value: _restSeconds,
                min: 15,
                max: 90,
                divisions: 15,
                activeColor: RSColors.brandGreen,
                onChanged: (val) => setState(() => _restSeconds = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Schedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Choose the weekly schedule days and provide instructions for the patient.',
          style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
        ),
        const SizedBox(height: RSSpacing.lg),
        Text('Days of the week', style: RSText.bodySmallStrong),
        const SizedBox(height: RSSpacing.xs),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weekdays.map((day) {
            final sel = _selectedDays.contains(day);
            return RSChoiceChip(
              label: day,
              selected: sel,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedDays.add(day);
                  } else {
                    _selectedDays.remove(day);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: RSSpacing.lg),
        RSInput(
          label: 'Clinical Instructions & Precautions',
          hintText: 'e.g. Focus on knee tracking over second toe. Stop if pain increases.',
          controller: _notesController,
        ),
      ],
    );
  }
}

