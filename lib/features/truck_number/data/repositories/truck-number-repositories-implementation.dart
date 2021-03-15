import 'package:shared_preferences/shared_preferences.dart';
import 'package:shhnatycemexdriver/core/errors/base_error.dart';
import 'package:shhnatycemexdriver/core/errors/custom_error.dart';
import 'package:shhnatycemexdriver/core/firebase/push_notification_service.dart';
import 'package:shhnatycemexdriver/core/repositories/core_repository.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';
import 'package:shhnatycemexdriver/core/results/result.dart';
import 'package:shhnatycemexdriver/core/models/empty_response_model.dart';
import 'dart:convert';
import 'package:shhnatycemexdriver/core/constants.dart';

class GetTruckNumberRepositoryImplementation  {


  Future<Result<List<TruckNumberModel>>> getAllAvailableTruck( ) async{
    List<TruckNumberModel> trucks = [];
    // TODO: implement getAllAvailableTruck
    final response = await CoreRepository.request(url:trunksUrl,
        method: HttpMethod.GET, converter: null );

      if(response.hasDataOnly) {
        final data =response.data;
        data.map((truck) => trucks.add(TruckNumberModel.fromJson(truck) )).toList();
        print(trucks.length);
        return Result(data: trucks);
      }
      if(response.hasErrorOnly) {
        print(response.error);
        return Result(error: response.error);
      }
//    trucks = [
//      new TruckNumberModel(TruckNumber: "5fb5ab4aazhar",
//          SapTruckNumber: '0', FirebaseToken: "e5e4f70b-2bec-4db1-b8ab-c7llllllllllf23685caab"),
//      new TruckNumberModel(TruckNumber: "5fb5ab4ahmed",
//          SapTruckNumber: '1', FirebaseToken: "e5e4f70b-2bec-4db1-b8ab-c7f23685caab"),
//      new TruckNumberModel(TruckNumber: "5fb5ab4a7f3omar",
//          SapTruckNumber: '2', FirebaseToken: "e5e4f70b-2bec-4db1-b8ab-c7f23685caab"),
//      new TruckNumberModel(TruckNumber: "5fb5ab4a7ftest",
//          SapTruckNumber: '3', FirebaseToken: "e5e4f70b-2bec-4db1-b8ab-c7f23685caab"),
//      new TruckNumberModel(TruckNumber: "5fb5ab4a7f3dbahmed",
//          SapTruckNumber: '4', FirebaseToken: "e5e4f70b-2bec-4db1-b8ab-c7f23685caab"),
//
//    ];
 //   return  trucks.isEmpty ?  Result(error: null): Result(data: trucks);
  }

  /**
   * register truck number for the first time app was opened .
   */

  Future<Result<RemoteResultModel<String>>> registerTruckNumber (TruckNumberModel truckNumberModel) async {
    print (truckNumberModel);
    String token = await  PushNotificationService.getDeviceToken();
    truckNumberModel.firebaseToken = token;
    print (truckNumberModel.toJson());
    // TODO: implement registerTruckNumber
    final response = await CoreRepository.request(url: postTruck,method: HttpMethod.POST, converter: null, data: truckNumberModel.toJson());
    if(response.hasDataOnly) {
      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<String>.fromJson(res);
      if(_data.flag) {
       DBHelper.insert('truck_data', truckNumberModel.toJson());
      var trucKDBModel =  {
        "requestId": 0,
        "shipmentId": null,
        "truckNumber": truckNumberModel.truckNumber,
        "sapTruckNumber": truckNumberModel.sapTruckNumber,
        "tripStatus": '0_Ideal',
        "tripBreak": 0,
        "firebaseToken": token,
        "driverId": null
      };
       DBHelper.insert('truck_status', trucKDBModel);

       print("after save seen ");
        await LocalStorageService().setTruckModel(truckNumberModel: truckNumberModel) ;
        return Result(data: _data);
      } else {
      return Result(error: CustomError(message:_data.message ));
      }

    }
    if(response.hasErrorOnly) {
      return Result(error: response.error);
    }


//    return Result(data: EmptyResultModel());
  }
}
