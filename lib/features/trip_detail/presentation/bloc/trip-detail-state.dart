import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/core/errors/base_error.dart';

class BaseTripState {}

class TripSuccessState extends BaseTripState {
  TripSuccessState();
}


class TripLoadingState extends BaseTripState {}

class TripInitLoading extends BaseTripState {}


class TripFailedState extends BaseTripState {
  final BaseError error;
  TripFailedState(this.error);
}