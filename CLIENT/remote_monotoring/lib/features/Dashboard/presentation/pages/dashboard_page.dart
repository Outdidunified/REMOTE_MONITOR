import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/features/Dashboard/domain/models/dashboard_model.dart';
import 'package:remote_monotoring/features/Dashboard/presentation/controllers/Dashboard_controller.dart';
import 'package:remote_monotoring/features/ManageDevice/presentation/pages/ManageDevicePage.dart';
import 'package:remote_monotoring/utils/Layouts/app_layout.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final NavigationController navigationController =
      Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppLayout(
        title: 'Dashboard',
        subtitle: 'Overview of your system monitoring',
        selectedIndex: navigationController.selectedIndex.value,
        onMenuItemTapped: navigationController.onMenuItemTapped,
        actions: Row(
          children: [
            CommonWidgets.secondaryButton(
              context: context,
              text: 'Refresh',
              icon: Icons.refresh,
              onPressed: controller.fetchDashboardData,
            ),
            SizedBox(width: ResponsiveLayout.spacing(context)),
            CommonWidgets.primaryButton(
              context: context,
              text: 'Add Device',
              icon: Icons.add,
              onPressed: () {
                Get.to(
                      () => Managedevicepage(),
                  routeName: '/manageDevices',
                  transition: Transition.fade,
                  duration: const Duration(milliseconds: 500), // Add transition duration
                 // Prevent duplicate routes
                );
              },
            ),
          ],
        ),
        child: _buildDashboardContent(context),
      );
    });
  }

  Widget _buildDashboardContent(BuildContext context) {
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

      if (controller.dashboardData.value == null) {
        return const Center(child: Text('No data available'));
      }

      final data = controller.dashboardData.value!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCards(context, data),
          SizedBox(height: ResponsiveLayout.spacing(context) * 2),
          Expanded(child: _buildChartsAndTables(context, data)),
        ],
      );
    });
  }

  Widget _buildStatusCards(BuildContext context, DashboarddataResponse data) {
    // Calculate percentage of active devices
    final activePercentage =
        data.deviceListTotalCount > 0
            ? (data.deviceListActiveCount / data.deviceListTotalCount * 100)
                .toStringAsFixed(1)
            : '0';

    return GridView.count(
      crossAxisCount: ResponsiveLayout.value<int>(
        context: context,
        mobile: 1,
        tablet: 2,
        desktop: 4,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: ResponsiveLayout.spacing(context),
      mainAxisSpacing: ResponsiveLayout.spacing(context),
      childAspectRatio: ResponsiveLayout.value<double>(
        context: context,
        mobile: 2.5,
        tablet: 2.2,
        desktop: 1.8,
      ),
      children: [
        _buildStatusCard(
          context: context,
          title: 'Total Devices',
          value: data.deviceListTotalCount.toString(),
          icon: Icons.devices,
          color: AppTheme.primary,
          trend: '+${data.deviceListTotalCount}',
          isUp: true,
        ),
        _buildStatusCard(
          context: context,
          title: 'Online',
          value: data.deviceListActiveCount.toString(),
          icon: Icons.check_circle,
          color: AppTheme.success,
          trend: '$activePercentage%',
          isUp: true,
        ),
        _buildStatusCard(
          context: context,
          title: 'Offline',
          value: data.deviceListDeactiveCount.toString(),
          icon: Icons.cancel,
          color: AppTheme.warning,
          trend: '-${data.deviceListDeactiveCount}',
          isUp: false,
        ),
        _buildStatusCard(
          context: context,
          title: 'Alerts',
          value: data.deviceHistoryDeactiveCount.toString(),
          icon: Icons.warning,
          color: AppTheme.error,
          trend: '+${data.deviceHistoryDeactiveCount}',
          isUp: data.deviceHistoryDeactiveCount > 0,
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool isUp,
  }) {
    return CommonWidgets.card(
      context: context,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          SizedBox(width: ResponsiveLayout.spacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: AppTheme.bodySmall(context)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(value, style: AppTheme.headingMedium(context)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (isUp ? AppTheme.success : AppTheme.error)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isUp ? Icons.arrow_upward : Icons.arrow_downward,
                            color: isUp ? AppTheme.success : AppTheme.error,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            trend,
                            style: AppTheme.caption(context).copyWith(
                              color: isUp ? AppTheme.success : AppTheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsAndTables(
    BuildContext context,
    DashboarddataResponse data,
  ) {
    final deviceList = data.deviceList;
    final alertList = data.deviceHistory;

    return ResponsiveLayout.isDesktop(context) ||
            ResponsiveLayout.isLargeDesktop(context)
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CommonWidgets.card(
                      context: context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidgets.sectionHeader(
                            context: context,
                            title: 'System Performance',
                            subtitle: 'Last 24 hours',
                            trailing: DropdownButton<String>(
                              value: 'Today',
                              items:
                                  [
                                    'Today',
                                    'Yesterday',
                                    'Last Week',
                                    'Last Month',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: AppTheme.bodySmall(context),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (_) {},
                              style: AppTheme.bodySmall(context),
                              dropdownColor: AppTheme.backgroundLight,
                              underline: Container(),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppTheme.backgroundLight.withOpacity(
                                    0.3,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bar_chart,
                                      size: 30,
                                      color: AppTheme.accentColor.withOpacity(
                                        0.7,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Performance Chart',
                                      style: AppTheme.bodyMedium(context),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'CPU, Memory, and Network usage over time',
                                      style: AppTheme.caption(context),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveLayout.spacing(context)),
                  Expanded(
                    child: CommonWidgets.card(
                      context: context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidgets.sectionHeader(
                            context: context,
                            title: 'Recent Alerts',
                            subtitle: 'Last ${alertList.length} alerts',
                            trailing: TextButton(
                              onPressed: () {},
                              child: const Text('View All'),
                            ),
                          ),
                          Expanded(
                            child:
                                alertList.isEmpty
                                    ? Center(
                                      child: Text(
                                        'No alerts found',
                                        style: AppTheme.bodyMedium(context),
                                      ),
                                    )
                                    : ListView.separated(
                                      itemCount:
                                          alertList.length > 5
                                              ? 5
                                              : alertList.length,
                                      separatorBuilder:
                                          (context, index) => const Divider(
                                            color: AppTheme.backgroundLight,
                                          ),
                                      itemBuilder: (context, index) {
                                        final alert = alertList[index];
                                        final isCritical =
                                            alert['status'] == false;
                                        final color =
                                            isCritical
                                                ? AppTheme.error
                                                : AppTheme.warning;
                                        final icon =
                                            isCritical
                                                ? Icons.error
                                                : Icons.warning;
                                        final type =
                                            isCritical ? 'Critical' : 'Warning';

                                        return ListTile(
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: color.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(icon, color: color),
                                          ),
                                          title: Text(
                                            '${alert['device_id']} - $type',
                                            style: AppTheme.bodyMedium(context),
                                          ),
                                          subtitle: Text(
                                            'Last modified: ${_formatDate(alert['modifiedDate'] ?? alert['createDate'] ?? '')}',
                                            style: AppTheme.caption(context),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.more_vert),
                                            onPressed: () {},
                                          ),
                                        );
                                      },
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveLayout.spacing(context)),
            // Expanded(child: _buildDeviceListTable(context, deviceList)),
          ],
        )
        : Column(
          children: [
            Expanded(
              flex: 1,
              child: CommonWidgets.card(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets.sectionHeader(
                      context: context,
                      title: 'System Performance',
                      subtitle: 'Last 24 hours',
                      trailing: DropdownButton<String>(
                        value: 'Today',
                        items:
                            [
                              'Today',
                              'Yesterday',
                              'Last Week',
                              'Last Month',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: AppTheme.bodySmall(context),
                                ),
                              );
                            }).toList(),
                        onChanged: (_) {},
                        style: AppTheme.bodySmall(context),
                        dropdownColor: AppTheme.backgroundLight,
                        underline: Container(),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundLight.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bar_chart,
                                size: 10,
                                color: AppTheme.accentColor.withOpacity(0.7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Performance Chart',
                                style: AppTheme.bodyMedium(context),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'CPU, Memory, and Network usage over time',
                                style: AppTheme.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ResponsiveLayout.spacing(context)),
            Expanded(
              flex: 1,
              child: CommonWidgets.card(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidgets.sectionHeader(
                      context: context,
                      title: 'Recent Alerts',
                      subtitle: 'Last ${alertList.length} alerts',
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ),
                    Expanded(
                      child:
                          alertList.isEmpty
                              ? Center(
                                child: Text(
                                  'No alerts found',
                                  style: AppTheme.bodyMedium(context),
                                ),
                              )
                              : ListView.separated(
                                itemCount:
                                    alertList.length > 5 ? 5 : alertList.length,
                                separatorBuilder:
                                    (context, index) => const Divider(
                                      color: AppTheme.backgroundLight,
                                    ),
                                itemBuilder: (context, index) {
                                  final alert = alertList[index];
                                  final isCritical = alert['status'] == false;
                                  final color =
                                      isCritical
                                          ? AppTheme.error
                                          : AppTheme.warning;
                                  final icon =
                                      isCritical ? Icons.error : Icons.warning;
                                  final type =
                                      isCritical ? 'Critical' : 'Warning';

                                  return ListTile(
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(icon, color: color),
                                    ),
                                    title: Text(
                                      '${alert['device_id']} - $type',
                                      style: AppTheme.bodyMedium(context),
                                    ),
                                    subtitle: Text(
                                      'Last modified: ${_formatDate(alert['modifiedDate'] ?? alert['createDate'] ?? '')}',
                                      style: AppTheme.caption(context),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {},
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ResponsiveLayout.spacing(context)),
            // Expanded(
            //   flex: 2,
            //   child: _buildDeviceListTable(context, deviceList),
            // ),
          ],
        );
  }

  Widget _buildDeviceListTable(BuildContext context, List<dynamic> deviceList) {
    return CommonWidgets.card(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets.sectionHeader(
            context: context,
            title: 'Device Overview',
            subtitle: '${deviceList.length} devices registered',
            trailing: TextButton(
              onPressed: () {
                navigationController.onMenuItemTapped(
                  1,
                ); // Navigate to Manage Devices
              },
              child: const Text('Manage Devices'),
            ),
          ),
          SizedBox(height: ResponsiveLayout.spacing(context)),
          Expanded(
            child:
                deviceList.isEmpty
                    ? Center(
                      child: Text(
                        'No devices found',
                        style: AppTheme.bodyMedium(context),
                      ),
                    )
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            AppTheme.backgroundLight.withOpacity(0.3),
                          ),
                          columns: [
                            DataColumn(
                              label: Text(
                                'Status',
                                style: AppTheme.bodyMedium(
                                  context,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Device ID',
                                style: AppTheme.bodyMedium(
                                  context,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Created By',
                                style: AppTheme.bodyMedium(
                                  context,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Created Date',
                                style: AppTheme.bodyMedium(
                                  context,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows:
                              deviceList.map<DataRow>((device) {
                                final isActive =
                                    device['status'] as bool? ?? false;

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (isActive
                                                  ? AppTheme.success
                                                  : AppTheme.error)
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isActive
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color:
                                                  isActive
                                                      ? AppTheme.success
                                                      : AppTheme.error,
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              isActive ? 'Active' : 'Inactive',
                                              style: AppTheme.caption(
                                                context,
                                              ).copyWith(
                                                color:
                                                    isActive
                                                        ? AppTheme.success
                                                        : AppTheme.error,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        device['device_id'] ?? '',
                                        style: AppTheme.bodyMedium(context),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        device['createBy'] ?? '',
                                        style: AppTheme.bodyMedium(context),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        _formatDate(device['createDate'] ?? ''),
                                        style: AppTheme.bodyMedium(context),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
