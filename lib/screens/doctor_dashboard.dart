import 'package:flutter/material.dart';
import 'prescription_form.dart';
import 'test_results_screen.dart';
import 'hasta_bilgileri_screen.dart';
import '../login_screen.dart';
import 'notification_screen.dart';
import '../utils/notification_service.dart';

class DoctorDashboard extends StatefulWidget {
  final String username; // 👈 Ekledik

  const DoctorDashboard({super.key, required this.username});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      PrescriptionForm(
        doctorName: widget.username,
      ), // 👈 Doktor adı gönderiliyor
      const TestResultsScreen(),
      const HastaBilgileriScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        NotificationService.getNotificationsFor(
          'Doctor',
        ).where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: Text(
          'Doctor Dashboard - ${widget.username}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.local_hospital, color: Colors.white, size: 28),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(role: 'Doctor'),
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
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Reçete'),
          BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Testler'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Hastalar'),
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
