import 'package:flutter/material.dart';

class PharmacistNotify extends StatelessWidget {
  const PharmacistNotify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Bakanlığa Bildir'),
        backgroundColor: Colors.grey[900],
      ),
      body: const Center(
        child: Text(
          'Bildirim onayı veya rapor gönderimi yapılacak.',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
