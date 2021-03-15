import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shhnatycemexdriver/features/notification/data/repositories/notification-repositories-implementation.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-events.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-state.dart';

class NotificationBloc extends Bloc<BaseNotificationEvent, BaseNotificationState> {
  NotificationBloc(BaseNotificationState initialState) : super(initialState);
  @override
  Stream<BaseNotificationState> mapEventToState(BaseNotificationEvent event) async* {
    // TODO: implement mapEventToState
    NotificationRepositoryImplementation repo = new NotificationRepositoryImplementation();

    if (event is GetAllNotificationEvent) {
      yield NotificationLoadingState();
      final result = await repo.getAllNotifications();
      if(result.hasDataOnly){
        yield NotificationSuccessState(notificationsList: result.data);
      }else{
        yield NotificationFailedState(result.error);
      }
      /**
      *  @TODO:: here we need to calll get all notificatiion 
      repository instead of static array
      */
      // NotificationModel obj1 = new NotificationModel(
      //     title: 'Cemex Trip', subTitle: 'it is new Cemex Trip');
      // NotificationModel obj2 = new NotificationModel(
      //     title: 'Galaxy Trip', subTitle: 'it is new Galaxy Trip');

      // List<NotificationModel> arr = [obj1, obj2];
//      this.add(Yield(state.copyWith(notificationsList: [])));
    }
  }
}
