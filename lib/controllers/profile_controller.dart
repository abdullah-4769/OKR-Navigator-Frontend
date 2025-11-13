import 'package:flutter/material.dart';
import 'package:game_app/presentation/views/authentication/register_screen.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Form key for potential validation (though read-only for now)
  final formKey = GlobalKey<FormState>();

  // Text controllers for profile fields (pre-populated with dummy data)
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Loading state for logout or other async operations
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load dummy profile data
    nameController.text = 'Adnan Arain';
    emailController.text = 'adnan804@gmail.com';
    phoneController.text = '0000000000000';
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Dummy logout method - simulates API call
  /// Later, replace with actual API integration
  Future<void> logout() async {
    isLoading.value = true;
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Clear any stored data (e.g., shared prefs, but dummy for now)
    // await SharedPreferences.getInstance().clear(); // Uncomment if using shared prefs
    isLoading.value = false;
    // Navigate to login screen
    Get.offAll(RegisterScreen());
  }

  /// Optional: Method to load profile data from API
  /// For now, it's dummy in onInit
  Future<void> loadProfile() async {
    isLoading.value = true;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // Set dummy data (already set in onInit)
    isLoading.value = false;
  }
}