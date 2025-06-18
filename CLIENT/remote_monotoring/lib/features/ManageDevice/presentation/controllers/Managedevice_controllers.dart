import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/session_controller.dart';
import 'package:remote_monotoring/features/ManageDevice/domain/models/Managedevice_model.dart';
import 'package:remote_monotoring/features/ManageDevice/domain/repositories/Managedevice_repository.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/desktop_alerts.dart';

class ManagedeviceControllers extends GetxController {
  final _sessionController = Get.find<SessionController>();
  final ManagedeviceRepository _managedeviceRepository =
      ManagedeviceRepository();

  final Rx<ManageDeviceResponse?> ManagedeviceData = Rx<ManageDeviceResponse?>(
    null,
  );
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;

  // For editing device
  final RxBool isEditing = false.obs;
  final Rx<DeviceData?> selectedDevice = Rx<DeviceData?>(null);
  final TextEditingController deviceIdController = TextEditingController();

  // For filtering and searching
  final RxString searchQuery = ''.obs;
  final RxBool showOnlyActive = false.obs;
  final RxBool showOnlyInactive = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchdevicedata();
  }

  @override
  void onClose() {
    deviceIdController.dispose();
    super.onClose();
  }

  // Get filtered devices based on search and filter settings
  List<DeviceData> get filteredDevices {
    if (ManagedeviceData.value == null) return [];

    var devices = ManagedeviceData.value!.data;

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      devices =
          devices
              .where(
                (device) =>
                    device.deviceId.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ||
                    device.createBy.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ),
              )
              .toList();
    }

    // Apply status filters
    if (showOnlyActive.value) {
      devices = devices.where((device) => device.status).toList();
    } else if (showOnlyInactive.value) {
      devices = devices.where((device) => !device.status).toList();
    }

    return devices;
  }

  Future<void> fetchdevicedata() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _managedeviceRepository.fetchdevicedata(
        _sessionController.token.value,
      );

      if (response.error) {
        errorMessage.value = response.message ?? 'Unknown error occurred';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        ManagedeviceData.value = response;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load device data: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> addNewDevice(String deviceId) async {
    try {
      // Get required user data
      final token = _sessionController.token.value;
      final userId = _sessionController.userId.value;
      final createdBy = _sessionController.emailId.value;

      // Call repository method
      final response = await _managedeviceRepository.Adddevice(
        token,
        userId,
        deviceId,
        createdBy,
      );

      // Check if response indicates success
      if (response.error == false) {
        // Show success alert
        await DesktopAlerts.showSuccessAlert(
          title: 'Success',
          message: 'Device $deviceId was added successfully',
          buttonText: 'OK',
        );

        // Refresh device list
        fetchdevicedata();
      } else {
        // Show error alert if API returned error
        await DesktopAlerts.showErrorAlert(
          title: 'Error',
          message: response.message ?? 'Failed to add device',
          buttonText: 'OK',
        );
      }
    } catch (e) {
      // Show error alert for exceptions
      await DesktopAlerts.showErrorAlert(
        title: 'Error',
        message: 'Failed to add device: ${e.toString()}',
        buttonText: 'OK',
      );
      rethrow;
    }
  }

  void toggleDeviceStatus(DeviceData device) async {
    final newStatus = !device.status;
    final action = newStatus ? 'activate' : 'deactivate';

    // Show confirmation dialog
    final confirmed = await DesktopAlerts.showConfirmationAlert(
      title: '${newStatus ? "Activate" : "Deactivate"} Device',
      message: 'Are you sure you want to $action ${device.deviceId}?',
      confirmText: newStatus ? 'Activate' : 'Deactivate',
      cancelText: 'Cancel',
    );

    if (!confirmed) return;

    try {

      // Get required data
      final token = _sessionController.token.value;
      final userId = _sessionController.userId.value;
      final modifiedBy = _sessionController.emailId.value;

      // Call repository to update status
      final response = await _managedeviceRepository.UpdateDevicestatus(
        token,
        userId,
        device.deviceId,
        modifiedBy,
        newStatus,
      );



      if (response.error == false) {
        // Show success alert
        await DesktopAlerts.showSuccessAlert(
          title: 'Success',
          message: 'Device ${newStatus ? "activated" : "deactivated"} successfully',
          buttonText: 'OK',
        );
        fetchdevicedata(); // Refresh data
      } else {
        // Show API error alert
        await DesktopAlerts.showErrorAlert(
          title: 'Error',
          message: response.message ?? 'Failed to update device status',
          buttonText: 'OK',
        );
      }
    } catch (e) {
      // Close any open dialogs first
      if (Get.isDialogOpen ?? false) Get.back();

      // Show exception error alert
      await DesktopAlerts.showErrorAlert(
        title: 'Error',
        message: 'Failed to update device status: ${e.toString()}',
        buttonText: 'OK',
      );
    }
  }


}
