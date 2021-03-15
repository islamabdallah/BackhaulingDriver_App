import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:shhnatycemexdriver/core/errors/base_error.dart';

abstract class BaseRemoteService {
  _handleErrors(Error error) {}

  Future<Either<BaseError, RESPONSE_MODEL>> firebaseRequest<RESPONSE_MODEL>(
      {Function0<Future<HttpsCallableResult>> callFunction}) async {
    final response = await callFunction();
    if (response != null) {}

    return null;
  }
}
