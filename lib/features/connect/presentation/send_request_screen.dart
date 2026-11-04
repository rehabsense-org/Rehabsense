import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/tokens.dart';
import '../../../core/widgets/widgets.dart';

class SendRequestScreen extends StatefulWidget {
  final String doctorId;

  const SendRequestScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<SendRequestScreen> createState() => _SendRequestScreenState();
}

class _SendRequestScreenState extends State<SendRequestScreen> {
  final _messageController = TextEditingController(
    text: 'Hello doctor, I would like guidance for my knee recovery after surgery.',
  );
  bool _consentGiven = true;
  bool _submitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    if (!_consentGiven) return;

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _submitting = false);
    context.go('/connect/status');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RSColors.surfaceCanvas,
      appBar: AppBar(
        title: Text(
          'Send request',
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
                    Text('Send to Dr. Sara Khan', style: RSText.headingH2),
                    const SizedBox(height: RSSpacing.xs),
                    Text(
                      'Your chosen doctor will review this summary of your condition before deciding to accept.',
                      style: RSText.bodySmall.copyWith(color: RSColors.textSecondary),
                    ),
                    const SizedBox(height: RSSpacing.lg),

                    RSCard(
                      padding: const EdgeInsets.all(RSSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Condition summary', style: RSText.bodyStrong),
                          const SizedBox(height: RSSpacing.sm),
                          _buildKv('Body area', 'Right knee'),
                          const Divider(),
                          _buildKv('Duration', '2-6 weeks'),
                          const Divider(),
                          _buildKv('Pain baseline', '4 / 10'),
                          const Divider(),
                          _buildKv('Goal', 'Walk without pain'),
                        ],
                      ),
                    ),
                    const SizedBox(height: RSSpacing.lg),

                    RSInput(
                      label: 'Message for doctor (optional)',
                      controller: _messageController,
                      hintText: 'Share any specific question or context...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: RSSpacing.lg),

                    RSCard(
                      padding: const EdgeInsets.all(RSSpacing.md),
                      color: RSColors.brandMint,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _consentGiven,
                            activeColor: RSColors.brandGreen,
                            onChanged: (val) => setState(() => _consentGiven = val ?? false),
                          ),
                          const SizedBox(width: RSSpacing.xs),
                          Expanded(
                            child: Text(
                              'I agree to share my condition summary and future exercise session scores with Dr. Sara Khan. I can disconnect at any time from my profile.',
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
                'Send request',
                _consentGiven ? _submitRequest : null,
                loading: _submitting,
                disabled: !_consentGiven,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKv(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: RSText.bodySmall.copyWith(color: RSColors.textSecondary)),
          Text(value, style: RSText.bodySmallStrong),
        ],
      ),
    );
  }
}

