import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/features/login/data/models/user.dart';

class LoginEvent extends BaseEvent {
  final UserModel userModel;
  LoginEvent({this.userModel});
}
