import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';
import 'package:shhnatycemexdriver/features/trip_detail/presentation/pages/trip-detail.dart';
import 'package:auto_size_text/auto_size_text.dart';


class CardDetails extends StatelessWidget {
  final NotificationModel trip;
  final NotificationModel currentTrip;
  final String currentStatus;

  CardDetails(this.trip, this.currentTrip, this.currentStatus);

  @override
  Widget build(BuildContext context) {
    return displayCardDetail(context, trip, currentTrip, currentStatus);
  }
}



Widget displayCardDetail(context, NotificationModel trip , NotificationModel currentTrip, String currentStatus) {
  print('test:${currentTrip} ');
  return InkWell(
      child: Card(
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(width: 5.0,
                color:Color.fromRGBO(0, 145, 159 , 1.0)
                ),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                   children: <Widget>[
                     Expanded(
                         child: AutoSizeText(trip.customerName?? '', style: TextStyle(fontSize: 18),
                                minFontSize: 14,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                       flex: 2,
                     ),
                     Expanded(
                         flex: 1,
                         child:   AutoSizeText('(${trip.tripType ?? ''})', style: TextStyle(
                            fontFamily: FONT_FAMILY,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: (trip.tripType == 'Cemex') ? Colors.indigo :  Colors.red
                        ),
                      maxLines: 2,)
                     ),
                  ]
                  ),
                  subtitle:  Row(
                      children: <Widget>[
                      AutoSizeText( ' رقم :', style: TextStyle(
                        fontFamily: FONT_FAMILY,)),
                      SizedBox(width: 10.0,),
                      AutoSizeText('(${trip.shipmentId ?? ''})',
                          style: TextStyle(
                            fontFamily: FONT_FAMILY,
                            color: (trip.tripType == 'Cemex') ? Colors.indigo :  Colors.red
                        )
                    ),
                  ]),
                  trailing: (trip.view == true) ? (currentTrip != null ) ? Icon(Icons.visibility,color: Colors.green) : Icon(Icons.visibility) :  Icon(Icons.visibility_off),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                        Expanded(
                          child: Row (
                            children: [
                              Icon(Icons.gps_fixed, color: Theme.of(context).primaryColor,),
                              SizedBox(width: 10.0,),
                              Expanded(
                              child: AutoSizeText(trip.srcAddress ?? '',
                                  style: TextStyle(
                                  fontFamily: FONT_FAMILY,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54
                               ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ],
                          )
                    ),
                    ],
                  ),
                        Row(
        children: [
          Expanded(
              flex: 1,
              child: Row (
                children: [
                  Icon(Icons.pin_drop,
                    color:  Colors.green,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                child: AutoSizeText(trip.destAddress ?? '',
                  style: TextStyle(
                  fontFamily: FONT_FAMILY,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54
              ),
                 maxLines: 2,
                 overflow: TextOverflow.ellipsis,
          ),
            ),
                ]
              ),
        )
          ],
      ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Expanded(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText( ' تاريخ الاستلام',
                      style: TextStyle(
                        fontFamily: FONT_FAMILY,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,)
                  ),
                   AutoSizeText(trip.pickupDate?? '',
                      style: TextStyle(
                        fontFamily: FONT_FAMILY,
                        fontSize: 11.0,
                        color:Colors.black45,
                        fontWeight: FontWeight.w600,
                      )
                        )

                  ],
                  ),
                ),
                            Expanded(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                 AutoSizeText( ' تاريخ التوصيل',
                      style: TextStyle(
                        fontFamily: FONT_FAMILY,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,)
                  ),
                      AutoSizeText(trip.deliverDate?? '',
                      style: TextStyle(
                        fontFamily: FONT_FAMILY,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color:Colors.black45,)
                  )
                ]
                  ),
                ),
              ],
            ),
          ],
        ),


      ),
      ])
      )
      ),
    onTap: () {
        print('tttttttttttt${currentTrip?.requestId}, $currentStatus');
  if (currentTrip == null && currentStatus?.trim() == '0_Ideal' && trip.view == true) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TripDetail(trip: trip),),);
  } else {

  if (currentTrip?.shipmentId == trip.shipmentId) {

    if(currentTrip?.requestId == trip.requestId ) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TripDetail(trip: trip),));

    }  else if ((currentTrip?.requestId != trip.requestId) &&
        (currentStatus.trim() != '8_On_Destination' && currentStatus.trim() != '9_UnLoading')) {

      Navigator.push(context, MaterialPageRoute(builder: (context) => TripDetail(trip: trip),));
    }
  } else {
    showDialog( context: context, builder: (ctx) => AlertDialog(
      title: Center(
        child: AutoSizeText("تنبيه",style: TextStyle(
          fontFamily: FONT_FAMILY,
          color: Theme.of(context).primaryColor,
        )),
      ),
      content: AutoSizeText("لا يمكنك البدء لديك رحله أخري",style: TextStyle(fontFamily: FONT_FAMILY,)),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: AutoSizeText("اغلاق", style: TextStyle(
              fontFamily: FONT_FAMILY,
              color: Theme.of(context).primaryColor,))
        ),
      ],
    ),);
  }
  }
      }
  );
}
