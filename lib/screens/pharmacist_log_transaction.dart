import 'package:flutter/material.dart';

class PharmacistLogTransactionScreen extends StatelessWidget {
  const PharmacistLogTransactionScreen({super.key});

  final List<Map<String, dynamic>> transactionLogs = const [
    {
      'prescription': 'Reçete #1',
      'medicine': 'Parol 500mg',
      'quantity': 3,
      'timestamp': '2025-06-19 09:30',
    },
    {
      'prescription': 'Reçete #2',
      'medicine': 'Augmentin 1000mg',
      'quantity': 2,
      'timestamp': '2025-06-19 10:05',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('İlaç Teslim Kayıtları'),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView.builder(
        itemCount: transactionLogs.length,
        itemBuilder: (context, index) {
          final tx = transactionLogs[index];
          return Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                '${tx['medicine']} - ${tx['quantity']} adet',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${tx['prescription']} tarihinde verildi\n${tx['timestamp']}',
                style: const TextStyle(color: Colors.white70),
              ),
              isThreeLine: true,
              leading: const Icon(Icons.medication, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
