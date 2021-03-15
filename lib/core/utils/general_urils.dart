import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GeneralUtils{

  static Timestamp fromJsonToTimeStamp(datetime){
    bool isDateTime = !(datetime is Timestamp);
    print('datetimedatetimedatetime $datetime');

    return isDateTime? Timestamp.fromDate(DateTime.parse(datetime)): datetime;

  }


}