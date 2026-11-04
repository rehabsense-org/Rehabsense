import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorEditProfileScreen extends StatefulWidget {
  const DoctorEditProfileScreen({super.key});

  @override
  State<DoctorEditProfileScreen> createState() => _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  final _titleController = TextEditingController(text: 'Physiotherapist');
  final _clinicController = TextEditingController(text: 'City Rehab Clinic');
  final _bioController = TextEditingController(
    text: 'I specialize in orthopedic rehabilitation and post-surgical recovery, helping patients return to pain-free daily movement.',
  );
  final _maxPatientsController = TextEditingController(text: '30');

  final Set<String> _selectedExpertise = {'Knee', 'Post-surgery'};
  static const List<String> _expertiseOptions = ['Knee', 'Shoulder', 'Hip', 'Back', 'Post-surgery'];

  bool _acceptingPatients = true;

  @override
  void dispose() {
    _titleController.dispose();
    _clinicController.dispose();
    _bioController.dispose();
    _maxPatientsController.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully.')),
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
        title: Text('Edit Profile', style: RSText.bodyStrong),
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
            RSInput(
              label: 'Professional Title',
              controller: _titleController,
            ),
            const SizedBox(height: RSSpacing.md),
            RSInput(
              label: 'Clinic / Hospital Name',
              prefixIcon: LucideIcons.mapPin,
              controller: _clinicController,
            ),
            const SizedBox(height: RSSpacing.lg),

            Text('CLINICAL EXPERTISE', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _expertiseOptions.map((area) {
                final isSelected = _selectedExpertise.contains(area);
                return RSChoiceChip(
                  label: area,
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedExpertise.add(area);
                      } else {
                        _selectedExpertise.remove(area);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: RSSpacing.lg),

            RSInput(
              label: 'Clinical Bio',
              hintText: 'Share your background and philosophy...',
              controller: _bioController,
            ),
            const SizedBox(height: RSSpacing.lg),

            RSCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Accepting new patients', style: RSText.bodyStrong),
                      const SizedBox(height: 2),
                      Text(
                        'Visible in the Find Doctors directory',
                        style: RSText.caption.copyWith(color: RSColors.textSecondary),
                      ),
                    ],
                  ),
                  Switch(
                    value: _acceptingPatients,
                    activeTrackColor: RSColors.brandGreen,
                    onChanged: (val) => setState(() => _acceptingPatients = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            RSInput(
              label: 'Maximum Patient Capacity',
              controller: _maxPatientsController,
              hintText: 'e.g. 30',
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

