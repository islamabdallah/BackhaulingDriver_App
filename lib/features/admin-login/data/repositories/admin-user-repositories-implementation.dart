// @dart=2.9
import 'dart:convert';

import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/errors/custom_error.dart';
import 'package:shhnatycemexdriver/core/repositories/core_repository.dart';
import 'package:shhnatycemexdriver/core/results/result.dart';
import 'package:shhnatycemexdriver/core/models/empty_response_model.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/features/admin-login/data/models/admin-user.dart';
import 'package:shhnatycemexdriver/core/services/http_service/http_service.dart';
import 'package:shhnatycemexdriver/features/admin-login/domain/repositories/admin-user-repositories.dart';

// TODO: I comment this class , till the API is ready @Abeer
class AdminLoginRepositoryImplementation implements AdminUserRepository {
  final  httpCall = HttpService();

  @override
  Future<Result<RemoteResultModel<String>>> adminLoginUser (AdminUserModel userModel) async {
    LocalStorageService localStorage = LocalStorageService();

    // TODO: implement LoginUser
    final response = await CoreRepository.request(url: loginUrl, method: HttpMethod.POST, converter: null, data: userModel.toJson());
    if (response.hasDataOnly) {
      print(response.data);
      final res = response.data;
      final _data = RemoteResultModel<String>.fromJson(res);
      if(_data.flag) {
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
