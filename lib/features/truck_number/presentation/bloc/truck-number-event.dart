import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';

class BaseTruckEvent{}

class GetTruckNumberListEvent extends BaseTruckEvent{}

class SelectTruckNumberEvent extends BaseTruckEvent {
  final TruckNumberModel truckNumberModel;
  SelectTruckNumberEvent(this.truckNumberModel);
}