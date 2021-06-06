// @dart=2.9
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
//import 'package:background_fetch/background_fetch.dart';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shhnatycemexdriver/features/home/presentation/pages/home.dart';
import 'package:shhnatycemexdriver/features/login/presentation/pages/login-page.dart';
import 'package:shhnatycemexdriver/features/admin-login/presentation/pages/admin-login-page.dart';
import 'package:shhnatycemexdriver/features/trip_detail/presentation/pages/trip-detail.dart';
import 'package:shhnatycemexdriver/features/truck_number/presentation/pages/truck-number-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'core/constants.dart';
import 'core/firebase/push_notification_service.dart';
import 'core/services/local_storage/local_storage_service.dart';
import 'core/services/location_service/location_callback_handler.dart';
import 'core/services/location_service/location_service.dart';
import 'core/services/location_service/location_service_repository.dart';
import 'features/splsh/presentation/pages/splash-page.dart';
import 'features/trip/presentation/pages/trip.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_update/in_app_update.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print('messagee ${message.notification.body}');
//  flutterLocalNotificationsPlugin.show(
//      message.data.hashCode,
//      message.notification.title,
//      message.notification.body,
//      NotificationDetails(
//        android: AndroidNotificationDetails(
//          channel.id,
//          channel.name,
//          channel.description,
//        ),
//      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  /// for main to be async
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(android: initialzationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
//  await PushNotificationService.getDeviceToken();
  getDeviceToken();
//   BackgroundLocator.unRegisterLocationUpdate();
  runApp(new MyApp());
}
 getDeviceToken() async {
  String deviceToken = await FirebaseMessaging.instance.getToken();
  print("deviceFirebase Token: $deviceToken");
  LocalStorageService().setToken(deviceToken);
  return deviceToken;
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ReceivePort port = ReceivePort();
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  // firebaseNotifications
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((_updateInfo) {
      print(_updateInfo);
      if ( _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((error) => print(error));
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }
  @override
  void initState() {
    super.initState();
    checkForUpdate();
    if (IsolateNameServer.lookupPortByName(LocationServiceRepository.isolateName) != null) {
      IsolateNameServer.removePortNameMapping(LocationServiceRepository.isolateName);
    }
    IsolateNameServer.registerPortWithName(port.sendPort, LocationServiceRepository.isolateName);
    print('Initializing...');
    port.listen((dynamic data) async {
//      await LocationServiceRepository().updateTrip(data);
      print(data);
    });
    initPlatformState();
    Wakelock.enable();
    const oneSec = const Duration(seconds:1800);
    new Timer.periodic(oneSec, checkChange);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('message foreground:${message.notification.body}');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
//                icon: android?.smallIcon,
              ),
            ));
      }
    });
//    FirebaseMessaging.onMessageOpenedApp.listen((event) {
//
//    });
  }


  void checkChange(Timer timer) async {
    final _isRunning = await BackgroundLocator.isServiceRunning();
    final res = await LocationService().updateTimerLoction();
    //do some network calls
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    print("permission : ${access}");
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      PermissionStatus permission = await LocationPermissions().requestPermissions(
        permissionLevel: LocationPermissionLevel.locationAlways,);
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
      await BackgroundLocator.initialize();
//    logStr = await FileManager.readLogFile();
    var checkPermissionStatus = await _checkLocationPermission();
      print('Initialization done');
    print('location Permission ${checkPermissionStatus}');
      if (checkPermissionStatus) {
        _startLocator();
      }
//    BackgroundLocator.unRegisterLocationUpdate();
      final _isRunning = await BackgroundLocator.isServiceRunning();
      print('Running ${_isRunning.toString()}');
  }

  void _startLocator() {
    Map<String, dynamic> data = {'countInit': 1};
    BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 300,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
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
          AdminLoginWidget.routeName: (context) => AdminLoginWidget(),
          HomeWidget.routeName: (context) => HomeWidget(),
          TripDetail.routeName: (context) => TripDetail(),
          TripWidget.routeName: (context) => TripWidget(), //map
        });
  }
}
