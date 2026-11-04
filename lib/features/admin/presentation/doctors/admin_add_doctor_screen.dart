import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/tokens.dart';
import '../../../../core/widgets/widgets.dart';

class AdminAddDoctorScreen extends StatefulWidget {
  const AdminAddDoctorScreen({super.key});

  @override
  State<AdminAddDoctorScreen> createState() => _AdminAddDoctorScreenState();
}

class _AdminAddDoctorScreenState extends State<AdminAddDoctorScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _licenseController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  void _createDoctor() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Doctor account created. Invitation sent via email.')),
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
        title: Text('Add Doctor', style: RSText.bodyStrong),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: RSColors.surfaceCard,
          boxShadow: RSShadows.nav,
        ),
        child: RSButton.primary(
          'Create doctor',
          _createDoctor,
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
                      'Creates a pre-approved doctor account who sets their password via email invitation.',
                      style: RSText.caption.copyWith(color: RSColors.brandGreen),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RSSpacing.lg),

            RSInput(
              label: 'Full Name',
              hintText: 'e.g. Dr. Sara Khan',
              prefixIcon: LucideIcons.user,
              controller: _nameController,
            ),
            const SizedBox(height: RSSpacing.md),

            RSInput(
              label: 'Work Email',
              hintText: 'e.g. sara.khan@clinic.com',
              prefixIcon: LucideIcons.mail,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            const SizedBox(height: RSSpacing.md),

            RSInput(
              label: 'License Number',
              hintText: 'e.g. PMDC-48213',
              prefixIcon: LucideIcons.fileText,
              controller: _licenseController,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

