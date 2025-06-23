import 'package:flutter/material.dart';
import '../utils/notification_service.dart';

class DoctorTestResultsScreen extends StatefulWidget {
  const DoctorTestResultsScreen({super.key});

  @override
  State<DoctorTestResultsScreen> createState() =>
      _DoctorTestResultsScreenState();
}

class _DoctorTestResultsScreenState extends State<DoctorTestResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _filterResults();
  }

  void _filterResults() {
    final query = _searchController.text.trim().toLowerCase();

    final filtered =
        NotificationService.getNotificationsFor('Doctor')
            .where(
              (n) =>
                  (n.type == 'test_result' || n.type == 'test_result_update') &&
                  n.sender == 'Lab Technician' &&
                  (n.payload?['patient'] ?? '').toLowerCase().contains(query),
            )
            .map((n) => n.payload!)
            .toList();

    filtered.sort((a, b) {
      final aDate = DateTime.tryParse(a['date'] ?? '') ?? DateTime(1970);
      final bDate = DateTime.tryParse(b['date'] ?? '') ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });

    setState(() {
      _results = filtered;
    });
  }

  void _showAdditionalTestDialog(
    BuildContext context,
    Map<String, dynamic> test,
  ) {
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
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: noteController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Not (opsiyonel)',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () => Navigator.pop(ctx),
              ),
              ElevatedButton(
                onPressed: () {
                  final requestedTest = testController.text.trim();
                  final note = noteController.text.trim();
                  if (requestedTest.isNotEmpty) {
                    NotificationService.sendNotification(
                      sender: 'Doctor',
                      receiver: 'Lab Technician',
                      type: 'additional_test_request',
                      message:
                          'Hasta ${test['patient']} için ek test talebi: $requestedTest',
                      relatedId: test['id'] ?? '',
                      payload: {
                        'patient': test['patient'],
                        'requested_test': requestedTest,
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Gönder'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('🧪 Test Sonuçları'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '🔍 Hasta Adı ile Ara',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            onChanged: (_) => _filterResults(),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Örn: Ayşe Yılmaz',
              hintStyle: const TextStyle(color: Colors.white38),
              fillColor: Colors.grey[850],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_results.isEmpty)
            const Center(
              child: Text(
                'Hiç test sonucu bulunamadı.',
                style: TextStyle(color: Colors.white70),
              ),
            )
          else
            ..._results.map((test) {
              final date = DateTime.tryParse(test['date'] ?? '');
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
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Sonuç: ${test['result']}\nTarih: $formattedDate',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: TextButton.icon(
                    onPressed: () => _showAdditionalTestDialog(context, test),
                    icon: const Icon(Icons.add, color: Colors.orangeAccent),
                    label: const Text(
                      'Ek Talep',
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
