import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shhnatycemexdriver/features/login/data/repositories/user-repositories-implementation.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/repositories/truck-number-repositories-implementation.dart';
import 'package:shhnatycemexdriver/features/truck_number/presentation/bloc/truck-number-event.dart';
import 'package:shhnatycemexdriver/features/truck_number/presentation/bloc/truck-number-state.dart';
import 'package:shhnatycemexdriver/core/services/location_service/location_service.dart';

class TruckNumberBloc extends Bloc<BaseTruckEvent, BaseTruckState> {
  TruckNumberBloc(BaseTruckState initialState) : super(initialState);

  @override
  Stream<BaseTruckState> mapEventToState(BaseTruckEvent event) async* {
    // TODO: implement mapEventToState

  GetTruckNumberRepositoryImplementation repo = new GetTruckNumberRepositoryImplementation();

  if(event is GetTruckNumberListEvent){
  yield TruckLoadingState();

  final result = await repo.getAllAvailableTruck();

  if(result.hasDataOnly){
  yield TruckSuccessState(truckNumberList: result.data);
  }else{
  yield TruckFailedState(result.error);
  }

  } else if(event is SelectTruckNumberEvent) {
  yield TruckLoadingState();
  final res = await repo.registerTruckNumber(event.truckNumberModel);
  if(res.hasErrorOnly) {
  yield TruckFailedState(res.error);
  } else {
    final res = await LocationService().updateTimerLoction();
    yield TruckSaveState();
  }
  }
}
}

