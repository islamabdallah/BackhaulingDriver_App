import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/core/errors/base_error.dart';

class BaseSplashState {}

class SplashSuccessState extends BaseSplashState {
  final bool goToTruckNumberPage;
  final bool goToLoginPage;

  SplashSuccessState({this.goToLoginPage = false, this.goToTruckNumberPage = false});
}

class SplashLoadingState extends BaseSplashState {}

class SplashInitlLoading extends BaseSplashState {}

class SplashFailedState extends BaseSplashState {
  final BaseError error;
  SplashFailedState(this.error);
}

