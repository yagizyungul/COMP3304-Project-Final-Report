import 'package:flutter/material.dart';
import '../utils/inventory_service.dart';
import '../utils/notification_service.dart';
import 'package:uuid/uuid.dart';

class PharmacistStocksScreen extends StatefulWidget {
  const PharmacistStocksScreen({super.key});

  @override
  State<PharmacistStocksScreen> createState() => _PharmacistStocksScreenState();
}

class _PharmacistStocksScreenState extends State<PharmacistStocksScreen> {
  void _orderMedicineDialog(BuildContext context, String medicineName) {
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              '💊 $medicineName için Sipariş',
              style: const TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Sipariş miktarı',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final qty = int.tryParse(quantityController.text);
                  if (qty != null && qty > 0) {
                    // Stoğa ekle
                    InventoryService.addOrUpdateMedicine(medicineName, qty);

                    // Bildirim: Sistem
                    NotificationService.sendNotification(
                      message:
                          '$medicineName için $qty adet sipariş eklendi ve stok güncellendi.',
                      sender: 'Pharmacist',
                      receiver: 'System',
                      type: 'Stock Order',
                      relatedId: const Uuid().v4(),
                      payload: {'medicine': medicineName, 'quantity': qty},
                    );

                    // Bildirim: Bakanlık
                    NotificationService.sendNotification(
                      message:
                          'Eczacı tarafından $medicineName için $qty adet sipariş verildi.',
                      sender: 'Pharmacist',
                      receiver: 'Ministry',
                      type: 'Bakanlık Bildirimi',
                      relatedId: const Uuid().v4(),
                    );

                    // Bildirim: Hasta
                    NotificationService.sendNotification(
                      message:
                          '$medicineName sipariş edildi. Hazırlandığında size bildirilecek.',
                      sender: 'Pharmacist',
                      receiver: 'Patient',
                      type: 'İlaç Bilgilendirme',
                      relatedId: const Uuid().v4(),
                    );

                    Navigator.pop(ctx);
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                ),
                child: const Text('Onayla'),
              ),
            ],
          ),
    );
  }

  void _addNewMedicineDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              '➕ Yeni İlaç Ekle',
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'İlaç Adı',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    Navigator.pop(ctx);
                    _orderMedicineDialog(context, name);
                  }
                },
                child: const Text('İlerle'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventory = InventoryService.getAllInventory();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('📦 Eczane Stokları'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Yeni İlaç Ekle',
            onPressed: _addNewMedicineDialog,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: inventory.length,
        itemBuilder: (context, index) {
          final entry = inventory.entries.elementAt(index);
          final name = entry.key;
          final quantity = entry.value;
          final isLow = quantity <= 3;

          return Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                'Miktar: $quantity adet',
                style: TextStyle(
                  color: isLow ? Colors.redAccent : Colors.white70,
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () => _orderMedicineDialog(context, name),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                child: const Text('Sipariş Ver'),
              ),
            ),
          );
        },
      ),
    );
  }
}
