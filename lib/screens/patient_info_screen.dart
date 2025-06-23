import 'package:flutter/material.dart';

class PatientInfoScreen extends StatelessWidget {
  const PatientInfoScreen({super.key});

  // 🧍‍♂️ Örnek hasta listesi
  final List<Map<String, String>> patients = const [
    {'name': 'Ayşe Yılmaz', 'id': 'P001'},
    {'name': 'Mehmet Kaya', 'id': 'P002'},
    {'name': 'Zeynep Demir', 'id': 'P003'},
    {'name': 'Ahmet Tunç', 'id': 'P004'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Hastalar', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];

          return Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(
                patient['name']!,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Hasta ID: ${patient['id']}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
              ),
              onTap: () {
                // Sonraki adımda hasta detayına gideceğiz
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => PatientDetailScreen(
                          patientId: patient['id']!,
                          name: patient['name']!,
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PatientDetailScreen extends StatelessWidget {
  final String patientId;
  final String name;

  const PatientDetailScreen({
    super.key,
    required this.patientId,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(name, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hasta ID: $patientId',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            const Text(
              '📄 Test Sonuçları ve Reçeteler buraya eklenecek.',
              style: TextStyle(color: Colors.white),
            ),
            // ⏩ Sonraki adım: buraya hastaya ait test sonuçları ve reçeteler bağlanacak
          ],
        ),
      ),
    );
  }
}
