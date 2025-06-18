import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/features/ManageDevice/domain/models/Managedevice_model.dart';
import 'package:remote_monotoring/features/ManageDevice/presentation/controllers/Managedevice_controllers.dart';
import 'package:remote_monotoring/utils/Layouts/app_layout.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';
import 'package:intl/intl.dart';

class Managedevicepage extends StatelessWidget {
  Managedevicepage({super.key});

  final ManagedeviceControllers controller = Get.put(ManagedeviceControllers());
  final NavigationController navigationController =
      Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Manage Devices',
      subtitle: 'Add, edit, and monitor your devices',
      selectedIndex: 1, // Index for Manage Devices
      onMenuItemTapped: navigationController.onMenuItemTapped,
      actions: Row(
        children: [
          CommonWidgets.secondaryButton(
            context: context,
            text: 'Refresh',
            icon: Icons.refresh,
            onPressed: controller.fetchdevicedata,
          ),
          SizedBox(width: ResponsiveLayout.spacing(context)),
          CommonWidgets.primaryButton(
            context: context,
            text: 'Add New Device',
            icon: Icons.add,
            onPressed: () => _showAddDeviceDialog(context),
          ),
        ],
      ),
      child: _buildManageDevicesContent(context),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    final deviceIdController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.backgroundMedium,
        title: Text('Add New Device', style: AppTheme.headingSmall(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: deviceIdController,
              decoration: InputDecoration(
                labelText: 'Device ID',
                hintText: 'Enter a unique device ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.devices),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.accentColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Device will be created with active status by default',
                    style: AppTheme.caption(context),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTheme.bodyMedium(
                context,
              ).copyWith(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (deviceIdController.text.trim().isEmpty) {
                Get.snackbar(
                  'Error',
                  'Device ID cannot be empty',
                  backgroundColor: AppTheme.error.withOpacity(0.7),
                  colorText: Colors.white,
                );
                return;
              }

              // Here you would implement the API call to add the device
              Get.back();

               controller.addNewDevice(deviceIdController.text.trim());
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: Text('Add Device', style: AppTheme.bodyMedium(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildManageDevicesContent(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMessage.value,
            style: AppTheme.bodyMedium(context).copyWith(color: AppTheme.error),
          ),
        );
      }

      if (controller.ManagedeviceData.value == null) {
        return const Center(child: Text('No data available'));
      }

      final devices = controller.filteredDevices;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchAndFilters(context),
          SizedBox(height: ResponsiveLayout.spacing(context)),
          if (devices.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 80,
                      color: AppTheme.primary.withOpacity(0.5),
                    ),
                    SizedBox(height: ResponsiveLayout.spacing(context)),
                    Text(
                      'No matching devices found',
                      style: AppTheme.headingMedium(context),
                    ),
                    SizedBox(height: ResponsiveLayout.spacing(context) / 2),
                    Text(
                      'Try adjusting your search or filters',
                      style: AppTheme.bodyMedium(context),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: _buildDevicesTable(context, devices),
            ),
        ],
      );
    });
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return CommonWidgets.card(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search devices...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    controller.searchQuery.value = value;
                  },
                ),
              ),
              SizedBox(width: ResponsiveLayout.spacing(context)),
              Obx(
                () => FilterChip(
                  label: Text('Active Only'),
                  selected: controller.showOnlyActive.value,
                  onSelected: (selected) {
                    controller.showOnlyActive.value = selected;
                    if (selected) {
                      controller.showOnlyInactive.value = false;
                    }
                  },
                  backgroundColor: AppTheme.backgroundLight,
                  selectedColor: AppTheme.success.withOpacity(0.2),
                  checkmarkColor: AppTheme.success,
                ),
              ),
              SizedBox(width: ResponsiveLayout.spacing(context) / 2),
              Obx(
                () => FilterChip(
                  label: Text('Inactive Only'),
                  selected: controller.showOnlyInactive.value,
                  onSelected: (selected) {
                    controller.showOnlyInactive.value = selected;
                    if (selected) {
                      controller.showOnlyActive.value = false;
                    }
                  },
                  backgroundColor: AppTheme.backgroundLight,
                  selectedColor: AppTheme.error.withOpacity(0.2),
                  checkmarkColor: AppTheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }





  Widget _buildDevicesTable(BuildContext context, List<DeviceData> devices) {
    return Column(
      children: [
        CommonWidgets.sectionHeader(
          context: context,
          title: 'Device List',
          subtitle: '${devices.length} devices found',
        ),
        SizedBox(height: ResponsiveLayout.spacing(context)),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 32, // Full width with padding
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      AppTheme.backgroundMedium,
                    ),
                    dataRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return AppTheme.primary.withOpacity(0.2);
                        }
                        return AppTheme.backgroundLight; // Row background color
                      },
                    ),
                    dividerThickness: 0.5,
                    columnSpacing: 24,
                    horizontalMargin: 16,
                    headingRowHeight: 56,
                    dataRowHeight: 64,
                    columns: [
                      DataColumn(
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('S.No', style: _headerTextStyle(context)),
                        ),
                      ),
                      DataColumn(
                        label: Text('Device ID', style: _headerTextStyle(context)),
                      ),
                      DataColumn(
                        label: Text('Created By', style: _headerTextStyle(context)),
                      ),
                      DataColumn(
                        label: Text('Created At', style: _headerTextStyle(context)),
                      ),
                      DataColumn(
                        label: Text('Status', style: _headerTextStyle(context)),
                      ),
                      DataColumn(
                        label: Text('Options', style: _headerTextStyle(context)),
                      ),
                    ],
                    rows: List<DataRow>.generate(devices.length, (index) {
                      final device = devices[index];
                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('${index + 1}'),
                            ),
                          ),
                          DataCell(
                            Text(device.deviceId),
                          ),
                          DataCell(
                            Text(device.createBy),
                          ),
                          DataCell(
                            Text(_formatDate(device.createDate)),
                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: device.status
                                    ? AppTheme.success.withOpacity(0.1)
                                    : AppTheme.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    device.status ? Icons.check_circle : Icons.cancel,
                                    color: device.status ? AppTheme.success : AppTheme.error,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    device.status ? 'Active' : 'Inactive',
                                    style: AppTheme.caption(context).copyWith(
                                      color: device.status ? AppTheme.success : AppTheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_red_eye,
                                    color: AppTheme.primary,
                                    size: 20,
                                  ),
                                  onPressed: () => _viewDeviceDetails(device),
                                ),
                                SizedBox(width: 4),
                                SizedBox(width: 4),
                                IconButton(
                                  icon: Icon(
                                    device.status ? Icons.toggle_on : Icons.toggle_off,
                                    color: device.status ? AppTheme.success : AppTheme.error,
                                    size: 20,
                                  ),
                                  onPressed: () => controller.toggleDeviceStatus(device),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _headerTextStyle(BuildContext context) {
    return AppTheme.bodyMedium(context).copyWith(
      fontWeight: FontWeight.bold,
      color: AppTheme.primary,
    );
  }

  void _viewDeviceDetails(DeviceData device) {
    Get.dialog(
      AlertDialog(
        title: Text('Device Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Device ID:', device.deviceId),
              _buildDetailRow('Created By:', device.createBy),
              _buildDetailRow('Created At:', _formatDate(device.createDate)),
              if (device.modifiedBy != null)
                _buildDetailRow('Modified By:', device.modifiedBy!),
              if (device.modifiedDate != null)
                _buildDetailRow('Modified At:', _formatDate(device.modifiedDate!)),
              _buildDetailRow('Status:', device.status ? 'Active' : 'Inactive'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
