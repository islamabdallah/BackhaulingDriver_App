import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/features/notification/data/models/notification-model.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoCard extends StatefulWidget {
  final NotificationModel trip;

  InfoCard(this.trip);

  @override
  _InfoCard createState() => _InfoCard();
}

class _InfoCard extends State<InfoCard> {

//  void _submitData() {
//    if (_amountController.text.isEmpty) {
//      return;
//    }
//    final enteredTitle = _titleController.text;
//    final enteredAmount = double.parse(_amountController.text);
//
//    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
//      return;
//    }
//
//    Navigator.of(context).pop();
//  }

  void  _launchCaller(phone) async {
    final url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
        borderOnForeground: true,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
                height: 70,
                padding: EdgeInsets.all(10.0),
                color: Theme.of(context).primaryColor,
                child: Center(
                    child: Text("${widget.trip.customerName} , requist: ${widget.trip.requestId}, ship:${widget.trip.shipmentId}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: FONT_FAMILY,
                            color: Colors.white,
                        )
                    )
                )
            ),
            Container(
          height: 40,
          padding: EdgeInsets.all(10.0),

          child: Center(
            child: Text('بيانات موقع الاستلام')
          )
        ),
            Container(
              height: 60,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text( widget.trip.srcContactName ?? '',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: FONT_FAMILY
                        )
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Row (
                      children: [
                        Icon(Icons.phone,
                          color: Colors.green,
                        ),
                        Text(
                          widget.trip.srcContactNumber?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => _launchCaller(widget.trip.srcContactNumber),
                  ),
                ],
              )
            ),
            Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text( widget.trip.destContactName ?? '',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: FONT_FAMILY
                          )
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Row (
                        children: [
                          Icon(Icons.phone,
                            color: Colors.green,
                          ),
                          Text(
                            widget.trip.destContactNumber?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => _launchCaller(widget.trip.destContactNumber),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
