import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shhnatycemexdriver/core/services/local_storage/local_storage_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-bloc.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-events.dart';
import 'package:shhnatycemexdriver/features/notification/presentation/bloc/notifications-state.dart';
import 'package:firebase_core/firebase_core.dart';

//final FirebaseMessaging _fcm = new FirebaseMessaging();
final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//
///// Create a [AndroidNotificationChannel] for heads up notifications
//const AndroidNotificationChannel channel = AndroidNotificationChannel(
//  'high_importance_channel', // id
//  'High Importance Notifications', // title
//  'This channel is used for important notifications.', // description
//  importance: Importance.high,
//);


class PushNotificationService {
  static String fcmToken = '';
  //static NotificationBloc _bloc = NotificationBloc(BaseNotificationState());

  static Future<Null> init() async {
    print("enter");
//    await Firebase.initializeApp();
//    if(Platform.isIOS) {
//      _fcm.requestNotificationPermissions(IosNotificationSettings());
//    }
//    _fcm.autoInitEnabled().then((bool enabled) => print(enabled));
//    _fcm.setAutoInitEnabled(true);
    // Create an Android Notification Channel.
    /// default FCM channel to enable heads up notifications.
   // await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
//    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//      alert: true,
//      badge: true,
//      sound: true,
//    );
//    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
//    var initializationSettingsIOS = new IOSInitializationSettings();
//
//    var initializationSettings = new InitializationSettings(
//      android: initializationSettingsAndroid,
//      iOS: initializationSettingsIOS,
//    );

//    flutterLocalNotificationsPlugin.initialize(
//      initializationSettings,
//      onSelectNotification: onSelectNotification,
//    );
//    await configure();
   }

  static Future<Null> configure() async {

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message)
    {
      if (message != null) {
      //  Navigator.pushNamed(context, '/message', arguments: MessageArguments(message, true));
      }
    });

//    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//      RemoteNotification notification = message.notification as RemoteNotification;
//      AndroidNotification android = message.notification?.android as AndroidNotification;
//      if (notification != null && android != null) {
//          final title = notification.title;
//          final body = notification.body;
//          showNotification(title!, body!);
//
////        flutterLocalNotificationsPlugin.show(
////            notification.hashCode,
////            notification.title,
////            notification.body,
////            NotificationDetails(
////              android: AndroidNotificationDetails(
////                  'channel_ID', 'channel name', 'channel description',
////
////                  // TODO add a proper drawable resource to android, for now using
////                //      one that already exists in example app.
////                   icon: 'launch_background',
////                   importance: Importance.max,
////                  playSound: true,
////                  // sound: 'sound',
////                  showProgress: true,
////                  priority: Priority.high,
////                  ticker: 'test ticker')
////            )
////        );
//      }
//    });






//   await _fcm.configure(
//      /// called when app in foreground and received notification
//      onMessage: (Map<String, dynamic> message) async {
//        _bloc.add(GetAllNotificationEvent());
//
//        print("On Message: $message");
//        if (message['data'] != null) {
//          final data = message['data'];
//          final title = data['title'];
//          final body = data['body'];
//          showNotification( title, body);
//        }
//
//        if (message['notification'] != null) {
//          final data = message['notification'];
//          final title = data['title'];
//          final body = data['body'];
//          showNotification( title, body);
//        }
//      },
//      /// called when app in the background
//      onResume: (Map<String, dynamic> message) async {
//        print("On Resume: $message");
////        _serialiseAndNavigate(message);
//        if (message['data'] != null) {
//          final data = message['data'];
//          final title = data['title'];
//          final body = data['body'];
//          showNotification( title, body);
//        }
//
//        if (message['notification'] != null) {
//          final data = message['notification'];
//          final title = data['title'];
//          final body = data['body'];
//          showNotification( title, body);
//        }
//
//      },
//      /// called when app closed comlpetely
//      onLaunch: (Map<String, dynamic>message) async {
//        print("On Launch: $message");
////        _serialiseAndNavigate(message);
//        if (message['data'] != null) {
//          final data = message['data'];
//          final title = data['title'];
//          final body = data['body'];
//          showNotification( title, body);
//        }
//
//        if (message['notification'] != null) {
//          final data = message['notification'];
//          final title = data['title'];
//          final body = data['body'];
//          showNotification( title, body);
//        }
//
//      },
//     onBackgroundMessage: myBackgroundMessageHandler
//   );


  }
//  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//    if (message['data'] != null) {
//      final data = message['data'];
//      final title = data['title'];
//      final body = data['body'];
//      showNotification( title, body);
//    }

//    if (message['notification'] != null) {
//      final data = message['notification'];
//      final title = data['title'];
//      final body = data['body'];
//      showNotification( title, body);
//    }
//  }
  /// To verify things are working, check out the native platform logs.
//  static  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//    // If you're going to use other Firebase services in the background, such as Firestore,
//    print('Handling a background message ${message.messageId}');
//  }


//    static Future onSelectNotification(String payload) {
//    print("Mahdi: onSelectNotification");
//  }
  static getDeviceToken() async {
    String? deviceToken = await _fcm.getToken();
    print("deviceFirebase Token: $deviceToken");
    LocalStorageService().setToken(deviceToken!);
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
//    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: 'test');
  }


}