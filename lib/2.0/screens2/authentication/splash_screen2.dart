import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/screens2/intro_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/mypage2_1.dart';
import 'package:usapp_mobile/2.0/screens2/start_page2.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  var launchCount;
  var userStatus;
  Future checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userStatus = prefs.getString('userstatus');
      print("==On Load Check ==");
      print(userStatus);
    });
  }

  @override
  void initState() {
    super.initState();
    //set the initial value(0) for sharedprefs counter
    setValue();
    //Call check for landing page in init state of your home page widget
    checkUserStatus();
  }

  void setValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      launchCount = prefs.getInt('counter') ?? 0;
    });
    if (await launchCount == 0) {
      print("first launch"); //setState to refresh or move to some other page
      prefs.setInt('counter', 1);
      print(prefs.getInt('counter'));
    } else {
      print("Not first launch");
      print(prefs.getInt('counter'));
      // prefs.setInt('counter', 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return userStatus == null
        ? launchCount == 0
            ? const IntroScreen2()
            : StartPage2()
        // : MyPage2();
        : MyPage21();
  }
}
