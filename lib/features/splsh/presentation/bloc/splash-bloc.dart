import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shhnatycemexdriver/core/app_shared_prefs.dart';
import 'package:shhnatycemexdriver/features/splsh/presentation/bloc/splash-state.dart';
import 'package:shhnatycemexdriver/features/splsh/presentation/bloc/splash-event.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';


class SplashBloc extends Bloc<BaseSplashEvent, BaseSplashState> {
  SplashBloc(BaseSplashState initialState) : super(initialState);

  @override
  Stream<BaseSplashState> mapEventToState(BaseSplashEvent event) async* {
    //to add truck when run app
//    TruckNumberModel truckNumberModel = TruckNumberModel(truckNumber:'Test', sapTruckNumber: 'RNT_Test',
//        firebaseToken: "dEOFgkmSTpq3zf8p0Zry8E:APA91bE_RTIDmW9jIZmQg08Gv-4IUk_UrE-Qk5MXJJw3Lt1I60dkiDi5SLELDwFBsFNXhLInaEo3dkESR8l3juSnhVhBPx7mAjTFDugd4dT7_2B3NXzv1EJ91xpp9w7Cdfnzpqc_3KEX");
//    DBHelper.insert('truck_data', truckNumberModel.toJson());
//    var trucKDBModel =  {
//      "requestId": 0,
//      "shipmentId": null,
//      "truckNumber": "Test",
//      "sapTruckNumber": "RNT_Test",
//      "tripStatus": '0_Ideal',
//      "tripBreak": 0,
//      "firebaseToken": "dEOFgkmSTpq3zf8p0Zry8E:APA91bE_RTIDmW9jIZmQg08Gv-4IUk_UrE-Qk5MXJJw3Lt1I60dkiDi5SLELDwFBsFNXhLInaEo3dkESR8l3juSnhVhBPx7mAjTFDugd4dT7_2B3NXzv1EJ91xpp9w7Cdfnzpqc_3KEX",
//      "driverId": null
//    };
//    DBHelper.insert('truck_status', trucKDBModel);

    // TODO: implement mapEventToState
    final dataDB =  await DBHelper.getData('truck_data');

    try {
       bool _seen =  await LocalStorageService().fitchSeen();
       final truck =   await LocalStorageService().getTruckModel();

       print("test seen found: $_seen");
       print("test truck found: $truck");

       if(event is GetSplashEvent){
        yield SplashLoadingState();
       print(dataDB.length);
        if(dataDB.length == 0) {
          print("seen is false: $_seen");
          yield SplashSuccessState(goToTruckNumberPage: true, goToLoginPage: false);

        } else {
          print("seen is true: ${TruckNumberModel.fromJson(dataDB[0])}");
          LocalStorageService().setTruckModel(truckNumberModel: TruckNumberModel.fromJson(dataDB[0]));

          yield SplashSuccessState(goToLoginPage: true, goToTruckNumberPage: false);

        }
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}
