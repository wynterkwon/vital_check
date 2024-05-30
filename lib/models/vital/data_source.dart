import 'package:vital/models/data/dio_client.dart';
import 'package:vital/models/vital/vital_model.dart';

class VitalDataSource {
  final dio = DioClient().dio;
  List<VitalModel> vitalResource = [];
  int _total = 0;
  int get total => _total;

  Future<Map<String, dynamic>?> create(VitalInputModel vitalData) async {
    try {
      /*
      Map<String, dynamic> vitalModel = VitalInputModel(
        inputDate: DateTime.now().toString(),
        tempLeft: 36.5,
        tempRight: 36.5,
        weight: 55.5,
        systolic: 130,
        diastolic: 75,
      ).toMap();
      */

      final response = await dio.post('/vital', data: vitalData.toMap());
      return response.data;
    } catch (err) {
      print(err);
    }
    return null;
  }

  Future<List<dynamic>> fetchVitals({int? page, int? limit}) async {
    try {
      final response = await dio.get('/vital/?offset=$page&limit=$limit');
      //response.data.runtimeType   //List<dynamic>
      _total = response.data['total'];
      return response.data['vitals'];
    } catch (err) {
      rethrow;
    }
  }

  Future<List<VitalModel>> getVitalResource({int? page, int? limit}) async {
    final result = await fetchVitals(page: page, limit: limit);
    for (var i = 0; i < result.length; i++) {
      VitalModel vital = VitalModel.fromMap(result[i] as Map<String, dynamic>);
      vitalResource.add(vital);
    }
    return vitalResource;
  }

  Future<List<VitalModel>> getWholeVitalResources() async {
    List<VitalModel> vitalResources = [];
    final response = await dio.get('/vital/whole');
    for (var i = 0; i < response.data.length; i++) {
      VitalModel vital =
          VitalModel.fromMap(response.data[i] as Map<String, dynamic>);
      vitalResources.add(vital);
    }
    return vitalResources;
  }

  // Future<List<VitalModel>> getPaginatedVitalResource() async {
  //   final result = await fetchVitals();
  //   for (var i = 0; i < result.length; i++) {
  //     VitalModel vital = VitalModel.fromMap(result[i] as Map<String, dynamic>);
  //     vitalResource.add(vital);
  //   }
  //   return vitalResource;
  // }

  Future<VitalModel> getOneVitalById(int id) async {
    try {
      final response = await dio.get('/vital/$id');
      VitalModel vital = VitalModel.fromMap(response.data[0]);
      return vital;
    } catch (err) {
      rethrow;
    }
  }

  updateVital(VitalUpdateModel vitalUpdateData) async {
    try {
      print(vitalUpdateData.toMap().toString());
      final response = await dio.patch('/vital', data: vitalUpdateData.toMap());
      return response.data;
    } catch (err) {
      rethrow;
    }
  }

  Future<String> deleteVital(int id) async {
    try {
      await dio.delete('/vital/$id');
      return 'Successfully deleted';
    } catch (err) {
      rethrow;
    }
  }

  downloadPDF() {}
}
