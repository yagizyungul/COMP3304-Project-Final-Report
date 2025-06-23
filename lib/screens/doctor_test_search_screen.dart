import 'package:flutter/material.dart';
import '../utils/notification_service.dart';

class DoctorTestSearchScreen extends StatefulWidget {
  const DoctorTestSearchScreen({super.key});

  @override
  State<DoctorTestSearchScreen> createState() => _DoctorTestSearchScreenState();
}

class _DoctorTestSearchScreenState extends State<DoctorTestSearchScreen> {
  final TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> filteredResults = [];

  void _filterResults() {
    final String query = _nameController.text.trim().toLowerCase();

    final notifications =
        NotificationService.getNotificationsFor('Doctor')
            .where(
              (n) =>
                  (n.type == 'test_result' || n.type == 'test_result_update') &&
                  n.payload != null &&
                  (n.payload!['patient']?.toLowerCase() ?? '').contains(query),
            )
            .map((n) => n.payload!)
            .toList();

    setState(() {
      filteredResults = notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Test Sonuçları'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Hasta Adı ile Ara:',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Örn: Ayşe Yılmaz',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _filterResults,
              icon: const Icon(Icons.search),
              label: const Text('Sonuçları Göster'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  filteredResults.isEmpty
                      ? const Center(
                        child: Text(
                          'Sonuç bulunamadı.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredResults.length,
                        itemBuilder: (context, index) {
                          final result = filteredResults[index];
                          final date =
                              DateTime.tryParse(
                                result['date'] ?? '',
                              )?.toLocal();
                          final formattedDate =
                              date != null
                                  ? '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}'
                                  : 'Tarih yok';

                          return Card(
                            color: Colors.grey[850],
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                '${result['patient']} - ${result['name']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Sonuç: ${result['result']}\nTarih: $formattedDate',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
