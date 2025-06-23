import 'package:flutter/material.dart';
import '../utils/notification_service.dart';
import '../screens/lab_test_entry_screen.dart';

class NotificationScreen extends StatefulWidget {
  final String role;
  const NotificationScreen({super.key, required this.role});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notifications = NotificationService.getNotificationsFor(widget.role);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('📢 Bildirimler'),
      ),
      body:
          notifications.isEmpty
              ? const Center(
                child: Text(
                  'Hiç bildiriminiz yok.',
                  style: TextStyle(color: Colors.white54),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  final isUnread = !notif.isRead;
                  final payload = notif.payload ?? {};
                  final timestamp = notif.timestamp;

                  return Card(
                    color: isUnread ? Colors.grey[800] : Colors.grey[900],
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        notif.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        timestamp.toLocal().toString().split('.')[0],
                        style: const TextStyle(color: Colors.white60),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (notif.type == 'additional_test_request')
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => LabTestEntryScreen(
                                          initialPatient: payload['patient'],
                                          initialTestName:
                                              payload['requested_test'],
                                        ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text('Görüntüle'),
                            ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (ctx) => AlertDialog(
                                      backgroundColor: const Color(0xFF1E1E1E),
                                      title: const Text(
                                        'Bildirim Sil',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: const Text(
                                        'Bu bildirimi silmek istiyor musunuz?',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('İptal'),
                                          onPressed:
                                              () => Navigator.pop(ctx, false),
                                        ),
                                        TextButton(
                                          child: const Text(
                                            'Sil',
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          onPressed:
                                              () => Navigator.pop(ctx, true),
                                        ),
                                      ],
                                    ),
                              );

                              if (confirm == true) {
                                NotificationService.deleteNotification(
                                  notif.id,
                                );
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        NotificationService.markAsRead(notif);
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
    );
  }
}
