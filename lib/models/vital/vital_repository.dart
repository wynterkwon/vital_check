import 'package:vital/models/vital/data_source.dart';
import 'package:vital/models/vital/vital_model.dart';

class VitalRepository {
  final vitalDataSource = VitalDataSource();
  VitalRepository();

  int get total => vitalDataSource.total;

  Future<Map<String, dynamic>?> create(VitalInputModel vitalData) async {
    return await vitalDataSource.create(vitalData);
  }

  // Future<List<VitalModel>> fetchData() async {
  //   return await vitalDataSource.fetchVitals();
  // }

  Future<List<VitalModel>> getVitalResource({int? page, int? limit}) async {
    return await vitalDataSource.getVitalResource(page: page, limit: limit);
  }

  Future<List<VitalModel>> getWholeVitalResources() async {
    return await vitalDataSource.getWholeVitalResources();
  }

  Future<VitalModel> getOneVitalById(int id) async {
    return await vitalDataSource.getOneVitalById(id);
  }

  Future<String> deleteVitalById(int id) async {
    return await vitalDataSource.deleteVital(id);
  }

  Future updateVital(VitalUpdateModel vitalData) async {
    return await vitalDataSource.updateVital(vitalData);
  }
}
