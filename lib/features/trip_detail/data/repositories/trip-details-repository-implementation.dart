import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/errors/custom_error.dart';
import 'package:shhnatycemexdriver/core/flutter_datetime_picker.dart';
import 'package:shhnatycemexdriver/core/repositories/core_repository.dart';
import 'package:shhnatycemexdriver/core/results/result.dart';
import 'package:shhnatycemexdriver/core/models/empty_response_model.dart';
import 'package:shhnatycemexdriver/core/services/http_service/http_service.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/services/location_service/location_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';
import 'package:shhnatycemexdriver/features/trip_detail/data/models/trip.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';

class TripDetailRepositoryImplementation {
  final httpCall = HttpService();

  Future<Result<RemoteResultModel<String>>> updateTripStatus({NotificationModel trip,String status}) async {
    TripModel tripModel = await LocationService().truckLocation();
    tripModel.requestId = trip.requestId;
    tripModel.shipmentId = trip.shipmentId;
    tripModel.tripStatus = status;
//    print(tripModel.requestId);
//    print(tripModel.truckNumber);
    var dataDB =  await DBHelper.getData('truck_trip');
    List list = List();
    dataDB.map((trip) async{
//      print("indb");
//      await DBHelper.deleteTrip(trip['requestId']);
//      print(trip);
      list.add(TripModel.fromJson(trip).toJson());
    }).toList();
    list.add(tripModel.toJson());
    print(json.encode(list));
    final response = await CoreRepository.request(url: updateLocation,
        method: HttpMethod.POST, converter: null, data: json.encode(list));
    if (response.hasDataOnly) {
      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<String>.fromJson(res);

      if (_data.flag) {
        await DBHelper.deleteTrip(tripModel.requestId);
        return Result(data: _data);
      } else {
        DBHelper.insert('truck_trip', tripModel.toJson());
        return Result(error: CustomError(message: _data.message));
      }
    }
    if (response.hasErrorOnly) {
      print("internet Error Azhar");
      DBHelper.insert('truck_trip', tripModel.toJson());
      return Result(error: response.error);
    }
//    final _data = RemoteResultModel<String>.fromJson({"data": 'test'});
//
//    return Result(data: _data);
  }
}
