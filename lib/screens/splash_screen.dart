import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        // child: FlutterLogo(size: MediaQuery.of(context).size.height));
        child: Center(
          child: Image.asset('assets/images/UsAppLogoNew.png'),
        ),
      ),
    );
  }
}
