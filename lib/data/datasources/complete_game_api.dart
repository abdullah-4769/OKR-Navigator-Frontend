// lib/data/datasources/game_complete_api.dart

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../core/api_constants.dart';
import '../../generated/models/responses/game_complete_model/game_complete_model.dart';
import '../../generated/network.dart';
import '../repositories/storage_repository.dart';


class GameCompleteApi {
  final Dio dio;

  GameCompleteApi(this.dio);

  Future<GameCompleteModel> getLatestGameScore(String userId) async {
    try {
      // Get token from storage
      final storageRepository = Get.find<StorageRepository>();
      final token = await storageRepository.getAccessToken();

      final response = await dio.get(
        ApiConstants.getLatestGameScore(userId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return GameCompleteModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load game score: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load game completion data: $e');
    }
  }
}













// // lib/data/datasources/game_complete_api.dart
//
// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import '../../generated/models/responses/game_complete_model/game_complete_model.dart';
// import '../../generated/network.dart';
// import '../repositories/storage_repository.dart';
//
// class GameCompleteApi {
//   final Dio dio;
//
//   GameCompleteApi(this.dio);
//
//   Future<GameCompleteModel> getLatestGameScore(String userId) async {
//     try {
//       // Get token from storage
//       final storageRepository = Get.find<StorageRepository>();
//       final token = await storageRepository.getAccessToken();
//
//       final response = await dio.get(
//         'http://192.168.43.101:3000/solo-score/user/$userId/latest',
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         return GameCompleteModel.fromJson(response.data);
//       } else {
//         throw Exception('Failed to load game score: ${response.statusCode}');
//       }
//     } on DioException catch (e) {
//       throw Exception('Dio error: ${e.message}');
//     } catch (e) {
//       throw Exception('Failed to load game completion data: $e');
//     }
//   }
// }













// // lib/data/datasources/game_complete_api.dart
//
// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import '../../core/api_constants.dart';
// import '../../generated/models/responses/game_complete_model/game_complete_model.dart';
// import '../../generated/network.dart';
// import '../repositories/storage_repository.dart';
//
//
// class GameCompleteApi {
//   final Dio dio;
//
//   GameCompleteApi(this.dio);
//
//   Future<GameCompleteModel> getLatestGameScore(String userId) async {
//     try {
//       // Get token from storage
//       final storageRepository = Get.find<StorageRepository>();
//       final token = await storageRepository.getAccessToken();
//
//       final response = await dio.get(
//         ApiConstants.getLatestGameScore(userId),
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         return GameCompleteModel.fromJson(response.data);
//       } else {
//         throw Exception('Failed to load game score: ${response.statusCode}');
//       }
//     } on DioException catch (e) {
//       throw Exception('Dio error: ${e.message}');
//     } catch (e) {
//       throw Exception('Failed to load game completion data: $e');
//     }
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
// // // lib/data/datasources/game_complete_api.dart
// //
// // import 'package:dio/dio.dart';
// // import 'package:get/get.dart';
// // import '../../generated/models/responses/game_complete_model/game_complete_model.dart';
// // import '../../generated/network.dart';
// // import '../repositories/storage_repository.dart';
// //
// // class GameCompleteApi {
// //   final Dio dio;
// //
// //   GameCompleteApi(this.dio);
// //
// //   Future<GameCompleteModel> getLatestGameScore(String userId) async {
// //     try {
// //       // Get token from storage
// //       final storageRepository = Get.find<StorageRepository>();
// //       final token = await storageRepository.getAccessToken();
// //
// //       final response = await dio.get(
// //         'http://192.168.43.101:3000/solo-score/user/$userId/latest',
// //         options: Options(
// //           headers: {
// //             'Authorization': 'Bearer $token',
// //             'Content-Type': 'application/json',
// //           },
// //         ),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         return GameCompleteModel.fromJson(response.data);
// //       } else {
// //         throw Exception('Failed to load game score: ${response.statusCode}');
// //       }
// //     } on DioException catch (e) {
// //       throw Exception('Dio error: ${e.message}');
// //     } catch (e) {
// //       throw Exception('Failed to load game completion data: $e');
// //     }
// //   }
// // }