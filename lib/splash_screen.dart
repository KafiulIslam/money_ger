import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:money_ger/routes/route_path.dart';
import 'package:money_ger/utils/app_storage.dart';
import 'package:money_ger/utils/assets_path.dart';
import 'package:money_ger/utils/color.dart';
import 'package:money_ger/views/auth/login/login_screen.dart';
import 'package:money_ger/views/dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //late Account account;

  @override
  void initState() {
    super.initState();
    //account = Account(client);
    _getIsFirst();
  }

  _getIsFirst() async {
    // bool isIntro = await PrefData.getIsIntro();
    // bool docCompleted = PrefData.getDocumentCompleted();
    // const bool isAccessToken = false;
    final String sessionId = await AppStorage.getSessionId() ?? '';

    Timer(const Duration(seconds: 1), () {
      if (sessionId != '') {
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (_) => DashboardScreen()));
        context.go(RouterPath.dashboard);
      } else {
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (_) => LoginScreen()));
        context.go(RouterPath.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 400), () {
      lightStatusBar();
    });
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Image.asset(
          splashLogo,
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width / 2,
        ),
      ),
    );
  }

  void lightStatusBar() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        // statusBarBrightness: Brightness.dark,
        // statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
