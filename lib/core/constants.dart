import 'package:flutter/material.dart';
import 'package:shhnatycemexdriver/core/screen_utils/screen_utils.dart';

const String TAG = 'azhar >>>>>>';
const APP_NAME = 'Shhnaty';
// URL
const String baseUrl = "http://20.86.97.165:90/api";
const String trunksUrl = baseUrl + "/trucks";
const String  postTruck = trunksUrl + "/assignToMobile";
const String allTrips = baseUrl +"/trips";
const String updateLocation = trunksUrl + '/update';
const String loginUrl = baseUrl + '/driver/login';
const String logOut = baseUrl + '/driver/trucks';


const FONT_FAMILY = 'DroidKufi';
const MAP_API_KEY = 'AIzaSyBVZcghBdxyoRcpEIJ69V5uOfn_nK2kKSY';
const KEY_FIRST_START = '${APP_NAME}KEY_FIRST_START';
const KEY_FIRE_BASE_TOKEN = '${APP_NAME}KEY_FIRE_BASE_TOKEN';
const KEY_CALENDAR_ID = '${APP_NAME}CALENDAR_ID';


// ignore: non_constant_identifier_names
final HORIZONTAL_PADDING = ScreensHelper.fromWidth(4.5);

const SESSION_STATUS_DRAFT = 'Draft';
const SESSION_STATUS_CONFIRMED = 'Draft';
const SESSION_STATUS_CANCELLED = 'Draft';
const SESSION_STATUS_PENDING = 'Pending';
const SHHNATY_BACK_GROUND = 'assets/bg.jpeg';
const SHHNATY_LOGO = 'assets/cemex.jpg';
const EDIT_MODE = 'edit';
const ADD_MODE = 'add';

const USER_TYPE_PT = 'PT';
const USER_TYPE_CLIENT = 'Client';

// ignore: non_constant_identifier_names
final double GENERAL_HORIZONTAL_PADDING = ScreensHelper.fromWidth(4.5);
// ignore: non_constant_identifier_names
final BorderRadius GLOBAL_BORDER_RADIUS =
    BorderRadius.circular(ScreensHelper.fromWidth(1.5));

const int MIN_PASSWORD_LENGTH = 6;
const int CODE_LENGTH = 5;

const Map<String, String> StatusType = {
    '0_Ideal': "0_Ideal",
    '1_Pending': "1_Pending",
    '2_Start_Trip':'2_Start_Trip',
    '3_On_Route_Source': "3_On_Route_Source",
    '4_On_Site': "4_On_Site",
    '5_Loading': "5_Loading",
    '6_On_Route_Dest': "6_On_Route_Dest",
    '7_Break': "7_Break",
    '8_On_Destination': "8_On_Destination",
    '9_UnLoading': "9_UnLoading",
    '10_Complete_Trip': "10_Complete_Trip",
    'Shipment':'شحنه',
    'Unit': 'وحده'
};

const List<Map<String, String>> TripStatus = [
    {'Key': '3_On_Route_Source','value': "فى الطريق لموقع التحميل"},
    {'Key': '4_On_Site','value': "موقع التحميل"},
    {'Key': '5_Loading','value': "تحميل"},
    {'Key': '6_On_Route_Dest','value': "فى الطريق لموقع التعتيق"},
    {'Key': '8_On_Destination','value': "موقع التعتيق"},
    {'Key': '9_UnLoading', 'value': "تعتيق"},
    {'Key': '10_Complete_Trip', 'value': "اكمال الرحلة"},
    {'Key': '0_Ideal','value': "Ideal"}
];
