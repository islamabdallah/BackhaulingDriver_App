// @dart=2.9
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/errors/custom_error.dart';
import 'package:shhnatycemexdriver/core/flutter_datetime_picker.dart';
import 'package:shhnatycemexdriver/core/repositories/core_repository.dart';
import 'package:shhnatycemexdriver/core/results/result.dart';
import 'package:shhnatycemexdriver/core/models/empty_response_model.dart';
import 'package:shhnatycemexdriver/core/services/http_service/http_service.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/services/location_service/location_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';
import 'package:shhnatycemexdriver/features/trip_detail/data/models/trip.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';

class HomeRepositoryImplementation {
  final httpCall = HttpService();

  Future<Result<RemoteResultModel<String>>> logoutUser({String userId}) async {

    String truckNo =Uri.encodeFull(userId);
    final logOutUrl = logOut +'/'+ truckNo;
//    var test = 'http://105.198.228.83:90/api/driver/trucks/%D9%8A%20%D8%A8%20%D8%AC%205312';
    var testUrl = logOutUrl.split('%0D%0A').first;

    final response = await CoreRepository.request(url: testUrl, method: HttpMethod.GET,);
    if (response.hasDataOnly) {
      final res = response.data;
      final _data = RemoteResultModel<String>.fromJson(res);
      if (_data.flag) {
        return Result(data: _data);
      } else {
        return Result(error: CustomError(message: _data.message));
      }
    }
    if (response.hasErrorOnly) {
      return Result(error: response.error);
    }
  }
}
