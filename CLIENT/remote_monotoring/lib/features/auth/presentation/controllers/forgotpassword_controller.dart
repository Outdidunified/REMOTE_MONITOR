import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/base_controller.dart';
import 'package:remote_monotoring/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordController extends BaseController {
  final AuthRepository _authRepository = Get.find();

  final formKey = GlobalKey<FormState>(debugLabel: 'forgotPasswordFormKey');
  late final TextEditingController emailController;
  late final TextEditingController otpController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;

  @override
  void onInit() {
    super.onInit();

    // Register controllers for automatic disposal
    emailController = registerTextController();
    otpController = registerTextController();
    newPasswordController = registerTextController();
    confirmPasswordController = registerTextController();
  }

  final isLoading = false.obs;
  final errorMessage = RxString('');
  final successMessage = RxString('');
  final resendSuccessMessage = RxString('');

  final isOtpSent = false.obs;
  final isOtpVerified = false.obs;

  final isResendAvailable = false.obs;
  final resendSecondsRemaining = 30.obs;

  Timer? _resendTimer;
  final isResendingOtp = false.obs;

  // Register timer for disposal
  void _registerTimer(Timer timer) {
    _resendTimer = timer;
    registerSubscription(timer); // This adds it to BaseController's disposables
  }

  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Send OTP (initial or resend)
  Future<void> sendOtp({bool fromResend = false}) async {
    if (!fromResend && !formKey.currentState!.validate()) return;

    try {
      if (fromResend) {
        isResendingOtp.value = true;
        resendSuccessMessage.value = '';
      } else {
        isLoading.value = true;
        errorMessage.value = '';
        successMessage.value = '';
        resendSuccessMessage.value = '';
        isOtpSent.value = false;
        isOtpVerified.value = false;
      }

      final response = await _authRepository.Getotp(emailController.text);

      if (!response.error) {
        isOtpSent.value = true;
        resendSuccessMessage.value =
            fromResend ? response.message ?? 'OTP resent successfully!' : '';
        successMessage.value =
            fromResend ? '' : response.message ?? 'OTP sent successfully!';
        startResendCountdown();
      } else {
        errorMessage.value = response.message ?? 'Failed to send OTP.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to send OTP: ${e.toString()}';
    } finally {
      isLoading.value = false;
      isResendingOtp.value = false;
    }
  }

  // Verify the OTP
  Future<void> verifyOtp() async {
    final otpText = otpController.text;
    if (otpText.length != 6) {
      Get.snackbar(
        "Invalid OTP",
        "Please enter a valid 6-digit OTP",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';
      resendSuccessMessage.value = '';

      final email = emailController.text.trim();
      final otp = int.tryParse(otpText);

      if (otp == null) {
        errorMessage.value = 'OTP must be a valid number.';
        return;
      }

      final response = await _authRepository.Verifyotp(email, otp);

      if (!response.error) {
        isOtpVerified.value = true;
        successMessage.value = response.message ?? 'OTP verified successfully!';
      } else {
        errorMessage.value = response.message ?? 'Invalid OTP.';
      }
    } catch (e) {
      errorMessage.value = 'OTP Verification Failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword() async {
    final newPass = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

    if (newPass.length < 6) {
      errorMessage.value = "Password must be at least 6 characters.";
      return;
    }

    if (newPass != confirmPass) {
      errorMessage.value = "Passwords do not match.";
      return;
    }

    try {
      isLoading.value = true;
      // Replace with actual API logic (you can define `resetPassword` in the repository)
      final response = await _authRepository.UpdatePassword(
        emailController.text.trim(),
        newPass,
      );

      if (!response.error) {
        successMessage.value =
            response.message ?? 'Password updated successfully.';

        // Delay for 3 seconds before navigating to login page
        Future.delayed(const Duration(seconds: 3), () {
          Get.offAllNamed('/LoginPage');
        });
      } else {
        errorMessage.value = response.message ?? 'Failed to update password.';
      }
    } catch (e) {
      errorMessage.value = 'Update failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Timer countdown for resend OTP
  void startResendCountdown() {
    isResendAvailable.value = false;
    resendSecondsRemaining.value = 30;

    // Cancel existing timer if any
    _resendTimer?.cancel();

    // Create and register new timer
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSecondsRemaining.value > 1) {
        resendSecondsRemaining.value--;
      } else {
        resendSecondsRemaining.value = 0;
        isResendAvailable.value = true;
        timer.cancel();
      }
    });

    // Register for proper disposal
    _registerTimer(timer);
  }

  // Reset form to email input state
  void resetToEmailInput() {
    isOtpSent.value = false;
    isOtpVerified.value = false;
    errorMessage.value = '';
    successMessage.value = '';
    resendSuccessMessage.value = '';
    otpController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    _resendTimer?.cancel();
    isResendAvailable.value = false;
  }

  // No need to override onClose() since BaseController handles all disposal
  // The registerTextController() and registerSubscription() methods in BaseController
  // already add the controllers and timer to a list that will be disposed automatically
}
