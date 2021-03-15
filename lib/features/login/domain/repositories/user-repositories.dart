import 'package:shhnatycemexdriver/core/models/empty_response_model.dart';
import 'package:shhnatycemexdriver/core/results/result.dart';
import 'package:shhnatycemexdriver/features/login/data/models/user.dart';
// TODO: I comment this class , till the API is ready @Abeer

abstract class UserRepository {
  Future<Result<RemoteResultModel<String>>> loginUser(UserModel userModel);
}
