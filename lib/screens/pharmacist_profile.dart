import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../utils/inventory_service.dart';
import '../utils/notification_service.dart';

class PharmacistProfile extends StatelessWidget {
  final String username;

  const PharmacistProfile({super.key, required this.username});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Çıkış Yap',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Çıkmak istediğinizden emin misiniz?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Colors.white70),
                ),
                onPressed: () => Navigator.pop(ctx),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Evet'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        NotificationService.getNotificationsFor(
          'Pharmacist',
        ).where((n) => !n.isRead).length;

    final totalStock = InventoryService.getAllInventory().values.fold(
      0,
      (a, b) => a + b,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('👤 Profil'),
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/pharmacist.png'),
              backgroundColor: Colors.blueGrey,
            ),
            const SizedBox(height: 12),
            Text(
              'Ecz. $username',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kullanıcı adı: $username',
              style: const TextStyle(color: Colors.white60),
            ),
            const Text('Rol: Eczacı', style: TextStyle(color: Colors.white60)),
            const Text(
              'Çalıştığı Yer: Yıldız Eczanesi',
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.grey[850],
              child: ListTile(
                leading: const Icon(Icons.inventory, color: Colors.tealAccent),
                title: const Text(
                  'Toplam Stoktaki İlaç Sayısı',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '$totalStock adet',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.grey[850],
              child: ListTile(
                leading: const Icon(
                  Icons.notifications,
                  color: Colors.amberAccent,
                ),
                title: const Text(
                  'Okunmamış Bildirim',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '$unreadCount',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Çıkış Yap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
