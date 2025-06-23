import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../utils/lab_data_service.dart';
import '../utils/notification_service.dart';
import '../models/notification_model.dart';

class LabTestEntryScreen extends StatefulWidget {
  final String? initialPatient;
  final String? initialTestName;
  const LabTestEntryScreen({
    super.key,
    this.initialPatient,
    this.initialTestName,
  });

  @override
  State<LabTestEntryScreen> createState() => _LabTestEntryScreenState();
}

class _LabTestEntryScreenState extends State<LabTestEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientName = TextEditingController();
  final TextEditingController _testName = TextEditingController();
  final TextEditingController _result = TextEditingController();

  NotificationModel? _selectedRequest;

  List<NotificationModel> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    _requests =
        NotificationService.getNotificationsFor(
          'Lab Technician',
        ).where((n) => n.type == 'additional_test_request').toList();
    setState(() {});
  }

  void _fillFormFromRequest(NotificationModel request) {
    _selectedRequest = request;
    _patientName.text = request.payload?['patient'] ?? '';
    _testName.text = request.payload?['requested_test'] ?? '';
  }

  void _submitTest() {
    if (!_formKey.currentState!.validate()) return;

    final newTest = {
      'id': const Uuid().v4(),
      'patient': _patientName.text.trim(),
      'name': _testName.text.trim(),
      'result': _result.text.trim(),
      'date': DateTime.now().toIso8601String(),
    };

    LabDataService.addTestResult(newTest);

    NotificationService.sendNotification(
      sender: 'Lab Technician',
      receiver: 'Doctor',
      type: 'test_result',
      message:
          '📤 ${newTest['patient']} için test sonucu gönderildi: ${newTest['name']}',
      relatedId: newTest['id']!,
      payload: newTest,
    );

    if (_selectedRequest != null) {
      NotificationService.deleteNotification(_selectedRequest!.id);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Test sonucu başarıyla eklendi.')),
    );

    _patientName.clear();
    _testName.clear();
    _result.clear();
    _selectedRequest = null;
    _loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('🧪 Test Sonucu Girişi'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (_requests.isNotEmpty) ...[
              const Text(
                '🔔 Gelen Ek Test Talepleri',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 8),
              for (final r in _requests)
                Card(
                  color: Colors.grey[850],
                  child: ListTile(
                    title: Text(
                      r.payload?['patient'] ?? 'Hasta',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      r.payload?['requested_test'] ?? 'Test',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(
                      Icons.edit,
                      color: Colors.orangeAccent,
                    ),
                    onTap: () => _fillFormFromRequest(r),
                  ),
                ),
              const Divider(color: Colors.white30),
              const SizedBox(height: 16),
            ],
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildInput(_patientName, 'Hasta Adı'),
                    const SizedBox(height: 12),
                    _buildInput(_testName, 'Test Adı'),
                    const SizedBox(height: 12),
                    _buildInput(_result, 'Sonuç'),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Kaydet'),
                      onPressed: _submitTest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 28,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Zorunlu alan' : null,
    );
  }
}
