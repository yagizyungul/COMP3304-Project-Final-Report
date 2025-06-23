import 'package:flutter/material.dart';

class PharmacistOrder extends StatelessWidget {
  const PharmacistOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Tedarik Siparişi'),
        backgroundColor: Colors.grey[900],
      ),
      body: const Center(
        child: Text(
          'Stokta olmayan ilaçlar için sipariş verilecek.',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
