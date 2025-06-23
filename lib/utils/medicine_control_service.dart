// lib/utils/medicine_control_service.dart

import 'inventory_service.dart';

class MedicineControlService {
  // ✅ İlaç stoğu kontrolü
  static bool isAvailable(String medicineName, int requestedAmount) {
    final stock = InventoryService.getStock(medicineName);
    return stock >= requestedAmount;
  }

  // ✅ Reçete geçerlilik kontrolü (dummy olarak basit kontroller)
  static bool isPrescriptionValid(String medicineName, int amount) {
    if (medicineName.isEmpty || amount <= 0) {
      return false;
    }

    // Daha fazla kontrol eklenebilir (örnek: black list, expiry, vs.)
    return true;
  }
}
