// @dart=2.9

// import 'dart:developer';
// import 'package:shhnatycemexdriver/core/errors/base_error.dart';
// import 'package:shhnatycemexdriver/core/errors/unexpected_error.dart';
// import 'package:dartz/dartz.dart';
// import 'package:location/location.dart';

// class LocationService {
//   Location location = new Location();

//   /**
//    * this function for check and request location GPS service in Android
//    */
//   Future<Either<BaseError, bool>> checkAndRequestLocationService() async {
//     bool _serviceEnabled;
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return Left(UnExpectedError());
//       } else {
//         return Right(true);
//       }
//     } else {
//       return Right(true);
//     }
//   }

// /**
//    * this function for check has permission for  location GPS service in IOS
//    */
//   Future<Either<BaseError, bool>> checkPermissionGranted() async {
//     PermissionStatus _permissionGranted;
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return Left(UnExpectedError());
//       } else {
//         return Right(true);
//       }
//     } else {
//       return Right(true);
//     }
//   }

//   /**
//    * this method get current user Location
//    */
//   Future<Either<BaseError, LocationData>> getCurrentLocation() async {
//     try {
//       LocationData _locationData;

//       final serviceEnabledResult = await checkAndRequestLocationService();
//       if (serviceEnabledResult.isLeft()) return Left(UnExpectedError());

//       final hasPermissionResult = await checkPermissionGranted();
//       if (hasPermissionResult.isLeft()) return Left(UnExpectedError());

//       _locationData = await location.getLocation();
//       return Right(_locationData);
//     } catch (error) {
//       return Left(UnExpectedError());
//     }
//   }
// }


import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shhnatycemexdriver/core/firebase/push_notification_service.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';
import 'package:shhnatycemexdriver/features/trip_detail/data/models/trip.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck_data.dart';

import 'location_service_repository.dart';

class LocationService {

  Future<Position> currentLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  truckLocation() async{
    LocalStorageService  localStorage = LocalStorageService();
    Position currentLocation = await this.currentLocation();
    TruckNumberModel truckNumber = await localStorage.getTruckModel();
    if(truckNumber == null) return null;
    String token = await localStorage.getToken();
    String driverID = await localStorage.getDriverID();
    final currentTripDB = await DBHelper.getData('current_trip');
    NotificationModel trip = (currentTripDB.length > 0) ? NotificationModel.fromJson(currentTripDB[0]) : null;
    final currentTruckDB = await DBHelper.getData('truck_status');
    TrucKDataModel trucKData = (currentTruckDB.length > 0) ? TrucKDataModel.fromJson(currentTruckDB[0]): null;


    var now = new DateTime.now();
      TripModel tripModel = TripModel(
      requestId: (trip == null )? trip: trip.requestId,
      shipmentId: (trip == null )? trip: trip.shipmentId,
      truckNumber: truckNumber.truckNumber,
      tripStatus: trucKData.tripStatus,
      dateTime: now.toString(),
      sapTruckNumber: truckNumber.sapTruckNumber,
      firebaseToken: token,
      lat: (currentLocation != null) ? currentLocation.latitude.toString() : null,
      long:(currentLocation != null) ? currentLocation.longitude.toString() : null,
      driverId: driverID,
    );
    return tripModel;
  }

  updateTimerLoction() async {
    print("truckLocation");
    Position currentLocation = await this.currentLocation();
    LocationServiceRepository myLocationCallbackRepository = LocationServiceRepository();
    await myLocationCallbackRepository.updateTrip(currentLocation);
  }


}