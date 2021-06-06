// @dart=2.9
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:shhnatycemexdriver/core/services/location_service/location_callback_handler.dart';
import 'package:shhnatycemexdriver/core/services/location_service/location_service_repository.dart';
import 'package:shhnatycemexdriver/core/ui/widgets/logo_widget.dart';
import 'package:shhnatycemexdriver/features/admin-login/data/models/admin-user.dart';
import 'package:shhnatycemexdriver/features/admin-login/presentation/bloc/admin-login-bloc.dart';
import 'package:shhnatycemexdriver/features/admin-login/presentation/bloc/admin-login-events.dart';
import 'package:shhnatycemexdriver/features/admin-login/presentation/bloc/admin-login-state.dart';
import 'package:shhnatycemexdriver/features/home/presentation/pages/home.dart';
import 'package:shhnatycemexdriver/features/login/data/models/user.dart';
import 'package:shhnatycemexdriver/features/login/presentation/bloc/login-bloc.dart';
import 'package:shhnatycemexdriver/features/login/presentation/bloc/login-events.dart';
import 'package:shhnatycemexdriver/features/login/presentation/bloc/login-state.dart';
import 'package:shhnatycemexdriver/features/share/loading-dialog.dart';
import 'package:shhnatycemexdriver/features/truck_number/presentation/pages/truck-number-page.dart';

class AdminLoginWidget extends StatefulWidget {
  static const routeName = 'AdminLoginWidget';

  AdminLoginWidgetState createState() =>  AdminLoginWidgetState();
}

class  AdminLoginWidgetState extends State< AdminLoginWidget> {
  AdminLoginBloc _bloc;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _userNameValidate = false;
  bool _passwordValidate = false;
  AdminUserModel user = new  AdminUserModel(UserName: '', Password: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _clicked = false;



  void _onStart() async {
//    if (await _checkLocationPermission()) {
//    _startLocator();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    print("Running:$_isRunning");

//    } else {
//      // show error
//    }
  }

  @override
  void initState() {
    _bloc =  AdminLoginBloc( BaseAdminLoginState());
    setState(() {
      _clicked = false;
    });
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
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(SHHNATY_BACK_GROUND),
                          fit: BoxFit.cover),
                    ),
                    padding: EdgeInsets.only(
                        right: 20.0, top: 130.0, left: 20.0, bottom: 20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                              color: Colors.white,
                              child: Column(children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),
                                SizedBox(height: 30.0),
                                BlocConsumer(
                                  bloc: _bloc,
                                    builder: (context, state) {

                                      if (state is LoginFailedState) {
                                        if (_clicked) {
                                          _clicked = false;
                                          Navigator.pop(context);
                                        }
                                      }
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 10, 15, 0),
                                              child: Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 0),

                                                        child: TextFormField(
                                                            controller: userNameController,
                                                            onChanged:
                                                                (value) => {
                                                              this.user?.UserName = userNameController
                                                                  .text
                                                                  .toString()
                                                            },
                                                            //  autofocus: true,
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontFamily: FONT_FAMILY,
                                                                decoration: TextDecoration.none),
                                                            decoration: new InputDecoration(

                                                              labelText: 'أسم المستخدم',

                                                              labelStyle: TextStyle(
//                                                                        color: Colors
//                                                                            .grey,
                                                                  fontFamily:
                                                                  FONT_FAMILY,
                                                                  fontSize:
                                                                  18.0),
//                                                                    hintStyle: TextStyle(
//                                                                        color: Colors
//                                                                            .grey,
//                                                                        fontFamily:
//                                                                            FONT_FAMILY,
//                                                                        fontSize:
//                                                                            18.0),
                                                              errorStyle:
                                                              TextStyle(
                                                                fontFamily:
                                                                FONT_FAMILY,
                                                                fontSize:
                                                                13.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                              ),
                                                            ),
                                                            validator: (text) {
                                                              if (text ==
                                                                  null ||
                                                                  text.isEmpty) {
                                                                return 'برجاء أدخال أسم المستخدم';
                                                              }
                                                              return null;
                                                            }
                                                        ),

                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 0),
                                                        child: TextFormField(
                                                            obscureText: true,
                                                            controller:
                                                            passwordController,
                                                            onChanged:
                                                                (value) => {
                                                              this.user?.Password = passwordController
                                                                  .text
                                                                  .toString()
                                                            },
                                                            //  autofocus: true,
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontFamily: FONT_FAMILY,
                                                                decoration: TextDecoration.none),
                                                            decoration: new InputDecoration(

                                                              labelText:'كلمه المرور',

                                                              labelStyle: TextStyle(
//                                                                        color: Colors
//                                                                            .grey,
                                                                  fontFamily:
                                                                  FONT_FAMILY,
                                                                  fontSize:
                                                                  18.0),
//                                                                    hintStyle: TextStyle(
//                                                                        color: Colors
//                                                                            .grey,
//                                                                        fontFamily:
//                                                                            FONT_FAMILY,
//                                                                        fontSize:
//                                                                            18.0),
                                                              errorStyle:
                                                              TextStyle(
                                                                fontFamily:
                                                                FONT_FAMILY,
                                                                fontSize:
                                                                13.0,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                              ),
                                                            ),
                                                            validator: (text) {
                                                              if (text ==
                                                                  null ||
                                                                  text.isEmpty) {
                                                                return 'برجاء قم بأدخال كلمه المرور ';
                                                              }
                                                              return null;
                                                            }
                                                        ),
                                                      ),
                                                      (state is LoginFailedState) ? Text('يوجد خطاء برجاء المحاوله مره ثانيه',style: TextStyle(
                                                          color: Theme.of(context).primaryColor,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: FONT_FAMILY)
                                                        ,) : Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 40, 0, 0),
                                                      ),
                                                      Center(
                                                          child: Padding(
                                                        padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            child: SizedBox(
                                                              height: 50.0,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child:
                                                                  new RaisedButton(
                                                                elevation: 5.0,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                child: new Text(
                                                                    "تسجيل",
                                                                    style: new TextStyle(
                                                                        fontFamily:
                                                                            FONT_FAMILY,
                                                                        fontSize:
                                                                            15.0,
                                                                        color: Colors
                                                                            .white)),
                                                                onPressed: () {
                                                                  if (!_formKey
                                                                      .currentState
                                                                      .validate()) {
                                                                    return;
                                                                  }
                                                                  if (_formKey
                                                                      .currentState
                                                                      .validate()) {
                                                                    // If the form is valid, display a Snackbar.
//                                                                    Scaffold.of(
//                                                                            context)
//                                                                        .showSnackBar(SnackBar(
//                                                                            content:
//                                                                                Text('Processing Data')));
//                                                                    print(this
//                                                                        .user
//                                                                        ?.UserName);
//                                                                    print(this
//                                                                        .user
//                                                                        ?.Password);
                                                                  setState(() {
                                                                    _clicked = true;
                                                                  });
                                                                    _bloc.add( AdminLoginEvent( userModel: this.user));
                                                                    loadingAlertDialog(context);
                                                                  }
                                                                  // Navigator.pushReplacementNamed(
                                                                  //     context, '/tabs',
                                                                  //     arguments: {"id": 0});
                                                                },
                                                              ),
                                                            )),
                                                      )),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 15, 0, 0),
                                                      ),
                                                      Center(
                                                          child: Text(
                                                        'للتسجيل باستخدام العلامه المائيه',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontFamily:
                                                                FONT_FAMILY,
                                                            fontSize: 18.0),
                                                      )),

                                                      SizedBox(height: 10.0),
                                                    ],
                                                  )),
                                            ),
                                          ]);
                                    },
                                    listener: (context, state) {
                                      if (state is LoginSuccessState) {
                                        this._onStart();
                                        Navigator.pop(context);
                                        Navigator.of(context).pushReplacementNamed(TruckNumberWidget.routeName);
                                      }


                                    })
                              ]))
                        ])))));
  }
}
