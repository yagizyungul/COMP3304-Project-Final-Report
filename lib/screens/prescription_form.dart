import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../utils/notification_service.dart';

class PrescriptionForm extends StatefulWidget {
  final String doctorName;

  const PrescriptionForm({super.key, required this.doctorName});

  @override
  State<PrescriptionForm> createState() => _PrescriptionFormState();
}

class _PrescriptionFormState extends State<PrescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<Map<String, TextEditingController>> medications = [];

  @override
  void initState() {
    super.initState();
    _addMedication(); // Başlangıçta bir ilaç
  }

  void _addMedication() {
    setState(() {
      medications.add({
        'name': TextEditingController(),
        'dosage': TextEditingController(),
        'timesPerDay': TextEditingController(),
        'days': TextEditingController(),
      });
    });
  }

  void _removeMedication(int index) {
    setState(() {
      medications.removeAt(index);
    });
  }

  void _submitPrescription() {
    if (_formKey.currentState?.validate() != true) return;

    final String patient = _patientController.text.trim();
    final String prescriptionId = const Uuid().v4();

    final List<Map<String, String>> meds =
        medications.map((m) {
          return {
            'name': m['name']!.text.trim(),
            'dosage': m['dosage']!.text.trim(),
            'timesPerDay': m['timesPerDay']!.text.trim(),
            'days': m['days']!.text.trim(),
          };
        }).toList();

    final prescription = {
      'id': prescriptionId,
      'doctor': widget.doctorName,
      'patient': patient,
      'medications': meds,
      'notes': _notesController.text.trim(),
      'date': DateTime.now().toIso8601String(),
    };

    NotificationService.sendNotification(
      message: 'Yeni reçete oluşturuldu.',
      sender: widget.doctorName,
      receiver: 'Pharmacist',
      type: 'prescription',
      relatedId: prescriptionId,
      payload: prescription,
    );

    _patientController.clear();
    _notesController.clear();
    medications.clear();
    _addMedication();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Reçete başarıyla gönderildi.')),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Gerekli' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                '📝 Yeni Reçete Oluştur',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_patientController, 'Hasta Adı'),
              const SizedBox(height: 20),
              const Text(
                '💊 İlaçlar',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 8),
              ...medications.asMap().entries.map((entry) {
                final index = entry.key;
                final fields = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.grey[850],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'İlaç ${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            if (index > 0)
                              IconButton(
                                onPressed: () => _removeMedication(index),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(fields['name']!, 'İlaç Adı'),
                        const SizedBox(height: 8),
                        _buildTextField(fields['dosage']!, 'Dozaj'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          fields['timesPerDay']!,
                          'Günde Kaç Kez',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          fields['days']!,
                          'Kaç Gün Boyunca',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              ElevatedButton.icon(
                onPressed: _addMedication,
                icon: const Icon(Icons.add),
                label: const Text('İlaç Ekle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(_notesController, 'Not (isteğe bağlı)'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submitPrescription,
                icon: const Icon(Icons.send),
                label: const Text('Reçeteyi Gönder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
