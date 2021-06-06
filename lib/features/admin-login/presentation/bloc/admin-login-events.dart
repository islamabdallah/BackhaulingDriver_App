// @dart=2.9
import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/features/admin-login/data/models/admin-user.dart';

class AdminLoginEvent extends BaseEvent {
  final AdminUserModel userModel;
  AdminLoginEvent({this.userModel});
}
