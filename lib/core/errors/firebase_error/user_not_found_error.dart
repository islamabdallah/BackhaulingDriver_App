import 'package:shhnatycemexdriver/core/errors/firebase_error/firebase_error.dart';

class UserNotFoundError extends FirebaseError {
  UserNotFoundError() : super('User Not Found Error');
}
