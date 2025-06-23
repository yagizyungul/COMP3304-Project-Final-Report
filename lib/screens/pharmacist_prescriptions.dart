import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../utils/notification_service.dart';
import '../screens/prescription_detail_screen.dart'; // EKSİKSİZ PATH

class PharmacistPrescriptions extends StatelessWidget {
  const PharmacistPrescriptions({super.key});

  @override
  Widget build(BuildContext context) {
    final prescriptions =
        NotificationService.getNotificationsFor(
          'Pharmacist',
        ).where((n) => n.type == 'prescription').toList();

    if (prescriptions.isEmpty) {
      return const Center(
        child: Text(
          'Gösterilecek reçete bulunamadı.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prescriptions.length,
      itemBuilder: (context, index) {
        final notif = prescriptions[index];
        final timestamp = notif.timestamp;
        final formattedTime =
            '${timestamp.day.toString().padLeft(2, '0')}.${timestamp.month.toString().padLeft(2, '0')}.${timestamp.year} '
            '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';

        return Card(
          color: Colors.grey[850],
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              notif.message,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Gönderen: ${notif.sender}\n$formattedTime',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
            ),
            onTap: () {
              if (notif.payload != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => PrescriptionDetailScreen(
                          prescription: notif.payload!,
                        ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Reçete verisi eksik.")),
                );
              }
            },
          ),
        );
      },
    );
  }
}
