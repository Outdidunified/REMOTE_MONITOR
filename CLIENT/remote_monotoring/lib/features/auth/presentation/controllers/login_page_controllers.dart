import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/base_controller.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/features/auth/domain/repositories/auth_repository.dart';
import 'package:remote_monotoring/utils/exception/exception.dart';

class LoginPageController extends BaseController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text controllers
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  // Observable state
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final Rxn<String> errorMessage = Rxn<String>();
  var isSuccess = false.obs;

  final RxBool rememberMe = false.obs;

  // Animation controllers
  final RxDouble formOpacity = 1.0.obs;

  // Dependencies
  final _sessionController = Get.find<SessionController>();
  final AuthRepository _repository = AuthRepository();

  @override
  void onInit() {
    super.onInit();

    // Register controllers for automatic disposal
    emailController = registerTextController();
    passwordController = registerTextController();

    // Debug print
    debugPrint('Navigating to LoginPage');
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    if (!rememberMe.value) {
      errorMessage.value = 'Please agree to remember your login';
      isSuccess.value = false;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = null;
      isSuccess.value = false;

      final response = await _repository.LoginAccount(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Always show the backend message (success or failure)
      errorMessage.value = response.message;
      isSuccess.value = !response.error;

      if (response.error) return;

      final userData = response.data ?? {};

      await _sessionController.saveSession(
        userId: int.tryParse(userData['user_id']?.toString() ?? '0') ?? 0,
        emailId: userData['email']?.toString() ?? emailController.text.trim(),
        token: response.token ?? '',
        username: userData['name']?.toString() ?? '',
        roleId: int.tryParse(userData['role_id']?.toString() ?? '0') ?? 0,
        roleName: userData['role_name']?.toString() ?? '',
        phone: userData['phone']?.toString() ?? '',
      );

      // Optional delay for UX feedback
      await Future.delayed(const Duration(seconds: 1));

      // Navigate to dashboard
      Get.offAllNamed('/dashboard');

    } catch (e) {
      if (e is HttpException) {
        errorMessage.value = e.message; // ✅ Use the backend-provided message here
      } else {
        errorMessage.value = 'Unable to reach server. Please try again later.';
      }
      isSuccess.value = false;
      debugPrint('Login Error: ${errorMessage.value}');
    }

  }



  /// Clear form fields
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    errorMessage.value = null;
  }
}
