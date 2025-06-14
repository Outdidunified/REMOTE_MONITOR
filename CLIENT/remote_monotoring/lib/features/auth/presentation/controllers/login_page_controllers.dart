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

      // Debug the raw response structure
      print('Response Structure:');
      print('- error: ${response.error}');
      print('- message: ${response.message}');
      print('- token: ${response.token}');
      print('- data: ${response.data}');

      if (response.error) {
        errorMessage.value = response.message ?? 'Login failed';
        isSuccess.value = false;
      } else {
        // Safely extract user data
        final userData = response.data ?? {};

        // Debug user data structure
        print('User Data Structure: $userData');
        print('User Data Keys: ${userData.keys}');

        // Extract values with proper parsing
        final userId = int.tryParse(userData['user_id']?.toString() ?? '0') ?? 0;
        final emailId = userData['email']?.toString() ?? emailController.text.trim();
        final token = response.token ?? '';
        final username = userData['name']?.toString() ?? '';
        final roleId = int.tryParse(userData['role_id']?.toString() ?? '0') ?? 0;
        final roleName = userData['role_name']?.toString() ?? '';
        final phone = userData['phone']?.toString() ?? '';

        // Print extracted values
        print('====== Extracted Values ======');
        print('User ID: $userId (from ${userData['user_id']})');
        print('Email: $emailId (from ${userData['email']})');
        print('Token: ${token.isNotEmpty ? '${token.substring(0, 15)}...' : 'Empty'}');
        print('Username: $username (from ${userData['name']})');
        print('Role ID: $roleId (from ${userData['role_id']})');
        print('Role Name: $roleName (from ${userData['role_name']})');
        print('Phone: $phone (from ${userData['phone']})');

        // Save to session
        await _sessionController.saveSession(
          userId: userId,
          emailId: emailId,
          token: token,
          username: username,
          roleId: roleId,
          roleName: roleName,
          phone: phone,
        );

        errorMessage.value = '${response.message ?? 'Login successful'}! Welcome back';
        isSuccess.value = true;

        await Future.delayed(const Duration(seconds: 3));
        Get.offAllNamed('/dashboard');
      }
    } catch (e) {
      errorMessage.value = e is HttpException ? e.message : 'Unable to reach server. Please try again later.';
      isSuccess.value = false;
      print('Login Error: $e');
      if (e is TypeError) {
        print('Type error details: ${e.stackTrace}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Widget _buildValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }




  /// Clear form fields
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    errorMessage.value = null;
  }
}
