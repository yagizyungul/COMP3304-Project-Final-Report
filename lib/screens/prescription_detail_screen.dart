import 'package:flutter/material.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> prescription;

  const PrescriptionDetailScreen({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> medications = prescription['medications'] ?? [];
    final String formattedDate =
        DateTime.tryParse(
          prescription['date'] ?? '',
        )?.toLocal().toString().split(' ')[0] ??
        '';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Reçete Detayı',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reçete ID: ${prescription['id']}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Text(
                  'Hasta: ${prescription['patient']}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Doktor: Dr. ${prescription['doctor']}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tarih: $formattedDate',
                  style: const TextStyle(color: Colors.white70),
                ),
                const Divider(color: Colors.white38, height: 30),
                const Text(
                  'İlaçlar:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...medications.map((med) {
                  final name = med['name'] ?? '-';
                  final dosage = med['dosage'] ?? '-';
                  final frequency = med['timesPerDay'] ?? '-';
                  final duration = med['days'] ?? '-';
                  final timing = med['timing'] ?? '-';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '- $name ($dosage) → Günde $frequency kez, $duration gün, $timing',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                const Text(
                  'Not:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  prescription['notes'] ?? '-',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
