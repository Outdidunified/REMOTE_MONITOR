import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionController extends GetxController {
  var isLoggedIn = false.obs;
  var userId = 0.obs;
  var username = ''.obs;
  var token = ''.obs;
  var emailId = ''.obs;
  var roleId = 0.obs;
  var roleName = ''.obs;
  var phone = ''.obs;

  final SharedPreferences? prefs;

  SessionController({this.prefs});

  @override
  void onInit() {
    super.onInit();
    loadSession();
  }

  Future<void> loadSession() async {
    if (prefs == null) {
      debugPrint('SharedPreferences not available, cannot load session');
      return;
    }

    isLoggedIn.value = prefs!.getBool('isLoggedIn') ?? false;
    userId.value = prefs!.getInt('userId') ?? 0;
    username.value = prefs!.getString('username') ?? '';
    emailId.value = prefs!.getString('emailId') ?? '';
    token.value = prefs!.getString('token') ?? '';
    roleId.value = prefs!.getInt('roleId') ?? 0;
    roleName.value = prefs!.getString('roleName') ?? '';
    phone.value = prefs!.getString('phone') ?? '';
  }

  Future<void> saveSession({
    required int userId,
    required String emailId,
    required String token,
    String username = '',
    int roleId = 0,
    String roleName = '',
    String phone = '',
  }) async {
    if (prefs == null) {
      debugPrint('SharedPreferences not available, cannot save session');
      return;
    }

    await prefs!.setBool('isLoggedIn', true);
    await prefs!.setInt('userId', userId);
    await prefs!.setString('emailId', emailId);
    await prefs!.setString('token', token);
    await prefs!.setString('username', username);
    await prefs!.setInt('roleId', roleId);
    await prefs!.setString('roleName', roleName);
    await prefs!.setString('phone', phone);

    // Update all observable values
    isLoggedIn.value = true;
    this.userId.value = userId;
    this.emailId.value = emailId;
    this.token.value = token;
    this.username.value = username;
    this.roleId.value = roleId;
    this.roleName.value = roleName;
    this.phone.value = phone;
  }

  Future<void> clearSession() async {
    if (prefs == null) {
      debugPrint('SharedPreferences not available, cannot clear session');
      return;
    }

    await prefs!.clear();

    // Reset all observable values
    isLoggedIn.value = false;
    userId.value = 0;
    username.value = '';
    token.value = '';
    emailId.value = '';
    roleId.value = 0;
    roleName.value = '';
    phone.value = '';
  }
}