

import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:remote_monotoring/core/services/base_api_service.dart';
import 'package:remote_monotoring/features/ManageDevice/data/url.dart';

class ManageDeviceApiCalls extends BaseApiService {
  Future<Map<String, dynamic>> FetchDevice(String token) async {
    debugPrint('🛰️ Hitting URL: ${ManageDeviceUrl.fetchDevice.url}');

    final result = await makeRequest<Map<String, dynamic>>(
      url: ManageDeviceUrl.fetchDevice.url,
      method: ManageDeviceUrl.fetchDevice.method,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );
    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }
  Future<Map<String, dynamic>> AddDevice(String token,int user_id,String device_id,String createBy) async {
    debugPrint('🛰️ Hitting URL: ${ManageDeviceUrl.addDevice.url}');

    final result = await makeRequest<Map<String, dynamic>>(
      url: ManageDeviceUrl.addDevice.url,
      method: ManageDeviceUrl.addDevice.method,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: {
        "user_id":user_id,
        "device_id":device_id,
        "createBy":createBy
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );
    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }
  Future<Map<String, dynamic>> Updatedevicestatus(String token,int user_id,String device_id,String modifiedBy,bool status) async {
    debugPrint('🛰️ Hitting URL: ${ManageDeviceUrl.updatedevicestatus.url}');

    final result = await makeRequest<Map<String, dynamic>>(
      url: ManageDeviceUrl.updatedevicestatus.url,
      method: ManageDeviceUrl.updatedevicestatus.method,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: {
        "user_id":user_id,
        "device_id":device_id,
        "modifiedBy":modifiedBy,
        "status":status
      },
      responseParser: (data) => data as Map<String, dynamic>,
    );
    debugPrint('🔽 Final Parsed Response => $result');
    return result;
  }



}
