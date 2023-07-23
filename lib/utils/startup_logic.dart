import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usapp_mobile/screens/main/main_view.dart';
import 'package:usapp_mobile/screens/welcome_screen.dart';

class StartupLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget getLandingPage(BuildContext ctx) {
    return StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (BuildContext ctx, snapshot) {
          if (snapshot.hasData) {
            return const MainView();
          }

          return const WelcomeScreen();
        });
  }
}
