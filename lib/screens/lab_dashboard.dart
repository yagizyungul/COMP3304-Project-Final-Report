import 'package:flutter/material.dart';
import 'lab_test_entry_screen.dart';
import 'lab_test_list_screen.dart';
import 'lab_profile_screen.dart';
import 'notification_screen.dart';
import '../login_screen.dart';
import '../utils/notification_service.dart';

class LabDashboard extends StatefulWidget {
  final String username;

  const LabDashboard({super.key, required this.username});

  @override
  State<LabDashboard> createState() => _LabDashboardState();
}

class _LabDashboardState extends State<LabDashboard> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const LabTestEntryScreen(),
      const LabTestListScreen(),
      LabProfileScreen(username: widget.username),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        NotificationService.getNotificationsFor(
          'Lab Technician',
        ).where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 9, 13),
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('Lab Teknisyeni - ${widget.username}'),
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
                          (_) =>
                              const NotificationScreen(role: 'Lab Technician'),
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
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Test Girişi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Sonuçlar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              'Çıkış Yap',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Gerçekten çıkmak istiyor musunuz?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  'İptal',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Evet',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );
  }
}
