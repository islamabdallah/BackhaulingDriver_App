import 'dart:isolate';
import 'dart:ui';
//import 'package:background_fetch/background_fetch.dart';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:easy_localization/easy_localization.dart';
//import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shhnatycemexdriver/features/home/presentation/pages/home.dart';
import 'package:shhnatycemexdriver/features/login/presentation/pages/login-page.dart';
import 'package:shhnatycemexdriver/features/trip_detail/presentation/pages/trip-detail.dart';
import 'package:shhnatycemexdriver/features/truck_number/presentation/pages/truck-number-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants.dart';
import 'core/firebase/push_notification_service.dart';
import 'core/services/location_service/location_callback_handler.dart';
import 'core/services/location_service/location_service_repository.dart';
import 'features/splsh/presentation/pages/splash-page.dart';
import 'features/trip/presentation/pages/trip.dart';

/// This "Headless Task" is run when app is terminated.
//void backgroundFetchHeadlessTask(String taskId) async {
//  print('[BackgroundFetch] Headless event received.');
//  BackgroundFetch.finish(taskId);
//}

void main() async {
  /// for main to be async
  WidgetsFlutterBinding.ensureInitialized();
  /// set Orientations to be portraitUp
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  /// set statusBarColor
  SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  /// init shared prefs
//  await appSharedPrefs.init();
  SharedPreferences.setMockInitialValues({});
  PushNotificationService.init();
  await PushNotificationService.getDeviceToken();

  // BackgroundLocator.unRegisterLocationUpdate();

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ReceivePort port = ReceivePort();
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  // firebaseNotifications
//Background
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];

  @override
  void initState() {
    super.initState();
    if (IsolateNameServer.lookupPortByName(LocationServiceRepository.isolateName) != null) {
      IsolateNameServer.removePortNameMapping(LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(port.sendPort, LocationServiceRepository.isolateName);

    port.listen((dynamic data) async {
//      await LocationServiceRepository().updateTrip(data);
      print(data);
      });
   initPlatformState();
  }
  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
        break;
      case PermissionStatus.granted:
        return true;
        break;
      default:
        return false;
        break;
    }
  }
  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
//    logStr = await FileManager.readLogFile();
    print('Initialization done');
    if (await _checkLocationPermission()) {
      _startLocator();
    }
    final _isRunning = await BackgroundLocator.isServiceRunning();
    print('Running ${_isRunning.toString()}');
  }

  void _startLocator() {
    Map<String, dynamic> data = {'countInit': 1};
    BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings( accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 1200,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIcon: '',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                LocationCallbackHandler.notificationCallback)));
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
        color: Colors.white,
        title: 'Cemex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
//          primarySwatch: Colors.red ,
          accentColor: Colors.blueAccent,
          textTheme: ThemeData.light().textTheme.copyWith(
            headline: TextStyle(
                fontFamily: FONT_FAMILY,
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),
            title: TextStyle(
              fontFamily: FONT_FAMILY,
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
            button: TextStyle(
              color: Colors.white,
            )
          ),
          // 31, 77, 87 fonts
          // 0, 145, 159 secondary
          // 228, 237, 240 background
          // 204, 223, 229 header
          primaryColor: Color.fromRGBO(241, 90, 33, 1.0),
          indicatorColor:Color.fromRGBO(241, 90, 33, 1.0),
          fontFamily: FONT_FAMILY,
          backgroundColor: Color.fromRGBO(228, 237, 240, 1.0),
        ),
        initialRoute: SplashWidget.routeName,
        // onGenerateRoute: gNavigationService.onGenerateRoute,
        // navigatorKey: gNavigationService.navigationKey,
        routes: {
          SplashWidget.routeName: (context) => SplashWidget(),
          TruckNumberWidget.routeName: (context) => TruckNumberWidget(),
          LoginWidget.routeName: (context) => LoginWidget(),
          HomeWidget.routeName: (context) => HomeWidget(),
          TripDetail.routeName: (context) => TripDetail(),
          TripWidget.routeName: (context) => TripWidget(), //map
        });
  }
}
