import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!,
      connectTimeout: const Duration(seconds: 5), // 5 seconds
      receiveTimeout: const Duration(seconds: 3), // 3 seconds
      headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
    },
    ));

    // Add interceptors if needed
    // dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) {
    //     options.headers['Authorization'] = 'Bearer your_token';
    //     print('Sending request to ${options.uri}');
    //     return handler.next(options); // continue
    //   },
    //   onResponse: (response, handler) {
    //     print('Received response: ${response.data}');
    //     return handler.next(response); // continue
    //   },
    //   onError: (DioError e, handler) {
    //     print('Error occurred: ${e.message}');
    //     return handler.next(e); // continue
    //   },
    // ));
  }
}
