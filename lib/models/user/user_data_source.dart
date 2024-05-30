import 'package:logger/web.dart';
import 'package:vital/main.dart';
import 'package:vital/models/data/dio_client.dart';
import 'package:vital/models/user/user_model.dart';

class UserDataSource {
  final dio = DioClient().dio;

  requestAcception(DesignationModel userRequestDesignation) async{
    try {
      final response = await dio.patch('/user/accept', data: userRequestDesignation );
      return response.data;
    } catch (err) {
      logger.e(err);
    }
  }

  requestDesignation(UserUpdateModel updateData) async{
    try {
      final id = updateData.userId;
      final response = await dio.patch('/user/$id', data: updateData );
      return response.data;
    } catch (err) {
      logger.e(err);
    }
  }
}