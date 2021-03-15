import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/core/errors/base_error.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';
class BaseTruckState {}

class TruckSuccessState extends BaseTruckState {

  List<TruckNumberModel> truckNumberList;

  TruckSuccessState({this.truckNumberList});
}

class TruckLoadingState extends BaseTruckState {}

class TruckInitlLoading extends BaseTruckState {}


class TruckFailedState extends BaseTruckState {
  final BaseError error;
  TruckFailedState(this.error);
}

class TruckSaveState extends BaseTruckState {}
