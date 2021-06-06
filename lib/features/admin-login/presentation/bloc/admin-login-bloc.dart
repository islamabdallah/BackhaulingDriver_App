// @dart=2.9
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/services/location_service/location_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/admin-login/data/repositories/admin-user-repositories-implementation.dart';
import 'admin-login-events.dart';
import 'admin-login-state.dart';

class AdminLoginBloc extends Bloc<BaseEvent, BaseAdminLoginState> {
  AdminLoginBloc(BaseAdminLoginState initialState) : super(initialState);

  @override
  Stream<BaseAdminLoginState> mapEventToState(BaseEvent event) async* {
    // TODO: implement mapEventToState
    AdminLoginRepositoryImplementation repo = new AdminLoginRepositoryImplementation();
    LocalStorageService localStorage = LocalStorageService();

    if (event is AdminLoginEvent) {
      yield AdminLoginLoadingState();
      final res = await repo.adminLoginUser(event.userModel);
      if (res.hasErrorOnly) {
        yield AdminLoginFailedState(res.error);
      } else {
        /// Save Current Trip Data
        final currentTruckDB = await DBHelper.getData('truck_status');
        final checkStatus = (currentTruckDB.length > 0) ? currentTruckDB[0]['tripStatus'] : null;
        print(checkStatus);

        if(checkStatus == null ) {
          DBHelper.update('truck_status', StatusType['0_Ideal'], 'tripStatus');

        }
        final res = await LocationService().updateTimerLoction();
        yield AdminLoginSuccessState();
      }
    }
  }
}
