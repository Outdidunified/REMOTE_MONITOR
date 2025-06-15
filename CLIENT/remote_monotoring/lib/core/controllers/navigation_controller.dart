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

  /// Navigate to the page corresponding to the selected menu item
  void onMenuItemTapped(int index) {
    // Update the selected index
    selectedIndex.value = index;

    // Navigate to the corresponding route
    Get.offAllNamed(routes[index]);
  }
}
