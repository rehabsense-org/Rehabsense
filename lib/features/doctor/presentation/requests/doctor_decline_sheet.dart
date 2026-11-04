import 'package:flutter/material.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorDeclineSheet extends StatefulWidget {
  final String patientName;
  final ValueChanged<String>? onConfirm;

  const DoctorDeclineSheet({
    super.key,
    required this.patientName,
    this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String patientName,
    ValueChanged<String>? onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: RSColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: DoctorDeclineSheet(
          patientName: patientName,
          onConfirm: onConfirm,
        ),
      ),
    );
  }

  @override
  State<DoctorDeclineSheet> createState() => _DoctorDeclineSheetState();
}

class _DoctorDeclineSheetState extends State<DoctorDeclineSheet> {
  String _selectedReason = 'Caseload full';
  final _noteController = TextEditingController();

  static const List<String> _reasons = [
    'Caseload full',
    'Outside clinical specialty',
    'Location out of range',
    'Other reason',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Decline Request', style: RSText.headingH3),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text('Cancel', style: RSText.bodySmall.copyWith(color: RSColors.textSecondary)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select a reason for declining ${widget.patientName}\'s request. '
              'They will be notified and encouraged to connect with another specialist.',
              style: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _reasons.map((r) {
                return RSChoiceChip(
                  label: r,
                  selected: _selectedReason == r,
                  onSelected: (sel) {
                    if (sel) setState(() => _selectedReason = r);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            RSInput(
              label: 'Note to patient (Optional)',
              hintText: 'e.g. Currently at maximum patient capacity for knee rehabilitation.',
              controller: _noteController,
            ),
            const SizedBox(height: 24),
            RSButton.destructive(
              'Decline request',
              () {
                Navigator.of(context).pop();
                widget.onConfirm?.call('$_selectedReason: ${_noteController.text.trim()}');
              },
            ),
          ],
        ),
      ),
    );
  }
}

