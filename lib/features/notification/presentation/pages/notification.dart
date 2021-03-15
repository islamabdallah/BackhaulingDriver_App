import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-bloc.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-events.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-state.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/widgets/trip-card.dart';

class NotificationWidget extends StatefulWidget {
  NotificationWidgetState createState() => NotificationWidgetState();
}

class NotificationWidgetState extends State<NotificationWidget> {
  NotificationBloc _bloc = NotificationBloc(BaseNotificationState());
  LocalStorageService localStorage = LocalStorageService();
  List<NotificationModel> notificationList = [];
  NotificationModel currentTrip;
  String tripStatus;
  String shipmentId;
//  List<NotificationModel> notifications = [];

  getCurrentTrip() async {
      final currentTripDB = await DBHelper.getData('current_trip');
      final currentTruckDB = await DBHelper.getData('truck_status');
      setState(() {
        tripStatus = (currentTruckDB.length > 0) ? currentTruckDB[0]['tripStatus'] : '0_Ideal';
        shipmentId = (currentTruckDB.length > 0) ? currentTruckDB[0]['shipmentId'] : null;
        currentTrip = (currentTripDB.length > 0) ? NotificationModel.fromJson(
            currentTripDB[0]) : null;
      });
//      print('${currentTrip.shipmentId},here $tripStatus,azahar $shipmentId');
  }

  void initState() {
    super.initState();
    getCurrentTrip();

    Future.delayed(Duration(milliseconds: 500), () {
      _bloc.add(GetAllNotificationEvent());
    });
    setState(() {

    });

  }


  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        // start bloc
        child: BlocConsumer(
            cubit: _bloc,
            builder: (context, state) {
             return (notificationList.isNotEmpty) ? ListView.builder(
               itemBuilder: (ctx, index) {
                 final item = notificationList[index];
                 return CardDetails(item, currentTrip, tripStatus);
               } ,
               itemCount: notificationList.length ,

             )
                 :Column( children: <Widget>[
               SizedBox( height: 20,),
               Text( 'لا توجد بيانات الان',  style: Theme.of(context).textTheme.title,),
               SizedBox( height: 20,),
               Container( height: 300, child: SvgPicture.asset(
                 "assets/images/empty1.svg",
               )),
             ],
             );
               if (state is NotificationLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: Text('No Data Now'),
                );
              }
            },
            listener: (context, state) {
              if (state is NotificationSuccessState) {
                // @TODO:: here set the returned notification list
                List<NotificationModel> notifications = state.notificationsList;
                print(notifications);
                var foundIt;
                print(shipmentId);
                if(shipmentId != null) foundIt =  notifications.firstWhere((element) => element.shipmentId == shipmentId, orElse: () => null);
                print(foundIt);
                var items =  notifications.map((e){
                 print(foundIt);
                if(foundIt != null) {
                  (e.shipmentId == shipmentId) ? e.view = true : e.view = false;
                  print(e.toJson());
                } else {
                  e.view = true;
                }
                 return e;
               });

                setState(() {
                  notificationList = items.toList();
                  print(notificationList);
                  print(shipmentId);
                });
                 print('success ' + notificationList.length.toString());
              }
            })
        // end of bloc
        );
  }
}
