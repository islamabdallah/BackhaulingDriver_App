import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/trip_detail/data/repositories/trip-details-repository-implementation.dart';
import 'package:shhnatycemexdriver/features/trip_detail/presentation/bloc/trip-detail-events.dart';
import 'package:shhnatycemexdriver/features/trip_detail/presentation/bloc/trip-detail-state.dart';


class TripDetailBloc extends Bloc<BaseEvent, BaseTripState> {
  TripDetailBloc(BaseTripState initialState) : super(initialState);

  @override
  Stream<BaseTripState> mapEventToState(BaseEvent event) async* {
    TripDetailRepositoryImplementation repo = new TripDetailRepositoryImplementation();
//    LocalStorageService localStorage = LocalStorageService();
    // TODO: implement mapEventToState
    if (event is StartTripEvent) {
      yield TripLoadingState();
      final res = await repo.updateTripStatus(trip: event.trip, status: '2_Start_Trip');
      if(res.hasErrorOnly) {
        yield TripFailedState(res.error);
      } else {
        /// Save Current Trip Data
         var dataTrip = event.trip.toJson();
          dataTrip.remove('view');
          DBHelper.insert('current_trip',dataTrip );
          DBHelper.update('truck_status', event.trip.shipmentId, 'shipmentId');

        /// check trip Type to change
        if(event.trip.tripType == 'Cemex')
          {
//            localStorage.setTripStatus(StatusType['4_On_Site']);
            DBHelper.update('truck_status', '4_On_Site', 'tripStatus');

        } else {
//            localStorage.setTripStatus(StatusType['3_On_Route_Source']);
            DBHelper.update('truck_status',StatusType['3_On_Route_Source'], 'tripStatus');

        }
        yield TripSuccessState();
      }
    }
  }
}
