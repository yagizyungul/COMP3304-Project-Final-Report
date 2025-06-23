import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final List<NotificationModel> _notifications = [];

  // 🔔 Bildirim gönderme
  static void sendNotification({
    required String message,
    required String sender,
    required String receiver,
    required String type,
    required String relatedId,
    Map<String, dynamic>? payload,
  }) {
    final notification = NotificationModel(
      id: const Uuid().v4(),
      message: message,
      sender: sender,
      receiver: receiver,
      type: type,
      relatedId: relatedId,
      timestamp: DateTime.now(),
      payload: payload,
    );

    _notifications.insert(0, notification);

    // 👇 Bakanlığa log
    if (receiver != 'Ministry') {
      _notifications.insert(
        0,
        NotificationModel(
          id: const Uuid().v4(),
          message: '[Bakanlık Log] $message',
          sender: sender,
          receiver: 'Ministry',
          type: 'log',
          relatedId: relatedId,
          timestamp: DateTime.now(),
          payload: payload,
        ),
      );
    }

    // 👇 Hastaya bilgi
    if (payload != null && payload.containsKey('patient')) {
      _notifications.insert(
        0,
        NotificationModel(
          id: const Uuid().v4(),
          message: '[Bilgi] ${payload['patient']} için: $message',
          sender: sender,
          receiver: 'Patient',
          type: 'info',
          relatedId: relatedId,
          timestamp: DateTime.now(),
          payload: payload,
        ),
      );
    }

    debugPrint('🔔 [$receiver] $message @ ${notification.timestamp}');
  }

  // 🔍 Rol bazlı bildirimleri getir
  static List<NotificationModel> getNotificationsFor(String receiver) {
    return _notifications.where((n) => n.receiver == receiver).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // ✅ Okundu olarak işaretle
  static void markAsRead(NotificationModel notification) {
    notification.isRead = true;
  }

  // 🗑️ Bildirim silme
  static void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
  }

  // 🔁 Tüm bildirimleri oku
  static List<NotificationModel> getAll() => List.unmodifiable(_notifications);

  // 🚫 Tüm bildirimi temizle (admin/dev tool için)
  static void clearAll() {
    _notifications.clear();
  }
}
