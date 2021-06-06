import 'package:shhnatycemexdriver/core/models/empty_response_model.dart';
import 'package:shhnatycemexdriver/core/results/result.dart';
import 'package:shhnatycemexdriver/features/admin-login/data/models/admin-user.dart';
// TODO: I comment this class , till the API is ready @Azhar

abstract class AdminUserRepository {
  Future<Result<RemoteResultModel<String>>> adminLoginUser(AdminUserModel userModel);
}
