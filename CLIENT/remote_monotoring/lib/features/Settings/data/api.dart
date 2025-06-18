import 'package:flutter/foundation.dart';
import 'package:remote_monotoring/core/services/base_api_service.dart';
import 'package:remote_monotoring/features/ManageDevice/data/url.dart';
import 'package:remote_monotoring/features/Settings/data/url.dart';

class SettingsApiCall extends BaseApiService {

  Future<Map<String, dynamic>> FetchUserDetails(String token,int user_id) async {
    debugPrint('🛰️ Hitting URL: ${SettingsUrl.fetchUserProfile.url}');

    final result = await makeRequest<Map<String, dynamic>>(
      url: SettingsUrl.fetchUserProfile.url,
      method: SettingsUrl.fetchUserProfile.method,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: {
        "user_id":user_id,
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );
    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }

  Future<Map<String, dynamic>> updateUserDetails(String token,int user_id,String name ,int phone, String password , String modifiedBy) async {
    debugPrint('🛰️ Hitting URL: ${SettingsUrl.updateUserProfile.url}');

    final result = await makeRequest<Map<String, dynamic>>(
      url:SettingsUrl.updateUserProfile.url,
      method:SettingsUrl.updateUserProfile.method,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: {
        "user_id":user_id,
        "name":name,
        "phone":phone,
        "password": password,
        "modifiedBy":modifiedBy
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );
    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }



}
