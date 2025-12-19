import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/repositories/profile_repo.dart';
import '../generated/models/user_model.dart';
import '../services/shared_preference.dart';

import '../../../core/app_constants.dart';

class ProfileController extends GetxController {
  final ProfileRepository profileRepository;

  ProfileController({required this.profileRepository});

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  // Observable Variables
  RxBool isLoading = false.obs;
  RxBool isEditMode = false.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);
  RxString errorMessage = ''.obs;

  // Getters
  String get userId => user.value?.id ?? '';
  String get userName => user.value?.name ?? '';
  String get userEmail => user.value?.email ?? '';
  String get userPhone => user.value?.phone ?? '';

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadUserProfile();
  }

  /// Initialize text controllers
  void _initializeControllers() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  /// Load user profile from repository
  Future<void> _loadUserProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔍 DEBUG: Loading user profile...');

      // Get user data from repository
      final userData = await profileRepository.getUserProfile();
      print('🔍 DEBUG: User data received = $userData');

      if (userData != null) {
        user.value = userData;
        _populateControllers(userData);
        print('✅ DEBUG: Profile loaded successfully');
        print('   - Name: ${userData.name}');
        print('   - Email: ${userData.email}');
        print('   - ID: ${userData.id}');
      } else {
        print('❌ DEBUG: User data is null');
        errorMessage.value = 'Failed to load profile data';
      }
    } catch (e) {
      print('❌ ERROR: Exception in _loadUserProfile: $e');
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Populate controllers with user data
  void _populateControllers(UserModel userData) {
    nameController.text = userData.name ?? '';
    emailController.text = userData.email ?? '';
    phoneController.text = userData.phone ?? '';
    print('✅ Controllers populated with user data');
  }

  /// Toggle edit mode
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    if (!isEditMode.value) {
      // Reset controllers if cancel edit
      if (user.value != null) {
        _populateControllers(user.value!);
        errorMessage.value = '';
      }
    }
    print('📝 Edit mode: ${isEditMode.value}');
  }

  /// Update profile with PATCH API
  Future<void> updateProfile() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;
        errorMessage.value = '';

        print('🔄 Updating profile...');

        // Prepare update data
        final updateData = {
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'language': user.value?.language ?? 'en',
          'avatarPicId': user.value?.avatarPicId ?? '',
        };

        print('📤 Update data: $updateData');

        // Call PATCH API
        final response = await profileRepository.updateProfile(
          profileId: userId,
          updateData: updateData,
        );

        if (response != null) {
          user.value = response;
          isEditMode.value = false;

          print('✅ Profile updated successfully');

          Get.snackbar(
            'Success',
            'Profile updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          print('❌ Update response is null');
          errorMessage.value = 'Failed to update profile';
          Get.snackbar(
            'Error',
            'Failed to update profile',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        print('❌ ERROR: Exception in updateProfile: $e');
        errorMessage.value = 'Error updating profile: ${e.toString()}';
        Get.snackbar(
          'Error',
          'Error: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await profileRepository.logout();
      print('✅ User logged out');
      Get.offAllNamed('/login'); // Navigate to login
    } catch (e) {
      print('❌ ERROR: Logout error: $e');
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await _loadUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}