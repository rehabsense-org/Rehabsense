import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/tokens.dart';
import '../../core/widgets/widgets.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/models/models.dart';

class NotificationInboxScreen extends StatefulWidget {
  const NotificationInboxScreen({super.key});

  @override
  State<NotificationInboxScreen> createState() => _NotificationInboxScreenState();
}

class _NotificationInboxScreenState extends State<NotificationInboxScreen> {
  final _repo = NotificationRepository();
  late List<RSNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = List.from(_repo.getNotificationsSync());
  }

  void _dismiss(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
      _repo.dismiss(id);
    });
  }

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return LucideIcons.bell;
      case NotificationType.milestone:
        return LucideIcons.award;
      case NotificationType.tip:
        return LucideIcons.lightbulb;
    }
  }

  Color _colorForType(NotificationType type) {
    switch (type) {
      case NotificationType.reminder:
        return RSColors.brandAction;
      case NotificationType.milestone:
        return RSColors.accentGoldDeep;
      case NotificationType.tip:
        return RSColors.brandGreen;
    }
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
        title: const Text('Notifications'),
      ),
      body: _notifications.isEmpty
          ? const RSEmptyState(
              icon: LucideIcons.bellOff,
              title: "You're all caught up",
              body: 'Check back later for exercise reminders, weekly summaries, and milestone updates.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(RSSpacing.screenH),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                return Dismissible(
                  key: Key(notif.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: RSColors.statusError,
                      borderRadius: RSRadius.cardBR,
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(LucideIcons.trash2, color: Colors.white),
                  ),
                  onDismissed: (_) => _dismiss(notif.id),
                  child: RSCard(
                    color: notif.read ? RSColors.surfaceCard : RSColors.surfaceCard,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: notif.type == NotificationType.milestone
                                ? RSColors.accentGoldWash
                                : RSColors.brandMint,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _iconForType(notif.type),
                            size: 20,
                            color: _colorForType(notif.type),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      notif.title,
                                      style: RSText.bodyStrong.copyWith(
                                        fontWeight: notif.read
                                            ? FontWeight.w500
                                            : FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (!notif.read)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: RSColors.statusError,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif.body,
                                style: RSText.bodySmall.copyWith(
                                  color: RSColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                DateFormat.yMMMd().add_jm().format(notif.createdAt),
                                style: RSText.caption.copyWith(
                                  color: RSColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
