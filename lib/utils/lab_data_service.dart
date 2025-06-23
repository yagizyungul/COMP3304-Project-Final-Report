class LabDataService {
  static final List<Map<String, dynamic>> _testResults = [];

  static void addTestResult(Map<String, dynamic> test) {
    _testResults.add(test);
  }

  static void clearAllTests() {
    _testResults.clear();
  }

  static List<Map<String, dynamic>> getAllTests() {
    return List<Map<String, dynamic>>.from(_testResults);
  }

  static void updateTestResult(String id, String newResult) {
    final index = _testResults.indexWhere((test) => test['id'] == id);
    if (index != -1) {
      _testResults[index]['result'] = newResult;
    }
  }

  static void clearAll() {
    _testResults.clear(); // opsiyonel
  }
}
