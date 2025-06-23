import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../utils/notification_service.dart';
import '../utils/inventory_service.dart';

class PharmacistDispenseScreen extends StatelessWidget {
  const PharmacistDispenseScreen({super.key});

  final List<Map<String, dynamic>> prescriptions = const [
    {'name': 'Parol 500mg', 'amount': 3},
    {'name': 'Aferin Forte', 'amount': 1},
    {'name': 'Augmentin 1000mg', 'amount': 2},
  ];

  void _sendDispenseNotification(
    BuildContext context,
    String medicine,
    int quantity,
  ) {
    final success = InventoryService.reduceMedicine(medicine, quantity);

    if (success) {
      NotificationService.sendNotification(
        message: '$medicine ($quantity adet) teslim edildi.',
        sender: 'Pharmacist',
        receiver: 'Doctor',
        type: 'İlaç Teslimi',
        relatedId: const Uuid().v4(),
        payload: {'medicine': medicine, 'amount': quantity},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$medicine ($quantity adet) teslim edildi.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yetersiz stok!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('💊 İlaç Teslim Et'),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView.builder(
        itemCount: prescriptions.length,
        itemBuilder: (context, index) {
          final item = prescriptions[index];
          final medicine = item['name'];
          final amount = item['amount'];
          final available = InventoryService.checkAvailability(
            medicine,
            amount,
          );

          return Card(
            color: available ? Colors.grey[850] : Colors.grey[800],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                medicine,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Miktar: $amount adet',
                style: TextStyle(
                  color: available ? Colors.white70 : Colors.redAccent,
                ),
              ),
              trailing: ElevatedButton(
                onPressed:
                    available
                        ? () =>
                            _sendDispenseNotification(context, medicine, amount)
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: available ? Colors.teal : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Teslim Et'),
              ),
            ),
          );
        },
      ),
    );
  }
}
