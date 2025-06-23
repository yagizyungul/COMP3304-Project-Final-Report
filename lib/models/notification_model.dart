class NotificationModel {
  final String id;
  final String message;
  final String sender;
  final String receiver;
  final String type;
  final String relatedId;
  final DateTime timestamp;
  final Map<String, dynamic>? payload;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.message,
    required this.sender,
    required this.receiver,
    required this.type,
    required this.relatedId,
    required this.timestamp,
    this.payload,
    this.isRead = false, // ❗️Varsayılan false verildi
  });
}
