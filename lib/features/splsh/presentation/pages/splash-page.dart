import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shhnatycemexdriver/core/constants.dart';
import 'package:shhnatycemexdriver/core/services/navigation_service/navigation_service.dart';
import 'package:shhnatycemexdriver/core/ui/styles/global_colors.dart';
import 'package:shhnatycemexdriver/features/login/presentation/pages/login-page.dart';
import 'package:flutter/material.dart';
import 'package:shhnatycemexdriver/features/splsh/presentation/bloc/splash-bloc.dart';
import 'package:shhnatycemexdriver/features/splsh/presentation/bloc/splash-event.dart';
import 'package:shhnatycemexdriver/features/splsh/presentation/bloc/splash-state.dart';
import 'package:shhnatycemexdriver/core/screen_utils/screen_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shhnatycemexdriver/features/truck_number/presentation/pages/truck-number-page.dart';
import 'logo_widget.dart';

class SplashWidget extends StatefulWidget {

  /// splash screen (1)
  static const routeName = 'SplashWidget';

  SplashWidgetState createState() => SplashWidgetState();
}

//new
class SplashWidgetState extends State<SplashWidget> {
  double _logoWidth = 90.0;
  SplashBloc _splashBloc = SplashBloc(BaseSplashState());
  @override
  void initState() {
    super.initState();
    _splashBloc.add(GetSplashEvent());
    Future.delayed(Duration(milliseconds: 100), () {
      _logoWidth = 40.0;
      setState(() {});
    });
  }
  @override
  void dispose() {
    _splashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, allowFontScaling: true);
    ScreensHelper(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
      DecoratedBox(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(SHHNATY_BACK_GROUND), fit: BoxFit.cover),
    ),
        child: Container(
          child: Center(
                child: AnimatedContainer(
                  width: ScreensHelper.fromWidth(_logoWidth),
                  height: ScreensHelper.fromHeight(60),
                  curve: Curves.bounceOut,
                  duration: Duration(milliseconds: 1000),
                  child: LogoWidget(),
                )
          //  child: LogoWidget(width: 90.00,),
          ),
        ),
      ),
          Positioned(
            width: ScreensHelper.width,
            height: ScreensHelper.fromHeight(0.5),
            bottom: ScreensHelper.fromHeight(4),
            child: BlocConsumer<SplashBloc, BaseSplashState>(
              cubit: _splashBloc,
              listener: (context, state) {
                if (state is SplashSuccessState) {
                  print('${state.goToLoginPage}, ${state.goToTruckNumberPage}');
                  if (state.goToLoginPage ) {
                    Navigator.pushReplacementNamed(context, LoginWidget.routeName);
                  }

                  if (state.goToTruckNumberPage) {
                    Navigator.pushReplacementNamed(context,TruckNumberWidget.routeName);
                  }
                }
              },
              builder: (context, state) {

                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreensHelper.fromWidth(33)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(ScreensHelper.fromWidth(10)),
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(GlobalColors.darkGreen),
                        )
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// end new
