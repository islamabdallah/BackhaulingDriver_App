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
