class DashboarddataResponse {
  final bool error;
  final bool status;
  final List<dynamic> data;
  final String message;

  DashboarddataResponse({
    required this.error,
    required this.status,
    required this.data,
    this.message = '',
  });

  factory DashboarddataResponse.fromJson(Map<String, dynamic> json) {
    return DashboarddataResponse(
      error: json['error'] as bool? ?? false,
      status: json['status'] as bool? ?? false,
      data: json['data'] as List<dynamic>? ?? [],
      message: json['message'] as String? ?? '',
    );
  }

  // Computed properties for dashboard metrics
  int get deviceListTotalCount => data.length;

  int get deviceListActiveCount =>
      data.where((device) => device['status'] == true).length;

  int get deviceListDeactiveCount =>
      data.where((device) => device['status'] == false).length;

  // For history, we'll use the same device list for now
  // In a real app, you'd have a separate API for history
  List<dynamic> get deviceHistory =>
      data.where((device) => device['modifiedDate'] != null).toList();

  int get deviceHistoryTotalCount => deviceHistory.length;

  int get deviceHistoryActiveCount =>
      deviceHistory.where((device) => device['status'] == true).length;

  int get deviceHistoryDeactiveCount =>
      deviceHistory.where((device) => device['status'] == false).length;

  List<dynamic> get deviceList => data;
}
