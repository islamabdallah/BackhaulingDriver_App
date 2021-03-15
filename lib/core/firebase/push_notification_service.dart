import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-bloc.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-events.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-state.dart';

final FirebaseMessaging _fcm = new FirebaseMessaging();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

class PushNotificationService {
  static String fcmToken = '';
 static NotificationBloc _bloc = NotificationBloc(BaseNotificationState());

  static Future<Null>  init() async {
    print("enter");
    if(Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.autoInitEnabled().then((bool enabled) => print(enabled));
    _fcm.setAutoInitEnabled(true).then( (_) => _fcm.autoInitEnabled().then((bool enabled) => print(enabled)));
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
    await configure();
   }

  static Future<Null> configure() async {
   await _fcm.configure(
      /// called when app in foreground and received notification
      onMessage: (Map<String, dynamic> message) async {
        _bloc.add(GetAllNotificationEvent());

        print("On Message: $message");
        if (message['data'] != null) {
          final data = message['data'];
          final title = data['title'];
          final body = data['body'];
          showNotification( title, body);
        }

        if (message['notification'] != null) {
          final data = message['notification'];
          final title = data['title'];
          final body = data['body'];
          showNotification( title, body);
        }
      },
      /// called when app in the background
      onResume: (Map<String, dynamic> message) async {
        print("On Resume: $message");
//        _serialiseAndNavigate(message);
        if (message['data'] != null) {
          final data = message['data'];
          final title = data['title'];
          final body = data['body'];
          showNotification( title, body);
        }

        if (message['notification'] != null) {
          final data = message['notification'];
          final title = data['title'];
          final body = data['body'];
          showNotification( title, body);
        }

      },
      /// called when app closed comlpetely
      onLaunch: (Map<String, dynamic>message) async {
        print("On Launch: $message");
//        _serialiseAndNavigate(message);
        if (message['data'] != null) {
          final data = message['data'];
          final title = data['title'];
          final body = data['body'];
          showNotification( title, body);
        }

        if (message['notification'] != null) {
          final data = message['notification'];
          final title = data['title'];
          final body = data['body'];
          showNotification( title, body);
        }

      },
     onBackgroundMessage: myBackgroundMessageHandler
    );


  }
  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message['data'] != null) {
      final data = message['data'];
      final title = data['title'];
      final body = data['body'];
      showNotification( title, body);
    }

    if (message['notification'] != null) {
      final data = message['notification'];
      final title = data['title'];
      final body = data['body'];
      showNotification( title, body);
    }
  }
    static Future onSelectNotification(String payload) {
    print("Mahdi: onSelectNotification");
  }
  static getDeviceToken() async {
    String deviceToken = await _fcm.getToken();
    print("deviceFirebase Token: $deviceToken");
    LocalStorageService().setToken(deviceToken);
    return deviceToken;
  }
   static _serialiseAndNavigate(Map<String, dynamic>message) {
    var notificationData = message['data'];
    var view = notificationData['view'];
    if(view != null) {
      // navigate
    }

   }
  static showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  static Future<void> _demoNotification(String title, String body) async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        // sound: 'sound',
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: 'test');
  }


}