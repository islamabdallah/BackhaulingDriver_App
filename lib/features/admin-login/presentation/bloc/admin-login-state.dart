import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/core/errors/base_error.dart';

class BaseAdminLoginState {}

class AdminLoginSuccessState extends BaseAdminLoginState {
  AdminLoginSuccessState();
}

class AdminLoginLoadingState extends BaseAdminLoginState {}

class AdminLoginFailedState extends BaseAdminLoginState {
  final BaseError error;
  AdminLoginFailedState(this.error);
}