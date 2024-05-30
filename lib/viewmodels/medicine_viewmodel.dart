import 'package:vital/models/vital/vital_preferences.dart';

class MedicineViewModel {
  VitalPreferences vitalPreferences = VitalPreferences();

  Future<String> setMedicine(String title) async {
    try {
      await vitalPreferences.setMedicine(title);
      return '200 OK';
    } catch (err) {
      rethrow;
    }
  }

  List<String>? getMedicine() {
    try {
      return vitalPreferences.getMedicine();
    } catch (err) {
      rethrow;
    }
  }
}
