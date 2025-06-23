import 'package:flutter/material.dart';
import '../utils/lab_data_service.dart';
import '../utils/notification_service.dart';

class LabTestListScreen extends StatefulWidget {
  const LabTestListScreen({super.key});

  @override
  State<LabTestListScreen> createState() => _LabTestListScreenState();
}

class _LabTestListScreenState extends State<LabTestListScreen> {
  List<Map<String, dynamic>> tests = [];

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  void _loadTests() {
    setState(() {
      tests = LabDataService.getAllTests();
    });
  }

  void _showUpdateDialog(int index) {
    final test = tests[index];
    final TextEditingController resultController = TextEditingController(
      text: test['result'],
    );

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Sonucu Güncelle',
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: resultController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Yeni Sonuç',
                labelStyle: TextStyle(color: Colors.white70),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final updatedResult = resultController.text.trim();
                  if (updatedResult.isNotEmpty) {
                    LabDataService.updateTestResult(test['id'], updatedResult);

                    NotificationService.sendNotification(
                      message:
                          'Test sonucu güncellendi: ${test['name']} (${test['patient']})',
                      sender: 'Lab Technician',
                      receiver: 'Doctor',
                      type: 'test_result_update',
                      relatedId: test['id'],
                      payload: test,
                    );

                    Navigator.pop(ctx);
                    _loadTests();
                  }
                },
                child: const Text('Güncelle'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                backgroundColor: Colors.grey[900],
                title: const Text(
                  'Çıkmak istiyor musunuz?',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Hayır'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Evet'),
                  ),
                ],
              ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child:
              tests.isEmpty
                  ? const Center(
                    child: Text(
                      'Hiç test sonucu girilmemiş.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                  : ListView.builder(
                    itemCount: tests.length,
                    itemBuilder: (context, index) {
                      final test = tests[index];
                      final date =
                          DateTime.tryParse(test['date'] ?? '')?.toLocal();
                      final formattedDate =
                          date != null
                              ? '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}'
                              : 'Tarih yok';

                      return Card(
                        color: Colors.grey[850],
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(
                            '${test['patient']} - ${test['name']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Sonuç: ${test['result']}\nTarih: $formattedDate',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () => _showUpdateDialog(index),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
