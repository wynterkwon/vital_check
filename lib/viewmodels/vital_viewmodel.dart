import 'package:vital/constants/constants.dart';
import 'package:vital/models/vital/vital_preferences.dart';
import 'package:vital/models/vital/vital_model.dart';
import 'package:vital/models/vital/vital_repository.dart';

class VitalViewModel {
  final VitalRepository repository = VitalRepository();
  VitalViewModel() {
    getDefaultVital();
  }
  VitalPreferences vitalPrefs = VitalPreferences();
  List<VitalModel> _resources = [];
  List<VitalModel> get resources => _resources;
  int get total => repository.total;
  late double DEFAULT_TEMP_LEFT;
  late double DEFAULT_TEMP_RIGHT;
  late double DEFAULT_SYSTOLIC;
  late double DEFAULT_DIASTOLIC;
  late double DEFAULT_WEIGHT;
  late double DEFAULT_PULSE;

  Future<List<VitalModel>> getVitalResource({int? page, int? limit}) async {
    try {
      _resources = await repository.getVitalResource(page: page, limit: limit);
      return resources;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<VitalModel>> getWholeVitalResources() async {
    try {
      return await repository.getWholeVitalResources();
    } catch (err) {
      rethrow;
    }
  }

  Future<VitalModel> getOneVitalById(int id) async {
    return await repository.getOneVitalById(id);
  }

  create(VitalInputModel vitalData) async {
    await repository.create(vitalData);
  }

  Future<String> deleteVitalById(int id) async {
    return await repository.deleteVitalById(id);
  }

  Future updateVital(VitalUpdateModel vitalData) async {
    return await repository.updateVital(vitalData);
  }

  setDefaultVital({
    double? tempLeft,
    double? tempRight,
    double? weight,
    double? systolic,
    double? diastolic,
    double? pulse,
  }) async{
    if (tempLeft != null) await VitalPreferences.setTempLeft(tempLeft);
    if (tempRight != null) await VitalPreferences.setTempRight(tempRight);
    if (weight != null) await VitalPreferences.setWeight(weight);
    if (systolic != null) await VitalPreferences.setSystolic(systolic);
    if (diastolic != null) await VitalPreferences.setDiastolic(diastolic);
    if (pulse != null) await VitalPreferences.setPulse(pulse);
  }

  getDefaultVital() {
    DEFAULT_TEMP_RIGHT = getTempLeft();
    DEFAULT_TEMP_LEFT = getTempRight();
    DEFAULT_SYSTOLIC = getSystolic();
    DEFAULT_DIASTOLIC = getDiastolic();
    DEFAULT_WEIGHT = getWeight();
    DEFAULT_PULSE = getPulse();
  }

  getTempLeft() {
    return vitalPrefs.getTempLeft();
  }

  getTempRight() {
    return vitalPrefs.getTempRight();
  }

  getWeight() {
    return vitalPrefs.getWeight();
  }

  getSystolic() {
    return vitalPrefs.getSystolic();
  }

  getDiastolic() {
    return vitalPrefs.getDiastolic();
  }

  getPulse() {
    return vitalPrefs.getPulse();
  }


}
