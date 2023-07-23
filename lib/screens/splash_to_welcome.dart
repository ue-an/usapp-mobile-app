import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usapp_mobile/main.dart';
import 'package:usapp_mobile/screens/splash_screen.dart';
import 'package:usapp_mobile/utils/startup_logic.dart';

class SplashToWelcome extends StatefulWidget {
  const SplashToWelcome({Key? key}) : super(key: key);

  @override
  _SplashToWelcomeState createState() => _SplashToWelcomeState();
}

class _SplashToWelcomeState extends State<SplashToWelcome> {
  @override
  void initState() {
    super.initState();
    loadScreen();
  }

  bool isLoading = true;

  void loadScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const SplashScreen() : const AuthWrapper();
  }
}
