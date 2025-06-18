import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/features/History/domain/models/history_model.dart';
import 'package:remote_monotoring/features/History/presentation/controllers/Historypage_controllers.dart';
import 'package:remote_monotoring/utils/Layouts/app_layout.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';

class Historypage extends StatelessWidget {
  Historypage({super.key});

  final HistoryPageControllers controller = Get.put(HistoryPageControllers());
  final NavigationController navigationController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'History',
      subtitle: 'View historical data and events',
      selectedIndex: 2, // Index for History
      onMenuItemTapped: navigationController.onMenuItemTapped,
      actions: CommonWidgets.secondaryButton(
        context: context,
        text: 'Export Data',
        icon: Icons.download,
        onPressed: () {
          // Export data logic
        },
      ),
      child: _buildHistoryContent(context),
    );
  }

  Widget _buildHistoryContent(BuildContext context) {
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

      final historyData = controller.historyData.value;
      if (historyData == null || historyData.data.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 80,
                color: AppTheme.primary.withOpacity(0.5),
              ),
              SizedBox(height: ResponsiveLayout.spacing(context)),
              Text(
                'No history data available',
                style: AppTheme.headingMedium(context),
              ),
              SizedBox(height: ResponsiveLayout.spacing(context) / 2),
              Text(
                'Historical data will appear here once your devices start reporting',
                style: AppTheme.bodyMedium(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonWidgets.sectionHeader(
            context: context,
            title: 'Device History',
            subtitle: '${historyData.data.length} records found',
          ),
          SizedBox(height: ResponsiveLayout.spacing(context)),
          Expanded(child: _buildHistoryTable(context, historyData.data)),
        ],
      );
    });
  }

  Widget _buildHistoryTable(BuildContext context, List<DeviceHistory> historyItems) {
    return Container(
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
              headingRowColor: MaterialStateProperty.all(AppTheme.backgroundMedium),
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
                  label: Text('Status', style: _headerTextStyle(context)),
                ),
                DataColumn(
                  label: Text('Temperature', style: _headerTextStyle(context)),
                ),
                DataColumn(
                  label: Text('Humidity', style: _headerTextStyle(context)),
                ),
                DataColumn(
                  label: Text('Notification', style: _headerTextStyle(context)),
                ),
                DataColumn(
                  label: Text('IoT Status', style: _headerTextStyle(context)),
                ),
              ],
              rows: List<DataRow>.generate(historyItems.length, (index) {
                final item = historyItems[index];
                return DataRow(
                  cells: [
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('${index + 1}'),
                      ),
                    ),
                    DataCell(
                      Text(item.deviceId ?? 'N/A'),
                    ),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: item.status ?? false
                              ? AppTheme.success.withOpacity(0.1)
                              : AppTheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.status ?? false ? Icons.check_circle : Icons.cancel,
                              color: item.status ?? false ? AppTheme.success : AppTheme.error,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              item.status ?? false ? 'Active' : 'Inactive',
                              style: AppTheme.caption(context).copyWith(
                                color: item.status ?? false ? AppTheme.success : AppTheme.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      Text('${item.temperature?.toStringAsFixed(1) ?? 'N/A'}°C'),
                    ),
                    DataCell(
                      Text('${item.humidity?.toStringAsFixed(1) ?? 'N/A'}%'),
                    ),
                    DataCell(
                      Text(item.notification ?? 'N/A'),
                    ),
                    DataCell(
                      Text(item.iot ?? 'N/A'),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _headerTextStyle(BuildContext context) {
    return AppTheme.bodyMedium(context).copyWith(
      fontWeight: FontWeight.bold,
      color: AppTheme.primary,
    );
  }
}