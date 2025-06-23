import 'package:flutter/material.dart';
import 'pharmacist_prescriptions.dart';
import 'pharmacist_stocks.dart';
import 'pharmacist_profile.dart';
import '../login_screen.dart';
import 'notification_screen.dart';
import '../utils/notification_service.dart';

class PharmacistDashboard extends StatefulWidget {
  final String username;
  const PharmacistDashboard({super.key, required this.username});

  @override
  State<PharmacistDashboard> createState() => _PharmacistDashboardState();
}

class _PharmacistDashboardState extends State<PharmacistDashboard> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const PharmacistPrescriptions(),
      const PharmacistStocksScreen(),
      PharmacistProfile(username: widget.username),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        NotificationService.getNotificationsFor(
          'Pharmacist',
        ).where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('Pharmacist Dashboard'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const NotificationScreen(role: 'Pharmacist'),
                    ),
                  ).then((_) => setState(() {}));
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Reçeteler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Stoklar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Gerçekten çıkmak istiyor musunuz?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text('Hayır', style: TextStyle(color: Colors.blue)),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            TextButton(
              child: const Text(
                'Evet',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
