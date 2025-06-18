import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remote_monotoring/core/controllers/navigation_controller.dart';
import 'package:remote_monotoring/utils/Layouts/app_layout.dart';
import 'package:remote_monotoring/utils/Layouts/responsive_layout.dart';
import 'package:remote_monotoring/utils/theme/app_theme.dart';
import 'package:remote_monotoring/utils/widgets/common_widgets.dart';
import 'dart:math' as math;

class Analyticspage extends StatelessWidget {
  Analyticspage({super.key});

  final NavigationController navigationController = Get.find<NavigationController>();

  // Sample devices for dropdown
  final List<Map<String, dynamic>> devices = [
    {'id': 1, 'name': 'Server 001', 'type': 'Server'},
    {'id': 2, 'name': 'Workstation 102', 'type': 'Workstation'},
    {'id': 3, 'name': 'Router 001', 'type': 'Network'},
    {'id': 4, 'name': 'Backup Server', 'type': 'Server'},
    {'id': 5, 'name': 'Development PC', 'type': 'Workstation'},
  ];

  // Selected device and time range
  final RxInt selectedDeviceId = 1.obs;
  final RxString selectedTimeRange = 'Last 24 Hours'.obs;

  // Chart data (would normally come from API)
  final List<Map<String, dynamic>> cpuData = List.generate(24, (index) {
    return {
      'time': DateTime.now().subtract(Duration(hours: 24 - index)),
      'value': 30 + (math.Random().nextDouble() * 50),
    };
  });

  final List<Map<String, dynamic>> memoryData = List.generate(24, (index) {
    return {
      'time': DateTime.now().subtract(Duration(hours: 24 - index)),
      'value': 40 + (math.Random().nextDouble() * 40),
    };
  });

  final List<Map<String, dynamic>> networkData = List.generate(24, (index) {
    return {
      'time': DateTime.now().subtract(Duration(hours: 24 - index)),
      'value': 10 + (math.Random().nextDouble() * 70),
    };
  });

  final List<Map<String, dynamic>> diskData = List.generate(24, (index) {
    return {
      'time': DateTime.now().subtract(Duration(hours: 24 - index)),
      'value': 50 + (index * 0.5) + (math.Random().nextDouble() * 10),
    };
  });

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Analytics',
      subtitle: 'Insights and data visualization',
      selectedIndex: 3, // Index for Analytics
      onMenuItemTapped: navigationController.onMenuItemTapped,
      actions: Row(
        children: [
          CommonWidgets.secondaryButton(
            context: context,
            text: 'Filter',
            icon: Icons.filter_list,
            onPressed: () => _showFilterDialog(context),
          ),
          SizedBox(width: ResponsiveLayout.spacing(context)),
          CommonWidgets.primaryButton(
            context: context,
            text: 'Generate Report',
            icon: Icons.assessment,
            onPressed: () {
              // Generate report logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report generated successfully'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
          ),
        ],
      ),
      child: _buildAnalyticsContent(context),
    );
  }

  Widget _buildAnalyticsContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDeviceSelector(context),
              SizedBox(height: ResponsiveLayout.spacing(context)),
              _buildOverviewCards(context),
              SizedBox(height: ResponsiveLayout.spacing(context) * 2),
              _buildCharts(context, constraints),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeviceSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Device',
                  style: AppTheme.bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<int>(
                  value: selectedDeviceId.value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.backgroundMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  items: devices.map((device) => DropdownMenuItem<int>(
                    value: device['id'] as int,
                    child: Text(
                      '${device['name']} (${device['type']})',
                      style: AppTheme.bodyMedium(context),
                    ),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedDeviceId.value = value;
                    }
                  },
                  dropdownColor: AppTheme.backgroundMedium,
                )),
              ],
            ),
          ),
          SizedBox(width: ResponsiveLayout.spacing(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Range',
                  style: AppTheme.bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<String>(
                  value: selectedTimeRange.value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.backgroundMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  items: [
                    'Last 24 Hours',
                    'Last 7 Days',
                    'Last 30 Days',
                    'Last 90 Days',
                  ].map((range) => DropdownMenuItem<String>(
                    value: range,
                    child: Text(
                      range,
                      style: AppTheme.bodyMedium(context),
                    ),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedTimeRange.value = value;
                    }
                  },
                  dropdownColor: AppTheme.backgroundMedium,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context) {
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
        _buildOverviewCard(
          context: context,
          title: 'CPU Usage',
          value: '${cpuData.last['value'].toStringAsFixed(1)}%',
          icon: Icons.memory,
          color: AppTheme.primary,
          trend: '+2.3%',
          isUp: true,
        ),
        _buildOverviewCard(
          context: context,
          title: 'Memory Usage',
          value: '${memoryData.last['value'].toStringAsFixed(1)}%',
          icon: Icons.storage,
          color: AppTheme.info,
          trend: '-1.5%',
          isUp: false,
        ),
        _buildOverviewCard(
          context: context,
          title: 'Network Traffic',
          value: '${networkData.last['value'].toStringAsFixed(1)}',
          icon: Icons.wifi,
          color: AppTheme.success,
          trend: '+0.8 MB/s',
          isUp: true,
        ),
        _buildOverviewCard(
          context: context,
          title: 'Disk Usage',
          value: '${diskData.last['value'].toStringAsFixed(1)}%',
          icon: Icons.disc_full,
          color: diskData.last['value'] > 80 ? AppTheme.warning : AppTheme.accentColor,
          trend: '+0.5%',
          isUp: true,
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
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

  Widget _buildCharts(BuildContext context, BoxConstraints constraints) {
    // Determine layout based on screen width
    final isWideScreen = constraints.maxWidth >= 1200;

    if (isWideScreen) {
      // Two charts per row for wide screens
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCPUChart(context)),
              SizedBox(width: ResponsiveLayout.spacing(context)),
              Expanded(child: _buildMemoryChart(context)),
            ],
          ),
          SizedBox(height: ResponsiveLayout.spacing(context) * 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildNetworkChart(context)),
              SizedBox(width: ResponsiveLayout.spacing(context)),
              Expanded(child: _buildDiskChart(context)),
            ],
          ),
        ],
      );
    } else {
      // One chart per row for narrow screens
      return Column(
        children: [
          _buildCPUChart(context),
          SizedBox(height: ResponsiveLayout.spacing(context) * 2),
          _buildMemoryChart(context),
          SizedBox(height: ResponsiveLayout.spacing(context) * 2),
          _buildNetworkChart(context),
          SizedBox(height: ResponsiveLayout.spacing(context) * 2),
          _buildDiskChart(context),
        ],
      );
    }
  }

  Widget _buildCPUChart(BuildContext context) {
    return CommonWidgets.card(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CPU Usage',
                      style: AppTheme.headingSmall(context),
                    ),
                    Text(
                      'Average: ${_calculateAverage(cpuData).toStringAsFixed(1)}%',
                      style: AppTheme.bodySmall(context),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildChartPlaceholder(
                context,
                'CPU Usage Over Time',
                AppTheme.primary,
                cpuData,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryChart(BuildContext context) {
    return CommonWidgets.card(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Memory Usage',
                      style: AppTheme.headingSmall(context),
                    ),
                    Text(
                      'Average: ${_calculateAverage(memoryData).toStringAsFixed(1)}%',
                      style: AppTheme.bodySmall(context),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildChartPlaceholder(
                context,
                'Memory Usage Over Time',
                AppTheme.info,
                memoryData,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkChart(BuildContext context) {
    return CommonWidgets.card(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Network Traffic',
                      style: AppTheme.headingSmall(context),
                    ),
                    Text(
                      'Average: ${_calculateAverage(networkData).toStringAsFixed(1)}',
                      style: AppTheme.bodySmall(context),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildChartPlaceholder(
                context,
                'Network Traffic Over Time',
                AppTheme.success,
                networkData,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiskChart(BuildContext context) {
    return CommonWidgets.card(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Disk Usage',
                      style: AppTheme.headingSmall(context),
                    ),
                    Text(
                      'Average: ${_calculateAverage(diskData).toStringAsFixed(1)}%',
                      style: AppTheme.bodySmall(context),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildChartPlaceholder(
                context,
                'Disk Usage Over Time',
                AppTheme.accentColor,
                diskData,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder(
      BuildContext context,
      String title,
      Color color,
      List<Map<String, dynamic>> data,
      ) {
    return CustomPaint(
      size: const Size(double.infinity, 300),
      painter: ChartPainter(data: data, color: color),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 48,
              color: color.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTheme.bodyMedium(context),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAverage(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0;

    double sum = 0;
    for (var item in data) {
      sum += item['value'] as double;
    }

    return sum / data.length;
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundMedium,
        title: Text('Filter Analytics', style: AppTheme.headingSmall(context)),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Device', style: AppTheme.bodyMedium(context).copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: selectedDeviceId.value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: devices.map((device) => DropdownMenuItem<int>(
                  value: device['id'] as int,
                  child: Text('${device['name']} (${device['type']})'),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedDeviceId.value = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              Text('Time Range', style: AppTheme.bodyMedium(context).copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedTimeRange.value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Last 24 Hours',
                  'Last 7 Days',
                  'Last 30 Days',
                  'Last 90 Days',
                ].map((range) => DropdownMenuItem<String>(
                  value: range,
                  child: Text(range),
                )).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedTimeRange.value = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              Text('Metrics', style: AppTheme.bodyMedium(context).copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('CPU'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                  FilterChip(
                    label: const Text('Memory'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                  FilterChip(
                    label: const Text('Network'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                  FilterChip(
                    label: const Text('Disk'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.bodyMedium(context).copyWith(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Apply filters
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            child: Text('Apply', style: AppTheme.bodyMedium(context)),
          ),
        ],
      ),
    );
  }
}

// Custom painter for chart visualization
class ChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final Color color;

  ChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    // Find min and max values
    double minValue = double.infinity;
    double maxValue = -double.infinity;

    for (var point in data) {
      final value = point['value'] as double;
      if (value < minValue) minValue = value;
      if (value > maxValue) maxValue = value;
    }

    // Add some padding to min/max
    minValue = math.max(0, minValue - 5);
    maxValue = maxValue + 5;

    // Calculate step sizes
    final xStep = size.width / (data.length - 1);
    final yScale = size.height / (maxValue - minValue);

    // Start paths
    double startX = 0;
    double startY = size.height - ((data[0]['value'] as double) - minValue) * yScale;

    path.moveTo(startX, startY);
    fillPath.moveTo(startX, size.height);
    fillPath.lineTo(startX, startY);

    // Draw lines
    for (int i = 1; i < data.length; i++) {
      final x = xStep * i;
      final y = size.height - ((data[i]['value'] as double) - minValue) * yScale;

      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    // Complete fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw on canvas
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    // Horizontal grid lines
    final numHorizontalLines = 5;
    final yStep = size.height / numHorizontalLines;

    for (int i = 0; i <= numHorizontalLines; i++) {
      final y = yStep * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Vertical grid lines
    final numVerticalLines = 6;
    final xGridStep = size.width / numVerticalLines;

    for (int i = 0; i <= numVerticalLines; i++) {
      final x = xGridStep * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
