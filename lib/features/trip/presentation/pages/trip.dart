import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:shhnatycemexdriver/core/sqllite/sqlite_api.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';
import 'package:shhnatycemexdriver/features/share/loading-dialog.dart';
import 'package:shhnatycemexdriver/features/trip_detail/data/repositories/trip-details-repository-implementation.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck_data.dart';
import 'package:url_launcher/url_launcher.dart';

import 'infoCard.dart';


class TripWidget extends StatefulWidget {
  static const routeName = 'TripWidget';

  TripWidgetState createState() => TripWidgetState();
}

class TripWidgetState extends State<TripWidget> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = LatLng(27.167928, 31.196732);
  LatLng _lastMapPosition =  LatLng(27.2134, 31.4456);
  MapType _currentMapType = MapType.normal;
  Position currentLocation;
  Map<String, String> _activeStatus = {"Key": '', "value": ""};
  Map<String, String> _deactiveStatus = {"Key": '', "value": ""};
  String _activeText = '';
  String _deactiveText = '';
  bool showActiveBtn = false;
  bool showDeactiveBtn = false;
  SharedPreferences prefs;
  LocalStorageService localStorage = LocalStorageService();
  NotificationModel trip;
  TripDetailRepositoryImplementation repo = new TripDetailRepositoryImplementation();
  int tripIndex = 0;
  bool _visible = false;
  bool _break = false;
  BitmapDescriptor icon;
  TrucKDataModel trucKData;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = MAP_API_KEY;


  // intialize the controller on Map Create
//  _onMapCreated(GoogleMapController controller) async {
//    _controller.complete(controller);
////    _location.onLocationChanged.listen((l) async {
////      final GoogleMapController controll = await _controller.future;
////      controll.animateCamera(
////        CameraUpdate.newCameraPosition(
////          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 11),
////        ),
////      );
////    });
//  }


  // Cargar imagen del Marker
//
//  Future <BitmapDescriptor> _createMarkerImageFromAsset(String iconPath) async {
//    ImageConfiguration configuration = ImageConfiguration();
//    icon = await BitmapDescriptor.fromAssetImage(
//        configuration,iconPath);
//    setState(() {
//      this.icon = icon;
//    });
//  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  void _toggleBreak() {
    final res =  repo.updateTripStatus(trip: trip, status: '7_Break');

    setState(() {
      _break = !_break;
    });
    var breakTrip = _break ? 1: 0;
    DBHelper.update('truck_status', breakTrip, 'tripBreak');
  }

// Update the position on CameraMove
  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
//    pointsLatLng.add(_lastMapPosition);
  }
//  _onMapTypeButtonPressed() {
//    setState(() {
//      _currentMapType = _currentMapType == MapType.normal
//          ? MapType.satellite
//          : MapType.normal;
//    });
//  }

//  _onAddMarkerButtonPressed() {
//    setState(() {
//      markers[MarkerId(_lastMapPosition.toString())]=
//        Marker(
//          markerId: MarkerId(_lastMapPosition.toString()),
//          position: _lastMapPosition,
//          infoWindow: InfoWindow(
//            title: 'This is a Title',
//            snippet: 'This is a snippet',
//          ),
//          icon: BitmapDescriptor.defaultMarker,
//        );
//    });
//  }

  void _openTripDetails(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: InfoCard(this.trip),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }
  getTripDetails() async {
//    var data = await localStorage.getCurrentTrip();
//    final currentTripDB = await DBHelper.getData('current_trip');
//    var data = (currentTripDB.length > 0) ? NotificationModel.fromJson(currentTripDB[0]) : null;
//    final currentTruckDB = await DBHelper.getData('truck_status');
//    var statusData = (currentTruckDB.length > 0) ? TrucKDataModel.fromJson(currentTruckDB[0]): null;
//    print(data);
//    print('${statusData.tripStatus},${statusData.tripBreak}');
//    setState(() {
//      trip = data;
//      trucKData =  statusData;
//      _break = trucKData?.tripBreak == 1 ? true : false;
//    });
    /// origin marker
    if(trip != null) {
      final bitmapDescriptorOrigin = await MarkerGenerator(120)
          .createBitmapDescriptorFromIconData(Icons.gps_fixed, Colors.red, Colors.transparent, Colors.transparent);
      final bitmapDescriptorDestination = await MarkerGenerator(120)
          .createBitmapDescriptorFromIconData(Icons.pin_drop, Colors.green, Colors.transparent, Colors.transparent);
      _addMarker(LatLng(double.parse(trip.srcLat), double.parse(trip.srcLong)), "origin", bitmapDescriptorOrigin);
      /// destination marker
      _addMarker(LatLng(double.parse(trip.destLat), double.parse(trip.destLong)), "destination", bitmapDescriptorDestination);
      _getPolyline();
    }
  }

  checkStatus({ Map<String, String> activeStatus,BuildContext context}) async {
//    String currentStatus = await localStorage.getTripStatus();
    final currentTruckDB = await DBHelper.getData('truck_status');
    String currentStatus = (currentTruckDB.length > 0) ? currentTruckDB[0]['tripStatus'] : null;
//     trucKData = (currentTruckDB.length > 0) ? TrucKDataModel.fromJson(currentTruckDB[0]): null;
//    String currentStatus = (trucKData != null) ? trucKData.tripStatus : null;
//     print('currentStatus$currentStatus');
    if(currentStatus == null) {
      setState(() {
        showActiveBtn = false;
        showDeactiveBtn = false;
      });
//      localStorage.setTripStatus('0_Ideal');
      DBHelper.update('truck_status', '0_Ideal', 'tripStatus');

      return;
    }


    if(activeStatus != null) {
      currentStatus = activeStatus['Key'];
    }
//    print("status :$currentStatus and $activeStatus");
    tripIndex = TripStatus.indexWhere((f) => f['Key'].trim() == currentStatus.trim());

    if(tripIndex > -1 && trip != null) {
      final res = await repo.updateTripStatus(trip: trip, status: TripStatus[tripIndex]['Key']);

      if (TripStatus[tripIndex]['Key'] == '0_Ideal' || TripStatus[tripIndex]['Key'] == '10_Complete_Trip')  {

        if(res.hasErrorOnly) {
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => AlertDialog(
                title: Center(
                  child: Text("تنبيه",style: TextStyle(
                    fontFamily: FONT_FAMILY,
                    color: Theme.of(context).primaryColor,
                  )),
                ),
                content:Text("لا يمكنك أتمام الرحله يوجد خطأ",style: TextStyle(fontFamily: FONT_FAMILY,)),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        },
                      child: Text("اغلاق", style: TextStyle(
                        fontFamily: FONT_FAMILY,
                        color: Theme.of(context).primaryColor,)
                      )
                  ),
                ],
              ),);
          return;
        }

          DBHelper.update('truck_status',  '0_Ideal', 'tripStatus');
          DBHelper.update('truck_status', null, 'requestId');
          DBHelper.delete('current_trip', trip.requestId);

        setState(() {
          markers.clear();
          polylines.clear();
          showActiveBtn = false;
          showDeactiveBtn = false;
          _visible = false;
        });
        Navigator.pop(context);
        return;
      }
      else {
        DBHelper.update('truck_status', TripStatus[tripIndex]['Key'], 'tripStatus');
       setState(() {
          _activeStatus = TripStatus[tripIndex];
          _activeText = _activeStatus["value"];
          showActiveBtn = true;
          if ((tripIndex + 1) < 7) {
            _deactiveStatus = TripStatus[tripIndex + 1];
            _deactiveText = _deactiveStatus["value"];
            showDeactiveBtn = true;
          }
          else {showDeactiveBtn = false;}
        });
        if(activeStatus != null) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  void initState() {
    getUserLocation();
    Future.delayed(Duration(milliseconds: 0)).then((_) async {
      final currentTripDB = await DBHelper.getData('current_trip');
      var data = (currentTripDB.length > 0) ? NotificationModel.fromJson(currentTripDB[0]) : null;
      final currentTruckDB = await DBHelper.getData('truck_status');
      var statusData = (currentTruckDB.length > 0) ? TrucKDataModel.fromJson(currentTruckDB[0]): null;
//      print(data);
//      print('${statusData.tripStatus},${statusData.tripBreak}');
      setState(() {
        trip = data;
        trucKData =  statusData;
        _break = trucKData?.tripBreak == 1 ? true : false;
        checkStatus();
        getTripDetails();
      });
    });
    super.initState();
  }
//  void _onMapCreated(GoogleMapController _cntlr)
//  {
//    _controller = _cntlr;
//    _location.onLocationChanged.listen((l) {
//      _controller.animateCamera(
//        CameraUpdate.newCameraPosition(
//          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
//        ),
//      );
//    });
//  }

  getUserLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    print(currentLocation);
    final bitmapDescriptorMe = await MarkerGenerator(120)
        .createBitmapDescriptorFromIconData(Icons.local_shipping, Colors.blue, Colors.transparent, Colors.transparent);

    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      markers[MarkerId(_center.toString())]=
          Marker(
              markerId: MarkerId(_center.toString()),
              position: _center,
              infoWindow: InfoWindow(
                title: 'موقعي',
              ),
              icon: bitmapDescriptorMe
          );
//      print('getUserLocation $currentLocation');
    });
//    print('center $_center');
  }
  _launchCaller(phone) async {
    final url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget button(Function function, IconData icon, String tag) {
    return FloatingActionButton(
      heroTag: tag,
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }
  Widget showDetailsBtn(context) {
    return FloatingActionButton(
      heroTag: 'setting',
      onPressed: () => _openTripDetails(context),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
    Icons.phone,
        size: 36.0,
      ),
    );
  }
  Widget activeButton() {
    return SizedBox(
      height: 50.0,
//      width: MediaQuery.of(context).size.width / 2,
      child: new RaisedButton(
        elevation: 5.0,
        color: Colors.lightGreen,
        child: new AutoSizeText(_activeText,
            style: new TextStyle(
                fontFamily: FONT_FAMILY, fontSize: 12.0, color: Colors.white),
          maxLines: 1,),
        onPressed: () async {
          // Navigator.pushReplacementNamed(context, '/tabs');
//          prefs = await SharedPreferences.getInstance();

        },
      ),
    );
  }
  Widget deactiveButton(ctx) {
    return SizedBox(
      height: 50.0,
//      width: MediaQuery.of(context).size.width / 2,
      child: new RaisedButton(
        elevation: 5.0,
        color: Color.fromRGBO(237, 237, 237, 1),
        child: new AutoSizeText(_deactiveText,
            style: new TextStyle(
            fontFamily: FONT_FAMILY, fontSize: 12.0, color: Colors.blue),
          maxLines: 1,
        ),
        onPressed: () {
          loadingAlertDialog(context);
          setState(() {
            checkStatus(activeStatus: _deactiveStatus,context: ctx);
          });
          },
      ),
    );
  }
  Widget callCard(String name, String tele, String text) {
    return  Card(
        elevation: 3,
        child: Container(
          color: Colors.black.withOpacity(0.70),
          height: 65.0,
//          padding: const EdgeInsets.all(2),
         child: ListTile(
            leading:  Icon(Icons.person_pin,size:50.0,  color: Colors.blue),
            title: Text( text,style: TextStyle(
                fontSize: 12,
                 fontWeight: FontWeight.w700,
                 fontFamily: FONT_FAMILY,
                 color: Colors.white
            )),
            subtitle: Text( name??'',style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: FONT_FAMILY,
                              color: Colors.white
                          ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
           isThreeLine: true,
           trailing: (tele != '' && tele != null)  ?  Icon(Icons.call, color: Colors.green, size: 30.0) : null,
           onTap: () {
             if(tele == null || tele == '') return;
                       _launchCaller(tele);
                       },
//           Expanded(flex: 1,child: FlatButton(
//                    textColor:  Colors.white,
//                    child: Row (
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: [
//                        Text(tele??'',style: TextStyle(
//                            fontSize: 16,
//                            fontWeight: FontWeight.w700,
//                            fontFamily: FONT_FAMILY,
//                            color: Colors.white
//                        )),
//                        Icon(Icons.call, color: Colors.green, size: 30.0) ,
//                      ]),
//                    onPressed: () {
//                      if(tele == null || tele == '') return;
//                       _launchCaller(tele);
//                    },
//                  ))

         ),
//          child: Row (
//
//              children: [
//                Expanded(flex: 1,
//                  child: Row (
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Icon(Icons.person_pin,size:50.0,  color: Colors.blue),
//                        Column(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: [
//                          Text( text,style: TextStyle(
//                              fontSize: 12,
//                              fontWeight: FontWeight.w700,
//                              fontFamily: FONT_FAMILY,
//                              color: Colors.white
//                          )),
//                          Text( name??'',style: TextStyle(
//                              fontSize: 10,
//                              fontWeight: FontWeight.w600,
//                              fontFamily: FONT_FAMILY,
//                              color: Colors.white
//                          )),
//                        ]),
//
//                      ]),
//                ),
//              if(tele != '' && tele != null)  Expanded(flex: 1,
//                  child: FlatButton(
//                    textColor:  Colors.white,
//                    child: Row (
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      children: [
//                        Text(tele??'',style: TextStyle(
//                            fontSize: 16,
//                            fontWeight: FontWeight.w700,
//                            fontFamily: FONT_FAMILY,
//                            color: Colors.white
//                        )),
//                        Icon(Icons.call, color: Colors.green, size: 30.0) ,
//                      ]),
//                    onPressed: () {
//                      if(tele == null || tele == '') return;
//                       _launchCaller(tele);
//                    },
//                  )
//                ),
//              ]
//          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
        body: Container(
//        child: Stack(
          child: Stack(
          children: <Widget>[
          Container(
//        child: Stack(
          child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 8.0,
              ),
              mapType: _currentMapType,
              onCameraMove: _onCameraMove,
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
            gestureRecognizers: Set()
              ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
              ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
              ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
              ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()))
              ..add(Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer())),
            )
          ),
          if (_break != true) Container(
              margin:  EdgeInsets.all(5.0),
              alignment: AlignmentDirectional.topCenter,
              height: 100,
                child: Card(
                      margin: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          if (showActiveBtn) Expanded( flex: 1, child: activeButton(),),
                          if (showDeactiveBtn) Expanded( child: deactiveButton(context), ),
                        ],

                      ),

                    )
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, top: 80.0, right: 16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                 if(_activeStatus['Key'] == '3_On_Route_Source' || _activeStatus['Key'] == '6_On_Route_Dest')   button(_toggleBreak, Icons.local_dining, 'map'),
                    SizedBox(height: 16.0,),
                   if (showDeactiveBtn)  button(_toggle, Icons.call, 'call'),
                    SizedBox( height: 16.0,),
                  ],
                ),
              ),
            ),
            Visibility (
                visible: _visible,
             child: Align(
                alignment: Alignment.bottomCenter,
               child: Container(
                 alignment: Alignment.bottomCenter,
                 height: 160.0,
                 child: Column(
                 children: <Widget>[
                 callCard(trip?.srcContactName, trip?.srcContactNumber, 'بيانات الأستلام'),
                 SizedBox(height: 4,),
                 callCard(trip?.destContactName, trip?.destContactNumber, 'بيانات التسليم'),
               ],
               ) ,
               )
               ),
             ),
            Visibility (
              visible: _break,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(4.0),
                    height: 260.0,
                    child: Card(
                      elevation: 5.0,
                      margin: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text('أستراحه ',style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: FONT_FAMILY,
                            color: Theme.of(context).primaryColor,
                          )),
                          Padding(padding: EdgeInsets.all(15.0),
                          child: Text('انت في استراحه الان لانهاء الاستراحه و تكمله الرحله اضغط علي انهاء.',style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: FONT_FAMILY
                          )),
                          ),
                          SizedBox(height: 15,),
                      SizedBox(
                        height: 50.0,
//      width: MediaQuery.of(context).size.width / 2,
                        child: new RaisedButton(
                          elevation: 5.0,
                          color:Theme.of(context).primaryColor,
                          child: new Text("أنهاء الاستراحه",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: FONT_FAMILY
                              )),
                          onPressed: _toggleBreak,
                        ),
                      )

                        ],
                      ),
                    ) ,
                  )
              ),
            )
          ],
        ),
      ),
    );

  }


  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates,width: 5);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(double.parse(trip.srcLat) , double.parse(trip.srcLong)),
        PointLatLng(double.parse(trip.destLat), double.parse(trip.destLong)),
        travelMode: TravelMode.driving,);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
class MarkerGenerator {
  final double _markerSize;
  double _circleStrokeWidth;
  double _circleOffset;
  double _outlineCircleWidth;
  double _fillCircleWidth;
  double _iconSize;
  double _iconOffset;

  MarkerGenerator(this._markerSize) {
    // calculate marker dimensions
    _circleStrokeWidth = _markerSize / 10.0;
    _circleOffset = _markerSize / 2;
    _outlineCircleWidth = _circleOffset - (_circleStrokeWidth / 2);
    _fillCircleWidth = _markerSize / 2;
    final outlineCircleInnerWidth = _markerSize - (2 * _circleStrokeWidth);
    _iconSize = sqrt(pow(outlineCircleInnerWidth, 2) / 2);
    final rectDiagonal = sqrt(2 * pow(_markerSize, 2));
    final circleDistanceToCorners = (rectDiagonal - outlineCircleInnerWidth) / 2;
    _iconOffset = sqrt(pow(circleDistanceToCorners, 2) / 2);
  }

  /// Creates a BitmapDescriptor from an IconData
  Future<BitmapDescriptor> createBitmapDescriptorFromIconData(
      IconData iconData, Color iconColor, Color circleColor, Color backgroundColor) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    _paintCircleFill(canvas, backgroundColor);
    _paintCircleStroke(canvas, circleColor);
    _paintIcon(canvas, iconColor, iconData);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(_markerSize.round(), _markerSize.round());
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  /// Paints the icon background
  void _paintCircleFill(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawCircle(Offset(_circleOffset, _circleOffset), _fillCircleWidth, paint);
  }

  /// Paints a circle around the icon
  void _paintCircleStroke(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = _circleStrokeWidth;
    canvas.drawCircle(Offset(_circleOffset, _circleOffset), _outlineCircleWidth, paint);
  }

  /// Paints the icon
  void _paintIcon(Canvas canvas, Color color, IconData iconData) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: _iconSize,
          fontFamily: iconData.fontFamily,
          color: color,
        ));
    textPainter.layout();
    textPainter.paint(canvas, Offset(_iconOffset, _iconOffset));
  }
}
