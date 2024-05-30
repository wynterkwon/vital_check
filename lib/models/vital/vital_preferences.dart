import 'package:shared_preferences/shared_preferences.dart';

class VitalPreferences {
  static const _keyTempLeft = 'tempLeft';
  static const _keyTempRight = 'tempRight';
  static const _keyWeight = 'weight';
  static const _keySystolic = 'systolic';
  static const _keyDiastolic = 'diastolic';
  static const _keyPulse = 'pulse';
  static SharedPreferences? _prefs;

  // Initialize the SharedPreferences instance if it's not already initialized
  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Initialize the SharedPreferences instance once
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (err) {
      rethrow;
    }
  }

  static Future setDefaultVitalValues() async {
    try {
      Future.wait([f1(), f2(), f3(), f4(), f5(), f6()]);
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> f1() async {
    return await setTempLeft(36.5);
  }

  static Future<void> f2() async {
    return await setTempRight(36.5);
  }

  static Future<void> f3() async {
    return await setWeight(55.0);
  }

  static Future<void> f4() async {
    return await setSystolic(120.0);
  }

  static Future<void> f5() async {
    return await setDiastolic(80.0);
  }

  static Future<void> f6() async {
    return await setPulse(70.0);
  }

  static Future<void> setTempLeft(double value) async {
    try {
      final prefs = await _instance;
      await prefs.setDouble(_keyTempLeft, value);
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> setTempRight(double value) async {
    try {
      final prefs = await _instance;
      await prefs.setDouble(_keyTempRight, value);
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> setWeight(double value) async {
    try {
      final prefs = await _instance;
      await prefs.setDouble(_keyWeight, value);
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> setSystolic(double value) async {
    try {
      final prefs = await _instance;
      await prefs.setDouble(_keySystolic, value);
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> setDiastolic(double value) async {
    try {
      final prefs = await _instance;
      await prefs.setDouble(_keyDiastolic, value);
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> setPulse(double value) async {
    try {
      final prefs = await _instance;
      await prefs.setDouble(_keyPulse, value);
    } catch (err) {
      rethrow;
    }
  }

  double? getTempLeft() {
    try {
      return _prefs!.getDouble(_keyTempLeft);
    } catch (err) {
      rethrow;
    }
  }

  double? getTempRight() {
    try {
      return _prefs!.getDouble(_keyTempRight);
    } catch (err) {
      rethrow;
    }
  }

  double? getWeight() {
    try {
      return _prefs!.getDouble(_keyWeight);
    } catch (err) {
      rethrow;
    }
  }

  double? getSystolic() {
    try {
      return _prefs!.getDouble(_keySystolic);
    } catch (err) {
      rethrow;
    }
  }

  double? getDiastolic() {
    try {
      return _prefs!.getDouble(_keyDiastolic);
    } catch (err) {
      rethrow;
    }
  }

  double? getPulse() {
    try {
      return _prefs!.getDouble(_keyPulse);
    } catch (err) {
      rethrow;
    }
  }

  //******** medicine ********
  Future<void> setMedicine(String title) async {
    try {
      final prefs = await _instance;
    List<String>? existingMedicine = prefs.getStringList('medicine');
    if (existingMedicine == null) {
      await prefs.setStringList('medicine', [title]);
    } else {
      prefs.setStringList('medicine', [...existingMedicine, title]);
    }
    } catch (err) {
      rethrow;
    }
  }

  List<String>? getMedicine() {
    try {
      return _prefs!.getStringList('medicine');
    } catch (err) {
      rethrow;
    }
  }

  // void setEffect(String effect) async {
  //   final prefs = await _instance;

  // }
}
