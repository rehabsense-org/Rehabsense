import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class MyConditionScreen extends StatefulWidget {
  const MyConditionScreen({super.key});

  @override
  State<MyConditionScreen> createState() => _MyConditionScreenState();
}

class _MyConditionScreenState extends State<MyConditionScreen> {
  String _selectedArea = 'Knee';
  final _diagnosisController = TextEditingController(text: 'ACL repair, right knee');
  double _painLevel = 4.0;
  final _notesController = TextEditingController(text: 'Right knee after ACL surgery 6 weeks ago.');

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveCondition() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Condition updated.')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final areas = ['Knee', 'Shoulder', 'Hip', 'Back', 'Ankle', 'Neck'];

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'My condition',
          style: RSText.headingH3.copyWith(color: RSColors.brandGreen),
        ),
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(RSSpacing.screenH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Body area', style: RSText.bodyStrong),
                    const SizedBox(height: RSSpacing.sm),
                    Wrap(
                      spacing: RSSpacing.xs,
                      runSpacing: RSSpacing.xs,
                      children: areas.map((area) {
                        return RSChoiceChip(
                          label: area,
                          selected: _selectedArea == area,
                          onSelected: (_) => setState(() => _selectedArea = area),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: RSSpacing.lg),

                    RSInput(
                      label: 'Diagnosis',
                      controller: _diagnosisController,
                      prefixIcon: LucideIcons.fileText,
                    ),
                    const SizedBox(height: RSSpacing.lg),

                    RSSlider(
                      value: _painLevel,
                      title: 'Current pain level',
                      onChanged: (val) => setState(() => _painLevel = val),
                    ),
                    const SizedBox(height: RSSpacing.lg),

                    RSInput(
                      label: 'Recovery notes',
                      controller: _notesController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: RSSpacing.lg),

                    RSCard(
                      padding: const EdgeInsets.all(RSSpacing.md),
                      color: RSColors.brandMint,
                      child: Row(
                        children: [
                          const Icon(LucideIcons.lock, color: RSColors.brandGreen, size: 20),
                          const SizedBox(width: RSSpacing.sm),
                          Expanded(
                            child: Text(
                              'Only your connected doctor can access this condition report.',
                              style: RSText.caption.copyWith(color: RSColors.brandDeep),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(RSSpacing.screenH),
              child: RSButton.primary(
                'Save changes',
                _saveCondition,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

