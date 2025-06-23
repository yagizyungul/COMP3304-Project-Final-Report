import 'package:flutter/material.dart';
import 'models/users.dart';

import 'screens/doctor_dashboard.dart' as doctor;
import 'screens/lab_dashboard.dart' as lab;
import 'screens/pharmacist_dashboard.dart' as pharma;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = '';
  String input = '';
  String password = '';
  bool showPassword = false;

  void _login() {
    if (selectedRole.isEmpty || input.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }

    final roleUsers = users[selectedRole];
    final match = roleUsers?.firstWhere(
      (user) =>
          (user['email'] == input || user['username'] == input) &&
          user['password'] == password,
      orElse: () => {},
    );

    if (match != null && match.isNotEmpty) {
      String username = match['username']!;

      Widget targetPage;
      switch (selectedRole) {
        case 'Doctor':
          targetPage = doctor.DoctorDashboard(username: username);
          break;
        case 'Lab Technician':
          ;
          targetPage = lab.LabDashboard(username: username);
          break;
        case 'Pharmacist':
          targetPage = pharma.PharmacistDashboard(username: username);
          break;
        default:
          targetPage = doctor.DoctorDashboard(username: username);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarılı. Hoş geldin $username')),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => targetPage),
        );
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Giriş bilgileri hatalı.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'HospFlow Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.health_and_safety,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.grey[850],
                decoration: const InputDecoration(
                  labelText: 'Rol Seçiniz',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                value: selectedRole.isEmpty ? null : selectedRole,
                items:
                    ['Doctor', 'Lab Technician', 'Pharmacist']
                        .map(
                          (role) =>
                              DropdownMenuItem(value: role, child: Text(role)),
                        )
                        .toList(),
                onChanged: (val) => setState(() => selectedRole = val!),
              ),
              const SizedBox(height: 16),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Email veya Kullanıcı Adı',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => input = val,
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: !showPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed:
                        () => setState(() => showPassword = !showPassword),
                  ),
                ),
                onChanged: (val) => password = val,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Giriş Yap'),
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
