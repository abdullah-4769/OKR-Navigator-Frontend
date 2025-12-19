import 'package:dio/dio.dart';

import '../core/api_constants.dart' as ApiConstant;

class ProfileApiClient {
  final Dio dio;

  ProfileApiClient({required this.dio});

  /// Update profile with PATCH request
  Future<Map<String, dynamic>?> updateProfile({
    required String profileId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      print('🔄 Updating profile for ID: $profileId');
      print('📤 Sending data: $updateData');

      final url = ApiConstant.updateProfile(profileId);

      final response = await dio.patch(
        url,
        data: updateData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Profile updated successfully');
        print('📥 Response: ${response.data}');
        return response.data as Map<String, dynamic>;
      } else {
        print('❌ Unexpected status code: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('❌ DIO Error: ${e.message}');
      print('📍 Error type: ${e.type}');

      if (e.response != null) {
        print('❌ Server Error: ${e.response?.statusCode}');
        print('❌ Error response: ${e.response?.data}');
      }

      rethrow;
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }

  /// Get profile data (Optional: if you need to fetch fresh data)
  Future<Map<String, dynamic>?> getProfile({
    required String profileId,
  }) async {
    try {
      print('🔄 Fetching profile for ID: $profileId');

      final url = ApiConstant.updateProfile(profileId);

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Profile fetched successfully');
        return response.data as Map<String, dynamic>;
      } else {
        print('❌ Unexpected status code: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('❌ DIO Error: ${e.message}');
      if (e.response != null) {
        print('❌ Server Error: ${e.response?.statusCode}');
      }
      rethrow;
    } catch (e) {
      print('❌ Error fetching profile: $e');
      rethrow;
    }
  }
}