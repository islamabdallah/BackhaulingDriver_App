// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/features/login/presentation/pages/login-page.dart';
import 'package:flutter/material.dart';
import 'package:shhnatycemexdriver/features/share/loading-dialog.dart';
import 'package:shhnatycemexdriver/features/truck_number/presentation/bloc/truck-number-bloc.dart';
import 'package:shhnatycemexdriver/features/truck_number/presentation/bloc/truck-number-event.dart';
import 'package:shhnatycemexdriver/features/truck_number/presentation/bloc/truck-number-state.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shhnatycemexdriver/features/truck_number/data/models/truck-number.dart';

class TruckNumberWidget extends StatefulWidget {

  static const routeName = 'TruckNumberWidget';

  TruckNumberWidgetState createState() => TruckNumberWidgetState();
}

class TruckNumberWidgetState extends State<TruckNumberWidget> {
  final TruckNumberBloc _bloc = TruckNumberBloc(BaseTruckState());
  TextEditingController truckIdController = TextEditingController();
  TruckNumberModel truckNumberModel;
  List<TruckNumberModel> listData = [];
  List<DropdownMenuItem> items = [];

  @override
  void initState() {
    _bloc.add(GetTruckNumberListEvent());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
        child:Container(
          height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(SHHNATY_BACK_GROUND), fit: BoxFit.cover),
        ),
        padding: EdgeInsets.only(right: 20.0,top: 100.0,left: 20.0,bottom: 20.0),
        child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
        Card(
        color: Colors.white,

      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
         // LogoWidget(width: 150.0,),
          SizedBox(height: 30.0,),
//          Container(
//            alignment: Alignment.topRight,
//            padding: EdgeInsets.only(right: 10.0,top: 20.0),
//            child: Text(
//              'قم بأختيار رقم العربيه',
//              style: new TextStyle(
//                fontSize: 20,
//                color: Colors.black,
//                fontFamily: FONT_FAMILY,
//              ),
//            ),
//          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: BlocConsumer(
                  bloc: _bloc,
                  builder: (context, state) {
                    return  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: getSearchableDropdown(),
                          )
                          ,
                          SizedBox(height: 30.0,),
                          Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Align(
                                    alignment: Alignment.topCenter,
                                    child: SizedBox(
                                      height: 50.0,
                                      width: MediaQuery.of(context).size.width,
                                      child:
                                      new RaisedButton(
                                        elevation: 5.0,
                                        color: Theme.of(context).primaryColor,
                                        child: new Text("تسجيل",
                                            style: new TextStyle(
                                                fontFamily: FONT_FAMILY,
                                                fontSize: 20.0,
                                                color: Colors.white,
                                            )
                                        ),
                                        onPressed: () {
                                          print(truckNumberModel);
                                          if(truckNumberModel == null) {
                                            return;
                                          }
                                          _bloc.add(SelectTruckNumberEvent(truckNumberModel));
                                          loadingAlertDialog(context);
                                        },
                                      ),
                                    )),
                              )),
                          SizedBox(height: 30.0,),
                          (state is TruckFailedState) ? Text('يوجد خطاء برجاء المحاوله مره ثانيه',style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: FONT_FAMILY)
                            ,) : Text(''),
//                          (state is TruckLoadingState ) ? Center( child:Row(
//                              children: [
//                                CircularProgressIndicator(),
//                                Container(margin: EdgeInsets.only(left: 5),child:Text("جاري تحميل البيانات" )),
//                              ],)) : Text(''),
                        ],


                      );
                  },
                  listener: (context, state) {
                    if(state is TruckSuccessState)
                    {
                      setState(() {
                        listData = state.truckNumberList;
                        listData.forEach((item) {
                          items.add(new DropdownMenuItem<TruckNumberModel>(child: Text(item.sapTruckNumber.toString()), value: item));
                        });
                      });
                    }
                    if (state is TruckLoadingState ) loadingAlertDialog(context);
                    if (state is TruckSuccessState) Navigator.of(context).pop();

                    if (state is TruckSaveState) {
                      Navigator.pop(context);
//                      Navigator.pushReplacementNamed(
//                          context, LoginWidget.routeName);
                      Navigator.of(context).pushNamedAndRemoveUntil(LoginWidget.routeName, (Route<dynamic> route) => false);
                    }

                  })
          ),
        ]
      )
    )
        ],
      )
      )
    )
      )
        );


  }

  Widget getSearchableDropdown() {
    return  SearchableDropdown(
      style: new TextStyle(
        fontSize: 20,
        color: Colors.black54,
        fontWeight: FontWeight.w400,
          fontFamily: FONT_FAMILY
      ),
      isExpanded: true,
      items: items,
      value: truckNumberModel,
      isCaseSensitiveSearch: false,
      closeButton: 'أغلاق',
      hint:  Text(
          'رقم العربيه'
              ,
        style: new TextStyle(
            fontSize: 20,
            color: Colors.black54,
            fontFamily: FONT_FAMILY
        ),
      ),
      onChanged: (value) {
        if (value != null ) {
          setState(() {
            truckNumberModel = new TruckNumberModel.fromJson(value.toJson());
          });
          print(truckNumberModel);
        }
      },

    );
  }
}
