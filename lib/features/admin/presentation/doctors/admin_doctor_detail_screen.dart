import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';
import 'admin_suspend_dialog.dart';

class AdminDoctorDetailScreen extends StatefulWidget {
  final String doctorId;

  const AdminDoctorDetailScreen({super.key, required this.doctorId});

  @override
  State<AdminDoctorDetailScreen> createState() => _AdminDoctorDetailScreenState();
}

class _AdminDoctorDetailScreenState extends State<AdminDoctorDetailScreen> {
  bool _isSuspended = false;

  @override
  Widget build(BuildContext context) {
    const doctorName = 'Dr. Sara Khan';

    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        leading: RSIconButton.plain(
          icon: LucideIcons.chevronLeft,
          onPressed: () => context.pop(),
          semanticLabel: 'Back',
        ),
        title: Text('Doctor Profile', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: Row(
          children: [
            Expanded(
              child: RSButton.destructiveOutline(
                _isSuspended ? 'Reactivate' : 'Suspend',
                () {
                  AdminSuspendDialog.show(
                    context,
                    doctorName: doctorName,
                    isCurrentlySuspended: _isSuspended,
                    onConfirm: () {
                      setState(() => _isSuspended = !_isSuspended);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isSuspended ? 'Doctor suspended.' : 'Doctor reactivated.')),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RSButton.primary(
                'Edit doctor',
                () => context.push('/admin/doctors/${widget.doctorId}/edit'),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(RSSpacing.screenH),
          children: [
            // ── Doctor Info Header Card ───────────────────────────────
            RSCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _isSuspended ? RSColors.statusErrorTint : RSColors.brandMint,
                    child: Text(
                      'SK',
                      style: TextStyle(
                        color: _isSuspended ? RSColors.statusError : RSColors.brandGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctorName, style: RSText.headingH3),
                        const SizedBox(height: 2),
                        Text(
                          'Physiotherapist · City Rehab Clinic',
                          style: RSText.caption.copyWith(color: RSColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        RSStatusChip(
                          type: _isSuspended ? RSStatusChipType.incomplete : RSStatusChipType.correct,
                          customLabel: _isSuspended ? 'Suspended' : 'Active and Listed',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.md),

            // ── KPI Stats ─────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: RSStatTile(
                    label: 'Patients',
                    value: '12',
                    delta: 'Under care',
                    deltaPositive: true,
                  ),
                ),
                const SizedBox(width: RSSpacing.md),
                Expanded(
                  child: RSStatTile(
                    label: 'Exercises',
                    value: '5',
                    delta: 'Created',
                    deltaPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: RSSpacing.md),

            // ── Metadata Card ─────────────────────────────────────────
            RSCard(
              child: Column(
                children: [
                  _buildDetailRow('License Number', 'PMDC-48213'),
                  const Divider(height: 16),
                  _buildDetailRow('Clinical Specialties', 'Knee, Post-surgery, Orthopedic'),
                  const Divider(height: 16),
                  _buildDetailRow('Accepting New Patients', 'Yes'),
                  const Divider(height: 16),
                  _buildDetailRow('Registration Date', '12 Oct 2026'),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            // ── Privacy Guard Banner ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RSColors.surfaceCeramic,
                borderRadius: BorderRadius.circular(RSRadius.card),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.shieldCheck, color: RSColors.brandGreen, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Privacy Boundary: Staff administrators cannot view individual patient sessions, pain logs, or health conditions.',
                      style: RSText.caption.copyWith(color: RSColors.textSecondary),
                    ),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: RSText.bodySmall.copyWith(color: RSColors.textSecondary)),
        Text(value, style: RSText.bodySmallStrong),
      ],
    );
  }
}

