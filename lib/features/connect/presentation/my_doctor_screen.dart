import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';
import 'disconnect_confirm_dialog.dart';

class MyDoctorScreen extends StatelessWidget {
  const MyDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const docName = 'Dr. Sara Khan';

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'My doctor',
          style: RSText.headingH3.copyWith(color: RSColors.brandGreen),
        ),
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RSCard(
                padding: const EdgeInsets.all(RSSpacing.md),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: RSColors.brandMint,
                      child: Text('SK', style: TextStyle(color: RSColors.brandGreen, fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    const SizedBox(width: RSSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(docName, style: RSText.headingH3),
                          const SizedBox(height: 2),
                          Text(
                            'Physiotherapist · City Rehab Clinic',
                            style: RSText.caption.copyWith(color: RSColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          const RSStatusChip(
                            type: RSStatusChipType.correct,
                            customLabel: 'Connected',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: RSSpacing.lg),

              RSMenuCard(
                items: [
                  RSMenuRowItem(
                    icon: LucideIcons.clipboardList,
                    title: 'Prescribed exercises',
                    subtitle: '2 active assignments',
                    onTap: () => context.push('/courses/prescribed'),
                  ),
                  RSMenuRowItem(
                    icon: LucideIcons.user,
                    title: 'Doctor profile',
                    subtitle: 'Bio, clinic & approach',
                    onTap: () => context.push('/connect/doctors/doc_001'),
                  ),
                ],
              ),

              const Spacer(),

              RSButton.destructiveOutline(
                'Disconnect from doctor',
                () {
                  DisconnectConfirmDialog.show(
                    context,
                    doctorName: docName,
                    onDisconnect: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Disconnected from doctor.')),
                      );
                      context.go('/home');
                    },
                  );
                },
              ),
              const SizedBox(height: RSSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

