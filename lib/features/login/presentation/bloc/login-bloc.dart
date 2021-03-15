import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/login/data/repositories/user-repositories-implementation.dart';
import 'package:shhnatycemexdriver/features/login/presentation/bloc/login-events.dart';
import 'package:shhnatycemexdriver/features/login/presentation/bloc/login-state.dart';

class LoginBloc extends Bloc<BaseEvent, BaseLoginState> {
  LoginBloc(BaseLoginState initialState) : super(initialState);

  @override
  Stream<BaseLoginState> mapEventToState(BaseEvent event) async* {
    // TODO: implement mapEventToState
    LoginRepositoryImplementation repo = new LoginRepositoryImplementation();
    LocalStorageService localStorage = LocalStorageService();

    if (event is LoginEvent) {
      yield LoginLoadingState();
      final res = await repo.loginUser(event.userModel);
      if (res.hasErrorOnly) {
        yield LoginFailedState(res.error);
      } else {
        /// Save Current Trip Data
//        final checkStatus = await localStorage.getTripStatus();
        final currentTruckDB = await DBHelper.getData('truck_status');
        final checkStatus = (currentTruckDB.length > 0) ? currentTruckDB[0]['tripStatus'] : null;
        print(checkStatus);
        if(checkStatus == null ) {
//          localStorage.setTripStatus(StatusType['0_Ideal']);
          DBHelper.update('truck_status', StatusType['0_Ideal'], 'tripStatus');

        }
        yield LoginSuccessState();
      }
    }
  }
}
