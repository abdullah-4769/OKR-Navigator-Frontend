
import 'package:game_app/data/repositories/storage_repository.dart';

import '../../generated/models/user_model.dart';
import '../../services/profile_service.dart';
import '../../services/shared_preference.dart';

import 'package:get/get.dart';

class ProfileRepository {
  final ProfileApiClient profileApiClient;

  ProfileRepository({required this.profileApiClient});

  /// Get user profile - Gets data using userId from your app
  Future<UserModel?> getUserProfile() async {
    try {
      print('🔄 Repository: Getting user profile...');

      // Step 1: Get userId from SharedPrefs
      final userId = SharedPrefs.getUserId();
      print('📍 Repository: User ID from SharedPrefs = $userId');

      if (userId == null || userId.isEmpty) {
        print('❌ Repository: User ID is empty');

        // Try to get from StorageRepository as fallback
        try {
          print('📍 Repository: Trying StorageRepository fallback...');
          final storageRepo = Get.find<StorageRepository>();
          final user = await storageRepo.getUser();

          if (user != null && user.id != null && user.id!.isNotEmpty) {
            print('✅ Repository: Got user from StorageRepository');
            return _mapStorageUserToUserModel(user);
          }
        } catch (e) {
          print('⚠️ Repository: StorageRepository not available: $e');
        }

        return null;
      }

      // Step 2: Try to get from StorageRepository first (it has the full data)
      try {
        print('📍 Repository: Attempting to get user from StorageRepository...');
        final storageRepo = Get.find<StorageRepository>();
        final user = await storageRepo.getUser();

        if (user != null) {
          print('✅ Repository: Got user from StorageRepository');
          final userModel = _mapStorageUserToUserModel(user);

          // Also save to SharedPrefs for backup
          await _saveToSharedPrefs(userModel);

          return userModel;
        }
      } catch (e) {
        print('⚠️ Repository: StorageRepository error: $e');
      }

      // Step 3: Fallback - Try to get from SharedPreferences
      print('📍 Repository: Falling back to SharedPreferences...');
      final userModel = await _getUserFromSharedPrefs(userId);

      if (userModel != null) {
        print('✅ Repository: Got user from SharedPreferences');
        return userModel;
      }

      print('❌ Repository: Could not load user profile from any source');
      return null;

    } catch (e) {
      print('❌ Repository Error: Exception in getUserProfile: $e');
      return null;
    }
  }

  /// Map StorageRepository user to UserModel
  UserModel _mapStorageUserToUserModel(dynamic storageUser) {
    print('📍 Repository: Mapping StorageRepository user to UserModel...');

    return UserModel(
      id: storageUser.id ?? '',
      name: storageUser.name ?? '',
      email: storageUser.email ?? '',
      phone: storageUser.phone ?? '',
      language: storageUser.language ?? 'en',
      avatarPicId: storageUser.avatarPicId ?? '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get user from SharedPreferences using userId
  Future<UserModel?> _getUserFromSharedPrefs(String userId) async {
    try {
      print('📍 Repository: Getting user from SharedPreferences for ID: $userId');

      final name = SharedPrefs.getUserName();
      final email = SharedPrefs.getString('userEmail');
      final phone = SharedPrefs.getString('userPhone');
      final avatarPicId = SharedPrefs.getString('avatarPicId');
      final language = SharedPrefs.getString('userLanguage') ?? 'en';

      print('📋 Repository: SharedPrefs data:');
      print('   - ID: $userId');
      print('   - Name: $name');
      print('   - Email: $email');
      print('   - Phone: $phone');
      print('   - Avatar: $avatarPicId');

      // If we have at least userId and name, create the model
      if (userId.isNotEmpty && (name?.isNotEmpty ?? false)) {
        final userModel = UserModel(
          id: userId,
          name: name ?? '',
          email: email ?? '',
          phone: phone ?? '',
          language: language,
          avatarPicId: avatarPicId ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        print('✅ Repository: UserModel created from SharedPrefs');
        return userModel;
      }

      print('❌ Repository: Insufficient data in SharedPrefs');
      return null;

    } catch (e) {
      print('❌ Repository Error: _getUserFromSharedPrefs: $e');
      return null;
    }
  }

  /// Save user to SharedPreferences
  Future<void> _saveToSharedPrefs(UserModel user) async {
    try {
      await SharedPrefs.saveUserId(user.id);
      await SharedPrefs.saveUserName(user.name);
      await SharedPrefs.saveString('userEmail', user.email);
      await SharedPrefs.saveString('userPhone', user.phone);
      await SharedPrefs.saveString('avatarPicId', user.avatarPicId);
      await SharedPrefs.saveString('userLanguage', user.language);
      print('💾 Repository: User data saved to SharedPreferences');
    } catch (e) {
      print('⚠️ Repository: Could not save to SharedPrefs: $e');
    }
  }

  /// Update profile with PATCH API
  Future<UserModel?> updateProfile({
    required String profileId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      print('🔄 Repository: Updating profile for ID: $profileId');
      print('📤 Repository: Update data: $updateData');

      final response = await profileApiClient.updateProfile(
        profileId: profileId,
        updateData: updateData,
      );

      if (response != null) {
        print('✅ Repository: Got response from API');
        final updatedUser = UserModel.fromJson(response);

        // Save updated data to SharedPreferences
        print('💾 Repository: Saving updated data');
        await _saveToSharedPrefs(updatedUser);

        print('✅ Repository: Profile updated successfully');
        return updatedUser;
      }

      print('❌ Repository: API response is null');
      return null;
    } catch (e) {
      print('❌ Repository Error: Exception in updateProfile: $e');
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      print('🔄 Repository: Logging out user...');

      // Clear user data from SharedPreferences
      await SharedPrefs.saveUserId('');
      await SharedPrefs.saveUserName('');
      await SharedPrefs.saveString('userEmail', '');
      await SharedPrefs.saveString('userPhone', '');
      await SharedPrefs.saveString('avatarPicId', '');
      await SharedPrefs.saveString('userLanguage', 'en');

      // Clear game session data
      await SharedPrefs.clearGameSessionData();

      print('✅ Repository: User logged out successfully');
    } catch (e) {
      print('❌ Repository Error: Exception in logout: $e');
      rethrow;
    }
  }

  /// Verify user is logged in
  Future<bool> isUserLoggedIn() async {
    try {
      // Check StorageRepository first
      try {
        final storageRepo = Get.find<StorageRepository>();
        final user = await storageRepo.getUser();
        if (user != null && user.id != null && user.id!.isNotEmpty) {
          print('✅ Repository: User logged in (StorageRepository)');
          return true;
        }
      } catch (e) {
        print('⚠️ Repository: StorageRepository not available');
      }

      // Check SharedPrefs fallback
      final userId = SharedPrefs.getUserId();
      final isLoggedIn = userId != null && userId.isNotEmpty;
      print('🔍 Repository: User logged in = $isLoggedIn');
      return isLoggedIn;
    } catch (e) {
      print('❌ Repository Error: Exception in isUserLoggedIn: $e');
      return false;
    }
  }
}

/// Interface for StorageRepository - matches your app's StorageRepository
// abstract class StorageRepository {
//   Future<dynamic> getUser();
// }