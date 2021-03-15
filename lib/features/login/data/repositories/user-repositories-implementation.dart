import 'dart:convert';

import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/errors/custom_error.dart';
import 'package:shhnatycemexdriver/core/repositories/core_repository.dart';
import 'package:shhnatycemexdriver/core/results/result.dart';
import 'package:shhnatycemexdriver/core/models/empty_response_model.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/login/data/models/user.dart';
import 'package:shhnatycemexdriver/features/login/domain/repositories/user-repositories.dart';
import 'package:shhnatycemexdriver/features/truck_number/domain/repositories/truck-number-repositories.dart';
import 'package:shhnatycemexdriver/core/services/http_service/http_service.dart';

// TODO: I comment this class , till the API is ready @Abeer
class LoginRepositoryImplementation implements UserRepository {
  final  httpCall = HttpService();

  @override
  Future<Result<RemoteResultModel<String>>> loginUser (UserModel userModel) async {
    LocalStorageService localStorage = LocalStorageService();

    // TODO: implement LoginUser
    final response = await CoreRepository.request(url: loginUrl, method: HttpMethod.POST, converter: null, data: userModel.toJson());
    if (response.hasDataOnly) {
      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<String>.fromJson(res);
      if (_data.flag) {
        localStorage.setDriverID(_data.data);
        DBHelper.update('truck_status', _data.data, 'driverId');
        return Result(data: _data);
      } else {
        return Result(error: CustomError(message: _data.message));
      }
    }
    if (response.hasErrorOnly) {
      return Result(error: response.error);
    }
   // return Result(data: EmptyResultModel());

  }
}
