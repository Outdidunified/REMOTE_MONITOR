import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:remote_monotoring/features/auth/domain/repositories/auth_repository.dart';

class RegisterPageController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final usernamecontroller = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final errorMessage = RxnString();
  final RxBool isSuccessMessage = false.obs;



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



  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
