import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';
import 'package:shhnatycemexdriver/features/home/presentation/pages/home.dart';
import 'package:shhnatycemexdriver/features/share/loading-dialog.dart';
import 'package:shhnatycemexdriver/features/trip_detail/presentation/bloc/trip-detail-bloc.dart';
import 'package:shhnatycemexdriver/features/trip_detail/presentation/bloc/trip-detail-events.dart';
import 'package:shhnatycemexdriver/features/trip_detail/presentation/bloc/trip-detail-state.dart';
import 'package:url_launcher/url_launcher.dart';

class TripDetail extends StatefulWidget {
  final NotificationModel trip;
  static const routeName = 'TripDetailWidget';
  TripDetail({Key key, @required this.trip}) : super(key: key);
  TripDetailWidgetState createState() => TripDetailWidgetState();
}

class TripDetailWidgetState extends State<TripDetail> {
  TripDetailBloc _bloc;
  SharedPreferences prefs ;
  NotificationModel currentTrip;
//  LocalStorageService localStorage = LocalStorageService();
  String btnText = "أبدأ الرحله";
  String shipmentId;

  ref() async {
//    currentTrip = await localStorage.getCurrentTrip();
    final currentTripDB = await DBHelper.getData('current_trip');
    final currentTruckDB = await DBHelper.getData('truck_status');
    shipmentId = (currentTruckDB.length > 0) ? currentTruckDB[0]['shipmentId'] : null;
    currentTrip = (currentTripDB.length > 0) ? NotificationModel.fromJson(currentTripDB[0]) : null;
    setState(() {
      btnText =  (currentTrip?.requestId ==  widget.trip.requestId) ? "متابعه الرحله": "أبدأ الرحله";
    });
  }

  _launchCaller(phone) async {
    final url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  void initState() {
    super.initState();
    _bloc = TripDetailBloc(BaseTripState());
    setState(() {
      ref();
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('التفاصيل', style: TextStyle(
              color: Colors.white,
//              fontWeight: FontWeight.w400,
              fontFamily: FONT_FAMILY)
          ),
          centerTitle: true,
        ),
        body:Directionality(
        textDirection: TextDirection.rtl,
    child: SingleChildScrollView(

    child:Container(
    child: BlocConsumer(
            cubit: _bloc,
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide( //                   <--- left side
                              color: Colors.grey,
                              width: 1.0,
                            )
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                  child:
                                  Row (
                                    children: [
                                      Text(' العميل :',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: FONT_FAMILY
                                          )
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                  Expanded(
                                    child:  AutoSizeText(widget.trip.customerName ?? '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: FONT_FAMILY
                                          ),
                                        minFontSize: 12,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,)
                                    ,),
                                    ],
                                  ))
                          ),

                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide( //                   <--- left side
                              color: Colors.grey,
                              width: 1.0,
                            )
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide( //                   <--- left side
                                          color: Colors.grey,
                                          width: 1.0,
                                        )
                                    ),
                                  ),
                                  child:
                                  Row (
                                    children: [
                                      Text(' نوع الرحله :',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: FONT_FAMILY
                                          )
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(widget.trip.tripType ?? '',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: FONT_FAMILY
                                          )),
                                    ],
                                  ))
                          ),
                          Expanded(
                              flex: 2,
                              child:Container(
                                  padding: EdgeInsets.fromLTRB(0,0,10.0,0),
                                  child: Row (
                                      children: [
                                        Text ('رقم الرحله :',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: FONT_FAMILY
                                            )
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(widget.trip.shipmentId ?? '',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: FONT_FAMILY
                                            )),
                                      ]
                                  )
                              )
                          ),
                        ],
                      ),
                    ),
                    Container(

                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(5,0,0,0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide( //                   <--- left side
                                          color: Colors.grey,
                                          width: 1.0,
                                        )
                                    ),
                                  ),
                                  child:
                                  Row (
                                    children: [
                                      Text('الحموله :',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: FONT_FAMILY
                                          )
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text( StatusType[widget.trip.package] ?? '',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: FONT_FAMILY
                                          ))
                                    ],
                                  ))
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(5,0,10.0,0),
                                  child:
                                  Row (
                                    children: [
                                      Text('الكميه :',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: FONT_FAMILY
                                          )
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(widget.trip.capacity ?? '',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: FONT_FAMILY
                                          ))
                                    ],
                                  ))
                          ),
                        ],
                      ),
                    ),
                    if(widget.trip.package == 'Unit')  Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide( //                   <--- left side
                              color: Colors.grey,
                              width: 1.0,
                            )
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                  child:
                                  Row (
                                    children: [
                                      Text('نوع الوحده : ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: FONT_FAMILY
                                          )
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(widget.trip.unitType ?? '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: FONT_FAMILY
                                          ))
                                    ],
                                  ))
                          ),
                        ],
                      ),
                    ),
                    Container(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Column(
              children: <Widget>[
                Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Container( height: 20.0,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width:1.0, color:Colors.grey )
                          ),
                        ),
                      ),
                      Container(padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                          child: Text("بيانات الاستلام",style: TextStyle(color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            fontFamily: FONT_FAMILY
                          ),)
                          ,decoration:BoxDecoration(borderRadius:BorderRadius.circular(30.0) ,color: Theme.of(context).primaryColor,)
                      ),
                ]),
                Container(
                      child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child:  Row (
                                            children: [
                                              Text('الموقع :',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: FONT_FAMILY
                                                  )
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Expanded(
                                                child:  AutoSizeText(widget.trip.srcName ?? '',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: FONT_FAMILY
                                                  ),
                                                  minFontSize: 11,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,)
                                                ,),
                                            ],
                                          )
                                      ),
                                      /*2*/
                                      Container(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child:  Row (
                                          children: [
                                            Text('العنوان :',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: FONT_FAMILY
                                                )
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),

                                            Expanded(
                                              child:  AutoSizeText(widget.trip.srcAddress ?? '',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: FONT_FAMILY
                                                ),
                                                minFontSize: 11,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,)
                                              ,),
                                          ],
                                        )
                                      ),
                                      Container(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child:  Row (
                                            children: [
                                              Text('التاريخ :',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: FONT_FAMILY
                                                  )
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(widget.trip.pickupDate ?? '',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: FONT_FAMILY
                                                  )),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                      ),
                    ])
                    ),
                    Container(
//                        decoration: BoxDecoration(
//                          border: Border(
//                              bottom: BorderSide( //                   <--- left side
//                                color: Colors.grey,
//                                width: 1.0,
//                              )
//                          ),
//
//                        ),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                            children: <Widget>[
                              Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Container( height: 20.0,
                                      decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                width:1.0, color:Colors.grey )
                                        ),

                                      ),
                                    ),
                                    Container(padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
                                        child: Text("بيانات التوصيل",style: TextStyle(color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: FONT_FAMILY
                                        ),)
                                        ,decoration:BoxDecoration(borderRadius:BorderRadius.circular(30.0) ,color: Colors.lightGreen,)
                                    ),
                                  ]),
                              Container(

                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.only(bottom: 8),
                                                child:  Row (
                                                  children: [
                                                    Text('الموقع :',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: FONT_FAMILY
                                                        )
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),

                                                    Expanded(
                                                      child:  AutoSizeText(widget.trip.destName ?? '',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: FONT_FAMILY
                                                        ),
                                                        minFontSize: 11,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,)
                                                      ,),
                                                  ],
                                                )
                                            ),
                                            /*2*/
                                            Container(
                                                padding: const EdgeInsets.only(bottom: 8),
                                                child:  Row (
                                                  children: [
                                                    Text('العنوان :',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: FONT_FAMILY
                                                        )
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Expanded(
                                                      child:  AutoSizeText(widget.trip.destAddress ?? '',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: FONT_FAMILY
                                                        ),
                                                        minFontSize: 11,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,)
                                                      ,),
                                                  ],
                                                )
                                            ),
                                            Container(
                                                padding: const EdgeInsets.only(bottom: 8),
                                                child:  Row (
                                                  children: [
                                                    Text('التاريخ :',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: FONT_FAMILY
                                                        )
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Text(widget.trip.deliverDate ?? '',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: FONT_FAMILY
                                                        )),
                                                  ],
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ])
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomCenter,
              child:SizedBox(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width,

                        child: new RaisedButton(
                          elevation: 5.0,
                          color:Theme.of(context).primaryColor,
                          child:   Text(btnText,
                              style: new TextStyle(
                                color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: FONT_FAMILY
              )),
                          onPressed: () async {
                            loadingAlertDialog(context);
                            if (currentTrip == null && shipmentId !=  widget.trip.shipmentId) {
                              // display a Snackbar.
                               Scaffold.of(context).showSnackBar(SnackBar(content: Text('جاري أرسال البيانات')));
                              _bloc.add(StartTripEvent(trip: widget.trip));
                            }
                            else if(currentTrip == null && shipmentId ==  widget.trip.shipmentId) {
                              var dataTrip = widget.trip.toJson();
                              dataTrip.remove('view');
                              DBHelper.insert('current_trip',dataTrip );
                              if(widget.trip.tripStatus.trim() != "7_Break") DBHelper.update('truck_status', widget.trip.tripStatus, 'tripStatus');

//                              Navigator.pushReplacementNamed(context, HomeWidget.routeName,arguments: {"id": 1}) ;
                              Navigator.of(context).pushNamedAndRemoveUntil(HomeWidget.routeName, (Route<dynamic> route) => false, arguments: {"id": 1});

                            }
                            else if(currentTrip?.requestId ==  widget.trip.requestId) {
                              /// showed remove from here
//                              print(widget.trip.tripStatus);
                                var dataTrip = widget.trip.toJson();
                                    dataTrip.remove('view');
                                    DBHelper.insert('current_trip',dataTrip );
//                              print(widget.trip.tripStatus );
                              if(widget.trip.tripStatus.trim() != "7_Break") DBHelper.update('truck_status', widget.trip.tripStatus, 'tripStatus');

//                              Navigator.pushReplacementNamed(context, HomeWidget.routeName,arguments: {"id": 1}) ;
                              Navigator.of(context).pushNamedAndRemoveUntil(HomeWidget.routeName, (Route<dynamic> route) => false, arguments: {"id": 1});

                            }
                            else if( currentTrip?.requestId !=  widget.trip.requestId ) {
                              var dataTrip = widget.trip.toJson();
                              dataTrip.remove('view');
                              DBHelper.insert('current_trip',dataTrip );
                              if(widget.trip.tripStatus.trim() != "7_Break") DBHelper.update('truck_status', widget.trip.tripStatus, 'tripStatus');

//                                Navigator.pushReplacementNamed(context, HomeWidget.routeName,arguments: {"id": 1}) ;
                              Navigator.of(context).pushNamedAndRemoveUntil(HomeWidget.routeName, (Route<dynamic> route) => false, arguments: {"id": 1});

                               }
                            else {
                               Navigator.pop(context);
                               Scaffold.of(context).showSnackBar(SnackBar(content: Text('لا يمكنك البدء لديك رحله أخري')));
                            }
                            // Navigator.pushReplacementNamed(context, '/tabs');
                          },
                        ),
                      ),
                    )
                    )
                  ],
                ),
              );
            },
            listener: (context, state) {
              if (state is TripSuccessState) Navigator.of(context).pushNamedAndRemoveUntil(HomeWidget.routeName, (Route<dynamic> route) => false, arguments: {"id": 1});
//              Navigator.pushReplacementNamed(context, HomeWidget.routeName, arguments: {"id": 1});
              if (state is TripFailedState) Navigator.pop(context);
            }
            )
    )
    )
        )
    );
  }
}
