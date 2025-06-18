import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:remote_monotoring/core/controllers/base_controller.dart';
import 'package:remote_monotoring/features/auth/domain/repositories/auth_repository.dart';

class RegisterPageController extends BaseController {
  // Use a unique key name to avoid conflicts
  final formKey = GlobalKey<FormState>(debugLabel: 'registerFormKey');

  // Text controllers with proper registration for disposal
  late final TextEditingController usernamecontroller;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController phoneController;

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final errorMessage = RxnString();
  final RxBool isSuccessMessage = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Register controllers for automatic disposal
    usernamecontroller = registerTextController();
    emailController = registerTextController();
    passwordController = registerTextController();
    phoneController = registerTextController();
  }

  final AuthRepository _repository = AuthRepository();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    isSuccessMessage.value = false;

    try {
      final response = await _repository.RegisterAccount(
        usernamecontroller.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        phoneController.text.trim(),
      );

      if (!response.error) {
        // ✅ Success - show in green
        errorMessage.value = response.message;
        isSuccessMessage.value = true;

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed('/LoginPage');
      } else {
        // ❌ Backend error - show in red
        errorMessage.value = response.message;
      }
    } catch (e) {
      // 🌐 Network/server error - show in red
      errorMessage.value = 'Unable to connect to the server. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // No need to override onClose() since BaseController handles disposal
  // The registerTextController() method in BaseController already adds
  // the controllers to a list that will be disposed automatically
}
