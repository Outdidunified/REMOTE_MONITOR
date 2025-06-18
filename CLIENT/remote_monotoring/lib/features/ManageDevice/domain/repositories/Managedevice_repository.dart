
import 'dart:ffi';

import 'package:remote_monotoring/features/ManageDevice/data/api.dart';
import 'package:remote_monotoring/features/ManageDevice/domain/models/Managedevice_model.dart';


class ManagedeviceRepository {
  final ManageDeviceApiCalls _api = ManageDeviceApiCalls();

  Future<ManageDeviceResponse> fetchdevicedata(token) async {
    try {
      final Map<String, dynamic> responseJson = await _api.FetchDevice(token);

      return ManageDeviceResponse.fromJson(responseJson); // Parse JSON to model
    } catch (e) {
      rethrow; // Re-throw the error to be handled by the controller
    }
  }

  Future<AddDeviceResponse> Adddevice(String token,int user_id,String device_id,String createBy) async {
    try {
      final Map<String, dynamic> responseJson = await _api.AddDevice(token,user_id,device_id,createBy);

      return AddDeviceResponse.fromJson(responseJson); // Parse JSON to model
    } catch (e) {
      rethrow; // Re-throw the error to be handled by the controller
    }
  }


  Future<UpdateStatusResponse> UpdateDevicestatus(String token,int user_id,String device_id,String modifiedby,bool status) async {
    try {
      final Map<String, dynamic> responseJson = await _api.Updatedevicestatus(token,user_id,device_id,modifiedby,status);

      return UpdateStatusResponse.fromJson(responseJson); // Parse JSON to model
    } catch (e) {
      rethrow; // Re-throw the error to be handled by the controller
    }
  }
}
