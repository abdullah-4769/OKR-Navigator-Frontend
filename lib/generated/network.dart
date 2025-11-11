// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
//
// import '../data/repositories/storage_repository.dart';
//
// final dio = Dio()
//   ..options = BaseOptions(
//     validateStatus: (_) => true,
//     baseUrl: 'http://192.168.1.9:3000',
//     connectTimeout: const Duration(seconds: 10),
//     receiveTimeout: const Duration(seconds: 20),
//   )
//   ..interceptors.add(
//     InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         debugPrint('URL: ${options.uri}');
//         debugPrint('REQUEST: ${options.data}');
//         final token = Get.find<StorageRepository>().getAccessToken();
//         if (token != null) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         handler.next(options);
//       },
//       onResponse: (options, handler) async {
//         debugPrint('RESPONSE: ${options.data}');
//         handler.next(options);
//       },
//
//     ),
//   );
// lib/generated/network.dart

// lib/generated/network.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../data/repositories/storage_repository.dart';

class DioClient extends GetxService {
  late Dio dio;
  final StorageRepository _storageRepository = Get.find<StorageRepository>();

  Future<DioClient> init() async {
    final baseUrl = await _storageRepository.getBaseUrl();

    dio = Dio()
      ..options = BaseOptions(
        validateStatus: (_) => true,
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60), // Increased to 60 seconds for batch operations (key results, initiatives)
      )
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            debugPrint('URL: ${options.uri}');
            debugPrint('REQUEST: ${options.data}');

            final token = await _storageRepository.getAccessToken();
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

    return this;
  }

  Dio get instance => dio;
}

// Legacy support - deprecated, use DioClient instead
@Deprecated('Use DioClient instead')
Dio get dio {
  try {
    return Get.find<DioClient>().dio;
  } catch (e) {
    throw Exception('DioClient not initialized. Call await Get.putAsync(() => DioClient().init()) in main.dart');
  }
}

