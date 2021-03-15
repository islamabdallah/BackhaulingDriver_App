import 'package:shhnatycemexdriver/core/base_bloc/base_bloc.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';

class StartTripEvent extends BaseEvent {

 final NotificationModel trip;
  StartTripEvent({this.trip});
}
