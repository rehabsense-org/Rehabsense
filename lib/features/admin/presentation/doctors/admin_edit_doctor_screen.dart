import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminEditDoctorScreen extends StatefulWidget {
  final String doctorId;

  const AdminEditDoctorScreen({super.key, required this.doctorId});

  @override
  State<AdminEditDoctorScreen> createState() => _AdminEditDoctorScreenState();
}

class _AdminEditDoctorScreenState extends State<AdminEditDoctorScreen> {
  final _titleController = TextEditingController(text: 'Physiotherapist');
  final _clinicController = TextEditingController(text: 'City Rehab Clinic');
  final Set<String> _selectedExpertise = {'Knee', 'Post-surgery'};
  bool _listed = true;

  static const List<String> _expertiseOptions = ['Knee', 'Shoulder', 'Hip', 'Post-surgery', 'Spine'];

  @override
  void dispose() {
    _titleController.dispose();
    _clinicController.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Doctor details updated. Event recorded in audit log.')),
    );
    context.pop();
  }

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
        title: Text('Edit Doctor Profile', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Save changes',
          _save,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
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
                      'Every profile modification is permanently saved to the staff audit log.',
                      style: RSText.caption.copyWith(color: RSColors.brandGreen),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            RSInput(
              label: 'Title',
              controller: _titleController,
            ),
            const SizedBox(height: RSSpacing.md),

            RSInput(
              label: 'Clinic / Hospital',
              prefixIcon: LucideIcons.mapPin,
              controller: _clinicController,
            ),
            const SizedBox(height: RSSpacing.lg),

            Text('CLINICAL EXPERTISE', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _expertiseOptions.map((exp) {
                final isSelected = _selectedExpertise.contains(exp);
                return RSChoiceChip(
                  label: exp,
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedExpertise.add(exp);
                      } else {
                        _selectedExpertise.remove(exp);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: RSSpacing.lg),

            RSCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Listed to patients', style: RSText.bodyStrong),
                      const SizedBox(height: 2),
                      Text(
                        'Visible in public doctor discovery directory',
                        style: RSText.caption.copyWith(color: RSColors.textSecondary),
                      ),
                    ],
                  ),
                  Switch(
                    value: _listed,
                    activeTrackColor: RSColors.brandGreen,
                    onChanged: (val) => setState(() => _listed = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

