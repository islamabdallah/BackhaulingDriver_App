// @dart=2.9
import 'package:shhnatycemexdriver/core/repositories/core_repository.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';
import 'package:shhnatycemexdriver/core/results/result.dart';
import 'package:shhnatycemexdriver/core/models/empty_response_model.dart';
import 'dart:convert';
import 'package:shhnatycemexdriver/core/constants.dart';

class NotificationRepositoryImplementation  {


  Future<Result<List<NotificationModel> >> getAllNotifications( ) async{
    List<NotificationModel> notifications = [];
//    TruckNumberModel truckNumberModel = TruckNumberModel(truckNumber:'Test', sapTruckNumber: 'RNT_Test', firebaseToken: 'eFUFsz1lSN63XQl8PrOWks:APA91bFkEBW4KFzUmzP4NfN7IEC5jw1EXjpZySP6qD0N7cHEag92iWv34ySKDxZqOM0dYmggymef3mA7U5c3hZudKiYMS8QgiTmAsE72NLLPF_sl4ax942p7ewq6V16dKZD5DO6GUM2f');
//    LocalStorageService().setTruckModel(truckNumberModel: truckNumberModel) ;
////RNT-ي ا ج 7349
//    DBHelper.update('truck_trip', 'ي ا ج 7349', 'truckNumber');
//    DBHelper.update('truck_trip', 'RNT-ي ا ج 7349', 'sapTruckNumber');
//
//        {truckNumber: Test , sapTruckNumber: RNT_Test,
//        firebaseToken: dEOFgkmSTpq3zf8p0Zry8E:APA91bE_RTIDmW9jIZmQg08Gv-4IUk_UrE-Qk5MXJJw3Lt1I60dkiDi5SLELDwFBsFNXhLInaEo3dkESR8l3juSnhVhBPx7mAjTFDugd4dT7_2B3NXzv1EJ91xpp9w7Cdfnzpqc_3KEX}
    TruckNumberModel truckNumber = await LocalStorageService().getTruckModel();
    // TODO: implement getAllNotifications
//    print(truckNumber.toJson());
    final response = await CoreRepository.request(url: allTrips ,method: HttpMethod.POST, converter: null,
        data: truckNumber.toJson());
      if(response.hasDataOnly) {
        final data =response.data;
        data.map((truck)=> notifications.add(NotificationModel.fromJson(truck))).toList();
        return Result(data: notifications);
      }
      if(response.hasErrorOnly) {

        return Result(error: response.error);
      }

//    notifications = [
//      new NotificationModel(customerName: "كوكاكولا",shipmentId: '1', tripStatus: 'pending',tripType: 'Cemex',
//          requestId: 0, destAddress: "القاهره",srcAddress: 'أسيوط',pickupDate: '12-12-2020'
//          ,destContactNumber: '0106806853',srcContactNumber: '01068068153'),
//      new NotificationModel(customerName: "بيبسي",shipmentId: '1', tripStatus: 'pending',tripType: 'Cemex',
//          requestId: 1, destAddress: "القاهره",srcAddress: 'أسيوط',pickupDate: '12-12-2020'
//          ,destContactNumber: '0106806853',srcContactNumber: '01068068153'),
//      new NotificationModel(customerName: "رنين",shipmentId: '1', tripStatus: 'pending',tripType: 'Cemex',
//          requestId: 2, destAddress: "القاهره",srcAddress: 'أسيوط',pickupDate: '12-12-2020'
//          ,destContactNumber: '0106806853',srcContactNumber: '01068068153'),
//      new NotificationModel(customerName: "اسمنت اسيوط",shipmentId: '1', tripStatus: 'pending',tripType: 'Cemex',
//          requestId: 3, destAddress: "القاهره",srcAddress: 'أسيوط',pickupDate: '12-12-2020'
//          ,destContactNumber: '0106806853',srcContactNumber: '01068068153'),
//      new NotificationModel(customerName: "مصانع الاصدقاء",shipmentId: '4', tripStatus: 'pending',tripType: 'Backhauling',
//          requestId: 4,destAddress: "القاهره",srcAddress: 'أسيوط',pickupDate: '12-12-2020'
//          ,destContactNumber: '0106806853',srcContactNumber: '01068068153'),
//      new NotificationModel(customerName: "مركز امجاد",shipmentId: '5', tripStatus: 'pending',tripType: 'Backhauling',
//          requestId: 5, destAddress: "القاهره",srcAddress: 'أسيوط',pickupDate: '12-12-2020'
//          ,destContactNumber: '0106806853',srcContactNumber: '01068068153'),
//      new NotificationModel(customerName: "العبد",shipmentId: '6', tripStatus: 'pending',tripType: 'Backhauling',
//          requestId: 6,destAddress: "القاهره",srcAddress: 'أسيوط',pickupDate: '12-12-2020'
//          ,destContactNumber: '0106806853',srcContactNumber: '01068068153'),
//      new NotificationModel(customerName: "سرميكا كلوبترا",shipmentId: '7', tripStatus: 'pending',tripType: 'Backhauling',
//          requestId: 7,destAddress: "القاهره",srcAddress: 'أسيوط',pickupDate: '12-12-2020'
//          ,destContactNumber: '0106806853',srcContactNumber: '01068068153'),
//      new NotificationModel(customerName: "5fb5ab4a7ftest",shipmentId: '8', tripStatus: 'pending',tripType: 'Backhauling',
//          requestId: 8, destAddress: "القاهره",srcAddress: 'أسيوط',pickupDate: '12-12-2020'
//          ,destContactNumber: '0106806853',srcContactNumber: '01068068153'),
//      new NotificationModel(customerName: "5fb5ab4a7f3dbahmed",shipmentId: '9', tripStatus: 'pending',tripType: 'Backhauling',
//          requestId: 9, destAddress: "القاهره",srcAddress: 'أسيوط',pickupDate: '12-12-2020'
//          ,destContactNumber: '0106806853',srcContactNumber: '01068068153'),
//    ];
//    return  notifications.isEmpty ?  Result(error: null): Result(data: notifications);
  }

}
