import 'package:flutter/material.dart';
import '../login_screen.dart';
import '../utils/notification_service.dart';
import '../utils/lab_data_service.dart';

class LabProfileScreen extends StatelessWidget {
  final String username;

  const LabProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final testCount = LabDataService.getAllTests().length;
    final notifCount =
        NotificationService.getNotificationsFor('Lab Technician').length;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('👤 Profil'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoTile("👨‍🔬 Kullanıcı Adı", username),
            const SizedBox(height: 16),
            _infoTile("🧪 Kaydedilen Test Sayısı", '$testCount'),
            _infoTile("🔔 Bildirim Sayısı", '$notifCount'),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                LabDataService.clearAllTests();
                NotificationService.clearAll();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Tüm veriler başarıyla temizlendi."),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.delete_forever),
              label: const Text("Tüm Verileri Temizle"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Çıkış Yap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
