// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/pages/notification.dart';
import 'package:shhnatycemexdriver/features/trip/presentation/pages/trip.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/features/login/presentation/pages/login-page.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';
import 'package:shhnatycemexdriver/features/home/data/repositories/home-repository-implementation.dart';

class HomeWidget extends StatefulWidget {
  static const routeName = 'HomeWidget';

  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  var selectedIndex = 0;
  LocalStorageService localStorage = LocalStorageService();
  HomeRepositoryImplementation repo = new HomeRepositoryImplementation();

  TruckNumberModel truck;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async{
   var truckn =   await localStorage.getTruckModel();
    setState(() {
      truck = truckn ;
    });
  }

  logOut(BuildContext context) {
    final res =  repo.logoutUser(userId: truck.truckNumber);
    localStorage.removeDriverID();
    DBHelper.update('truck_status', null, 'driverId');
    Navigator.pushReplacementNamed(context, LoginWidget.routeName);
  }

  @override
  Widget build(BuildContext context) {

    final Map<String, Object> rcvData = ModalRoute.of(context).settings.arguments;
    this.selectedIndex = rcvData['id'];
    return  DecoratedBox(
        decoration: BoxDecoration(
//        image:  new DecorationImage(
//        image: AssetImage(SHHNATY_BACK_GROUND), fit: BoxFit.cover,
//        )
    ),
    child: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
        initialIndex: selectedIndex,
        length: 2,
        child: Scaffold(
//          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
//              backgroundColor: Colors.indigo,
              title:  Row(children: [
              Text('????????????',style: new TextStyle(
              fontWeight: FontWeight.w500,
//            color: Colors.white,
              fontFamily: FONT_FAMILY,
              fontSize: 20,
            )),
                if(truck != null)   Text(' (${truck.truckNumber??''}) ',style: new TextStyle(
                  fontFamily: FONT_FAMILY,
                  fontSize: 11.0,
                )),
            ]),
            automaticallyImplyLeading: false,


            actions: <Widget>[
              FlatButton(
                textColor: Colors.white,
                onPressed: () => logOut(context),
                child: Text("????????",style: new TextStyle(
                    fontFamily: FONT_FAMILY,
                    fontSize: 20.0,
                  )),

                shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
              ),

            ],
            toolbarHeight: 100.0,
            elevation: 0,
            bottom:
//            PreferredSize(
//                child: Container(
//              //  padding: EdgeInsets.only(left: 10.0,right: 10.0),
//               color: Colors.white,
//                child:
                TabBar(
                  labelColor: Theme.of(context).primaryColor,
//                  indicatorColor: Colors.white,
//                  indicatorWeight: 10.0,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color:  Colors.white,
                  ),
                  tabs: [
                Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                          '????????????',
                          style: new TextStyle(
                            fontWeight: FontWeight.w600,
//                            color: Colors.white,
                            fontFamily: FONT_FAMILY,
                            fontSize: 18,
                          ),
                        )

                )
                ),
            Tab(   child: Align(
                alignment: Alignment.center,
                child:  Text(
                          '??????????',
                          style: new TextStyle(
                              fontWeight: FontWeight.w600,
//                            color: Colors.white,
                              fontFamily: FONT_FAMILY,
                              fontSize: 18,
                          ),
                        )
                    ),
            )

                  ],
                ),
          ),
//                preferredSize: Size.fromHeight(6.0)
//            ),
//          ),
          body: TabBarView(
            children: <Widget>[
              NotificationWidget(),
              TripWidget(),

            ],
          ),
          )
        )
    )
    );
  }
}

