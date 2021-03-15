import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/errors/base_error.dart';
import 'package:shhnatycemexdriver/core/errors/firebase_error/email_already_in_use_error.dart';
import 'package:shhnatycemexdriver/core/errors/firebase_error/not_valid_email_error.dart';
import 'package:shhnatycemexdriver/core/errors/firebase_error/operation_not_allawed_error.dart';
import 'package:shhnatycemexdriver/core/errors/firebase_error/too_many_requests_error.dart';
import 'package:shhnatycemexdriver/core/errors/firebase_error/user_disabled_error.dart';
import 'package:shhnatycemexdriver/core/errors/firebase_error/user_not_found_error.dart';
import 'package:shhnatycemexdriver/core/errors/forbidden_error.dart';
import 'package:shhnatycemexdriver/core/errors/net_error.dart';
import 'package:shhnatycemexdriver/core/errors/unexpected_error.dart';

import '../errors/firebase_error/auth_error_const.dart';

class FirebaseProvider {
  static Future<Either<BaseError, RES>> getFirebaseResult<RES>({
    @required Function0<Future<RES>> request,
  }) async {
    try {
      return right(await request());
    } catch (e, s) {
      log('.........................FIREBASE ERROR ......................\n${e.toString()}\n..............................................................',
          name: TAG);

      print(s);
      return left(_handleFirebaseError(e.toString()));
    }
  }

  static BaseError _handleFirebaseError(String error) {
    if (error.contains(ERROR_INVALID_EMAIL)) {
      return NotValidEmailError();
    } else if (error.contains(ERROR_EMAIL_ALREADY_IN_USE)) {
      return EmailAlreadyInUseError();
    } else if (error.contains(ERROR_NETWORK_REQUEST_FAILED)) {
      return NetError();
    } else if (error.contains(ERROR_TOO_MANY_REQUESTS)) {
      return TooManyRequestError();
    } else if (error.contains(ERROR_OPERATION_NOT_ALLOWED)) {
      return OperationNotAllowedError();
    } else if (error.contains(ERROR_USER_DISABLED)) {
      return UserDisabledError();
    } else if (error.contains(ERROR_USER_NOT_FOUND)) {
      return UserNotFoundError();
    } else if (error.contains('403')) {
      return ForbiddenError();
    } else
      return UnExpectedError();
  }
}
