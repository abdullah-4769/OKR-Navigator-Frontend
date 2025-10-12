import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../data/repositories/storage_repository.dart';

final dio = Dio()
  ..options = BaseOptions(
    validateStatus: (_) => true,
    baseUrl: 'http://192.168.1.6:3000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  )
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint('URL: ${options.uri}');
        debugPrint('REQUEST: ${options.data}');
        final token = Get.find<StorageRepository>().getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onResponse: (options, handler) async {
        debugPrint('RESPONSE: ${options.data}');
        handler.next(options);
      },
    ),
  );
