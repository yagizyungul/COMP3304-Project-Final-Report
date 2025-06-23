import 'package:flutter/material.dart';
import '../utils/notification_service.dart';

class TestDetailScreen extends StatelessWidget {
  final Map<String, dynamic> test;

  const TestDetailScreen({super.key, required this.test});

  void _showAdditionalTestDialog(BuildContext context, String patient) {
    final testController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              '➕ Ek Test Talebi',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: testController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Test Adı',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: noteController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Not (opsiyonel)',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  final testName = testController.text.trim();
                  final note = noteController.text.trim();
                  if (testName.isNotEmpty) {
                    NotificationService.sendNotification(
                      sender: 'Doctor',
                      receiver: 'Lab Technician',
                      type: 'additional_test_request',
                      message: '$patient için ek test talebi: $testName',
                      relatedId: test['id'] ?? '',
                      payload: {
                        'patient': patient,
                        'requested_test': testName,
                        'note': note,
                      },
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ek test talebi gönderildi'),
                      ),
                    );
                  }
                },
                child: const Text('Gönder'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final patient = test['patient'] ?? 'Bilinmiyor';
    final name = test['name'] ?? 'Test';
    final date = test['date'] ?? 'Yok';
    final result = test['result'] ?? 'Sonuç yok';
    final labNotes = test['lab_notes'] ?? 'Not yok';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('🔬 Test Detayı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👤 Hasta: $patient',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '📋 Test: $name',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              '🧪 Sonuç: $result',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              '📅 Tarih: $date',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              '📝 Laboratuvar Notu: $labNotes',
              style: const TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showAdditionalTestDialog(context, patient),
                icon: const Icon(Icons.add),
                label: const Text("Ek Test Talebi"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
