import 'package:flutter/material.dart';
import '../utils/notification_service.dart';
import 'lab_test_entry_screen.dart';

class LabTestRequestsScreen extends StatelessWidget {
  const LabTestRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requests =
        NotificationService.getNotificationsFor(
          'Lab Technician',
        ).where((n) => n.type == 'additional_test_request').toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('🔁 Ek Test Talepleri'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body:
          requests.isEmpty
              ? const Center(
                child: Text(
                  'Hiç ek test talebi yok.',
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView.builder(
                itemCount: requests.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final notif = requests[index];
                  final payload = notif.payload ?? {};
                  final patient = payload['patient'] ?? 'Bilinmeyen';
                  final testName = payload['requested_test'] ?? '';
                  final note = payload['note'] ?? '';

                  return Card(
                    color: Colors.grey[850],
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        '$patient için: $testName',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle:
                          note.isNotEmpty
                              ? Text(
                                'Not: $note',
                                style: const TextStyle(color: Colors.white70),
                              )
                              : null,
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.lightBlueAccent,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => LabTestEntryScreen(
                                    initialPatient: patient,
                                    initialTestName: testName,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
