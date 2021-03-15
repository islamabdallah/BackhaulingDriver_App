import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:background_locator/location_dto.dart';
import 'package:shhnatycemexdriver/core/errors/custom_error.dart';
import 'package:shhnatycemexdriver/core/models/empty_response_model.dart';
import 'package:shhnatycemexdriver/core/repositories/core_repository.dart';
import 'package:shhnatycemexdriver/core/results/result.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/trip_detail/data/models/trip.dart';
import 'package:shhnatycemexdriver/features/trip_detail/data/repositories/trip-details-repository-implementation.dart';

import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';
import 'package:shhnatycemexdriver/core/firebase/push_notification_service.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck_data.dart';

import '../../constants.dart';
import 'file_manager.dart';
import 'location_service.dart';

class LocationServiceRepository {
  static LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  int _count = -1;

  Future<void> init(Map<dynamic, dynamic> params) async {
    print("***********Init callback handler");
    if (params.containsKey('countInit')) {
      dynamic tmpCount = params['countInit'];
      if (tmpCount is double) {
        _count = tmpCount.toInt();
      } else if (tmpCount is String) {
        _count = int.parse(tmpCount);
      } else if (tmpCount is int) {
        _count = tmpCount;
      } else {
        _count = -2;
      }
    } else {
      _count = 0;
    }
    print("$_count");
//    await setLogLabel("start");
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
    print("$_count");
//    await setLogLabel("end");
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    print('$_count location in dart: ${locationDto.toString()}');
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto);
    print("here");
    await updateTrip(locationDto);
    _count++;
  }

  static Future<void> setLogLabel(String label) async {
    final date = DateTime.now();
    await FileManager.writeToLogFile(
        '------------\n$label: ${formatDateLog(date)}\n------------\n');
  }

   Future<Result<RemoteResultModel<String>>> updateTrip(LocationDto location) async {
    TripModel tripModel = await truckLocation(location);
    if (tripModel == null) return Result(error: CustomError(message: 'no truck no'));
    var dataDB =  await DBHelper.getData('truck_trip');
    List list = List();
//    list.add(tripModel.toJson());
    dataDB.map((trip){
//      print(TripModel.fromJson(trip).toJson());
//      DBHelper.deleteTrip(trip['id']);
//      DBHelper.deleteTrip(trip['requestId']);
      list.add(TripModel.fromJson(trip).toJson());
     }).toList();
    list.add(tripModel.toJson());
    print(json.encode(list));
//    List jsonList = List();
//    list.map((item) => jsonList.add(item.toJson())).toList();

    // TODO: implement LoginUser
    final response = await CoreRepository.request(url: updateLocation,
        method: HttpMethod.POST,
        converter: null,
        data: json.encode(list));
    if (response.hasDataOnly) {
      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<String>.fromJson(res);
      if (_data.flag) {
        DBHelper.deleteTrip(tripModel.requestId);
        return Result(data: _data);
      } else {
        if(tripModel.tripStatus != '0_Ideal') DBHelper.insert('truck_trip', tripModel.toJson());
        return Result(error: CustomError(message: _data.message));
      }
    }
    if (response.hasErrorOnly) {
      if(tripModel.tripStatus != '0_Ideal') DBHelper.insert('truck_trip', tripModel.toJson());
      return Result(error: response.error);
    }
  }
  truckLocation(LocationDto location) async{
//    LocalStorageService  localStorage = LocalStorageService();
//    TruckNumberModel truckNumber = await localStorage.getTruckModel();
//    NotificationModel trip = await localStorage.getCurrentTrip();
//    String token = await  localStorage.getToken();
//    String driverID = await localStorage.getDriverID();
//    String tripStatus =  await localStorage.getTripStatus();
    final currentTripDB = await DBHelper.getData('current_trip');
    NotificationModel trip = (currentTripDB.length > 0) ? NotificationModel.fromJson(currentTripDB[0]) : null;
    final currentTruckDB = await DBHelper.getData('truck_status');
    TrucKDataModel trucKData = (currentTruckDB.length > 0) ? TrucKDataModel.fromJson(currentTruckDB[0]): null;
    if(trucKData == null ) return null;

    var now = new DateTime.now();
    TripModel tripModel = TripModel(
      requestId: (trip == null )? 0: trip.requestId,
      shipmentId: (trip == null )? '0': trip.shipmentId,
      truckNumber: trucKData?.truckNumber,
      tripStatus: trucKData?.tripBreak == 0 ? trucKData?.tripStatus: '7_Break',
      dateTime: now.toString(),
      sapTruckNumber: trucKData?.sapTruckNumber,
      firebaseToken: trucKData?.firebaseToken,
      lat: (location != null) ? location.latitude.toString() : null,
      long:(location != null) ? location.longitude.toString() : null,
      driverId: (trucKData?.driverId == null )? '0': trucKData?.driverId,
    );

    return tripModel;
  }

  static Future<void> setLogPosition(int count, LocationDto data) async {
    final date = DateTime.now();


    await FileManager.writeToLogFile(
        '$count : ${formatDateLog(date)} --> ${formatLog(data)} --- isMocked: ${data.isMocked}\n');
  }

  static double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static String formatDateLog(DateTime date) {
    return date.hour.toString() +
        ":" +
        date.minute.toString() +
        ":" +
        date.second.toString();
  }

  static String formatLog(LocationDto locationDto) {
    return dp(locationDto.latitude, 4).toString() +
        " " +
        dp(locationDto.longitude, 4).toString();
  }
}