import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/base_controller.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/features/Settings/domain/models/settings_models.dart';
import 'package:remote_monotoring/features/Settings/domain/repositories/settings_repositories.dart';

class SettingsController extends BaseController {
  final SessionController _sessionController = Get.find<SessionController>();
  final SettingsRepositories _settingsRepository = SettingsRepositories();

  final formKey = GlobalKey<FormState>();


  final Rx<FetchUserProfileResponse?> userProfile = Rx<FetchUserProfileResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxBool isSuccess = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool isEditing = false.obs;

  String? originalName;
  String? originalPhone;
  String? originalPassword;

  final isDirty = false.obs;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfileData().then((_) => populateOriginalData());
    setupListeners();
  }

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  void populateOriginalData() {
    final profile = userProfile.value?.data;
    if (profile == null) return;

    originalName = profile.name ?? '';
    originalPhone = profile.phone ?? '';
    originalPassword = profile.password ?? '';

    usernameController.text = originalName!;
    phoneController.text = originalPhone!;
    passwordController.text = originalPassword!;
  }

  void setupListeners() {
    usernameController.addListener(checkIfDirty);
    phoneController.addListener(checkIfDirty);
    passwordController.addListener(checkIfDirty);
  }

  void checkIfDirty() {
    final name = usernameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    isDirty.value = (name != (originalName ?? '') ||
        phone != (originalPhone ?? '') ||
        password != (originalPassword ?? ''));
  }

  Future<void> fetchUserProfileData() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = _sessionController.token.value;
      final userId = _sessionController.userId.value;

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not available');
      }

      if (userId == null || userId == 0) {
        throw Exception('User ID not available');
      }

      final response = await _settingsRepository.fetchuserdata(token, userId);

      if (response.error == false && response.data != null) {
        userProfile(response);
        usernameController.text = response.data!.name ?? '';
        phoneController.text = response.data!.phone ?? '';
        passwordController.text = response.data!.password ?? '';
      } else {
        throw Exception(response.message ?? 'Failed to fetch user profile');
      }
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', 'Failed to load user profile: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfile({
    required String name,
    required int phone,
    String? password,
  }) async {
    try {
      isLoading(true);
      errorMessage('');
      isSuccess(false);

      final token = _sessionController.token.value;
      final userId = _sessionController.userId.value;
      final modifiedBy = _sessionController.emailId.value;

      final response = await _settingsRepository.updateuserdata(
        token,
        userId,
        name,
        phone,
        password ?? '',
        modifiedBy,
      );

      if (!response.error) {
        isSuccess(true);
        errorMessage('');
        await fetchUserProfileData();
      } else {
        throw Exception(response.message ?? 'Failed to update profile');
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
