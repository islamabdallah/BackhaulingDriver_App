// @dart=2.9
import 'package:shhnatycemexdriver/core/errors/base_error.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';

//class NotificationSuccessState extends BaseSuccessState {
//  List<NotificationModel> notificationsList = [];
//  NotificationSuccessState({notificationsList});
//  NotificationSuccessState copyWith({notificationsList}) {
//    return NotificationSuccessState(
//        notificationsList: notificationsList ?? this.notificationsList);
//  }
//}

class BaseNotificationState {}

class NotificationSuccessState extends BaseNotificationState {

  List<NotificationModel> notificationsList;

  NotificationSuccessState({this.notificationsList});
}

class NotificationLoadingState extends BaseNotificationState {}

class NotificationInitlLoading extends BaseNotificationState {}


class NotificationFailedState extends BaseNotificationState {
  final BaseError error;
  NotificationFailedState(this.error);
}


