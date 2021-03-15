import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/core/errors/base_error.dart';

class BaseLoginState {}

class LoginSuccessState extends BaseLoginState {
  LoginSuccessState();
}

class LoginLoadingState extends BaseLoginState {}

class LoginFailedState extends BaseLoginState {
  final BaseError error;
  LoginFailedState(this.error);
}