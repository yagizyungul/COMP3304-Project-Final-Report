import 'package:flutter/material.dart';

class HastaBilgileriScreen extends StatelessWidget {
  const HastaBilgileriScreen({super.key});

  void _showPatientDetailPopup(
    BuildContext context,
    Map<String, dynamic> patient,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        final List<dynamic> prescriptions = patient['prescriptions'] ?? [];
        final List<dynamic> testResults = patient['tests'] ?? [];

        return Dialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hasta: ${patient['name']}",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  "Yaş: ${patient['age']}",
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  "Kan Grubu: ${patient['blood']}",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Geçmiş Reçeteler:",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                if (prescriptions.isEmpty)
                  const Text(
                    "Reçete bulunamadı.",
                    style: TextStyle(color: Colors.white60),
                  ),
                ...prescriptions.map((presc) {
                  final List<String> meds = List<String>.from(
                    presc['medications'] ?? [],
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarih: ${presc['date']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      ...meds.map(
                        (med) => Text(
                          '- $med',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Not: ${presc['note']}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                      const Divider(color: Colors.white24, height: 25),
                    ],
                  );
                }),

                const SizedBox(height: 20),
                const Text(
                  "Test Sonuçları:",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                if (testResults.isEmpty)
                  const Text(
                    "Test sonucu yok.",
                    style: TextStyle(color: Colors.white60),
                  ),
                ...testResults.map((test) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Test: ${test['name']}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Sonuç: ${test['result']}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "Tarih: ${test['date']}",
                        style: const TextStyle(color: Colors.white60),
                      ),
                      const Divider(color: Colors.white24, height: 25),
                    ],
                  );
                }),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text(
                      "Kapat",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Örnek hasta verisi
    final patientData = {
      'name': 'Ayşe Yılmaz',
      'age': 35,
      'blood': 'A+',
      'prescriptions': [
        {
          'date': '2025-06-20',
          'medications': ['Parol 500mg', 'A-Ferin 200mg'],
          'note': 'Sabah akşam tok karnına',
        },
      ],
      'tests': [
        {'name': 'Kan Testi', 'result': 'Normal', 'date': '2025-06-18'},
      ],
    };

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Hasta Bilgileri"),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                "Hasta: Ayşe Yılmaz",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "Detayları görmek için dokunun",
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () => _showPatientDetailPopup(context, patientData),
              tileColor: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
