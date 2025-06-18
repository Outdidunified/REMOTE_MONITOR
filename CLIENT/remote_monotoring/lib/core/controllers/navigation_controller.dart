import 'package:get/get.dart';

/// A controller to manage navigation state across the app
class NavigationController extends GetxController {
  // Observable state for the currently selected menu item
  final RxInt selectedIndex = 0.obs;

  // Routes corresponding to each menu item
  final List<String> routes = [
    '/dashboard',
    '/manageDevices',
    '/history',
    '/analytics',
    '/settings',
  ];

  @override
  void onInit() {
    super.onInit();

    // Initialize based on current route
    _updateSelectedIndexFromRoute(Get.currentRoute);

    // Add listener to route changes
    Get.rootDelegate.addListener(() {
      _updateSelectedIndexFromRoute(Get.currentRoute);
    });
  }

  /// Update the selected index based on the current route
  void _updateSelectedIndexFromRoute(String route) {
    for (int i = 0; i < routes.length; i++) {
      if (route.contains(routes[i])) {
        selectedIndex.value = i;
        return;
      }
    }

    // Default to dashboard if no match
    if (route == '/dashboard' || route == '/') {
      selectedIndex.value = 0;
    }
  }

  /// Navigate to the page corresponding to the selected menu item
  void onMenuItemTapped(int index) {
    // Update the selected index
    selectedIndex.value = index;

    // Navigate to the corresponding route
    Get.offAllNamed(routes[index]);
  }
}
