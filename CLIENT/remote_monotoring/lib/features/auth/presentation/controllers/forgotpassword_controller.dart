import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success
    Get.snackbar('OTP Sent', 'OTP sent to ${emailController.text}');
    isLoading.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
