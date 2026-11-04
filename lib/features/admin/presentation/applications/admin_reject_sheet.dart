import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminRejectSheet extends StatefulWidget {
  final String doctorName;
  final ValueChanged<String> onConfirm;

  const AdminRejectSheet({
    super.key,
    required this.doctorName,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String doctorName,
    required ValueChanged<String> onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdminRejectSheet(
        doctorName: doctorName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AdminRejectSheet> createState() => _AdminRejectSheetState();
}

class _AdminRejectSheetState extends State<AdminRejectSheet> {
  String _selectedReason = 'Unreadable document';
  final _notesController = TextEditingController(
    text: 'The license photo is blurry or unreadable. Please upload a clear photo or official PDF.',
  );

  static const List<String> _reasons = [
    'Unreadable document',
    'Licence not found',
    'Mismatch',
    'Other',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: RSSpacing.screenH,
        right: RSSpacing.screenH,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: RSColors.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(RSRadius.card)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: RSColors.statusErrorTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.x, color: RSColors.statusError, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reject Application', style: RSText.headingH3),
                    Text(
                      'Choose a reason for ${widget.doctorName}. They can resubmit.',
                      style: RSText.caption.copyWith(color: RSColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: RSSpacing.lg),

          Text('REASON FOR REJECTION', style: RSText.labelOverline.copyWith(color: RSColors.textSecondary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _reasons.map((r) {
              return RSChoiceChip(
                label: r,
                selected: _selectedReason == r,
                onSelected: (val) => setState(() => _selectedReason = r),
              );
            }).toList(),
          ),
          const SizedBox(height: RSSpacing.md),

          RSInput(
            label: 'Note to doctor',
            controller: _notesController,
            hintText: 'Explain the reason clearly...',
          ),
          const SizedBox(height: RSSpacing.lg),

          RSButton.destructive(
            'Reject application',
            () {
              Navigator.of(context).pop();
              widget.onConfirm('$_selectedReason: ${_notesController.text}');
            },
          ),
          const SizedBox(height: 8),
          RSButton.text(
            'Cancel',
            () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

