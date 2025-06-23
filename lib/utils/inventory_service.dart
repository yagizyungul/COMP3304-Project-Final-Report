class InventoryService {
  // Başlangıçta örnek verilerle stok
  static final Map<String, int> _inventory = {
    'Parol 500mg': 10,
    'Aferin Forte': 0,
    'Augmentin 1000mg': 5,
  };

  /// ✅ İlaç stoğunu ekler veya artırır
  static void addOrUpdateMedicine(String medicineName, int quantity) {
    if (_inventory.containsKey(medicineName)) {
      _inventory[medicineName] = _inventory[medicineName]! + quantity;
    } else {
      _inventory[medicineName] = quantity;
    }
  }

  /// ✅ Stoktan ilaç düşür (örneğin teslim sırasında)
  static bool reduceMedicine(String medicineName, int quantity) {
    if (checkAvailability(medicineName, quantity)) {
      _inventory[medicineName] = _inventory[medicineName]! - quantity;
      return true;
    }
    return false;
  }

  /// ✅ İstenilen miktarda stok var mı kontrol et
  static bool checkAvailability(String medicineName, int quantity) {
    return _inventory.containsKey(medicineName) &&
        _inventory[medicineName]! >= quantity;
  }

  /// ✅ Belirli bir ilacın stok miktarını getir
  static int getStock(String medicineName) {
    return _inventory[medicineName] ?? 0;
  }

  /// ✅ Tüm stokları döndür (salt okunur)
  static Map<String, int> getAllInventory() {
    return Map.unmodifiable(_inventory);
  }

  /// ✅ Stoğu tamamen temizle (test amaçlı)
  static void clearInventory() {
    _inventory.clear();
  }
}
