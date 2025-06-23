import 'package:flutter/material.dart';
import '../utils/notification_service.dart';
import 'test_detail_screen.dart';

class TestResultsScreen extends StatefulWidget {
  const TestResultsScreen({super.key});

  @override
  State<TestResultsScreen> createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allTests = [];
  List<Map<String, dynamic>> _filteredTests = [];

  @override
  void initState() {
    super.initState();
    _loadTests();
    _searchController.addListener(_filterTests);
  }

  void _loadTests() {
    final all =
        NotificationService.getNotificationsFor('Doctor')
            .where((n) => n.type == 'test_result')
            .map((n) => n.payload ?? {})
            .toList();

    setState(() {
      _allTests = all;
      _filteredTests = all;
    });
  }

  void _filterTests() {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredTests = _allTests;
      });
    } else {
      final filtered =
          _allTests.where((test) {
            final patient = (test['patient'] ?? '').toLowerCase();
            final testName = (test['name'] ?? '').toLowerCase();
            return patient.contains(query) || testName.contains(query);
          }).toList();

      setState(() {
        _filteredTests = filtered;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('🧪 Test Sonuçları'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Hasta veya test adı ara...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _filteredTests.isEmpty
                      ? const Center(
                        child: Text(
                          'Test sonucu bulunamadı.',
                          style: TextStyle(color: Colors.white60),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _filteredTests.length,
                        itemBuilder: (context, index) {
                          final test = _filteredTests[index];
                          final patient = test['patient'] ?? 'Bilinmiyor';
                          final name = test['name'] ?? 'Test';
                          final date = test['date'] ?? 'Tarih yok';
                          final result = test['result'] ?? 'Yok';

                          return Card(
                            color: Colors.grey[850],
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                '$patient - $name',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Sonuç: $result\nTarih: $date',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white70,
                                size: 18,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => TestDetailScreen(test: test),
                                  ),
                                );
                              },
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
