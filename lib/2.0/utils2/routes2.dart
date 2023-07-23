import 'package:flutter/material.dart';
import 'package:usapp_mobile/2.0/screens2/authentication/create_acct_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/authentication/signup_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/authentication/splash_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/forgot_password_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/home_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/liked_threads_screen.dart';
// import 'package:usapp_mobile/2.0/screens2/authentication/validate_email_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/mypage2.dart';
import 'package:usapp_mobile/2.0/screens2/mythreads_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/profile_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/settings_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/start_page2.dart';
import 'package:usapp_mobile/2.0/screens2/threadroom_screen2.dart';

class Routes2 {
  Routes2._();

  static const String splashscreen2 = '/splashscreen2';
  static const String homepage2 = '/homepage2';
  static const String create2 = '/create2';
  // static const String validateEmail2 = '/validate-email2';
  static const String startpage2 = '/startpage2';
  static const String signup2 = '/signup2';
  // on drawer
  static const String settings2 = '/settings2';
  static const String homescreen2 = '/homescreen2';
  static const String profilescreen2 = '/profilescreen2';
  //threads and messages
  static const String threadroomscreen2 = '/threadroomscreen2';
  static const String forgotpassword2 = '/forgot-password2';
  static const String myThreadsscreen2 = '/mythreads-screen2';
  static const String likedThreadsscreen2 = '/likedthreads-screen2';

  static final routes2 = <String, WidgetBuilder>{
    splashscreen2: (context) => const SplashScreen2(),
    // homepage2: (context) => const MyPage2(),
    create2: (context) => const CreateAcctScreen2(),
    // validateEmail2: (context) => ValidateEmailScreen2(),
    signup2: (context) => const SignupScreen2(),
    startpage2: (context) => const StartPage2(),
    //on drawer
    settings2: (context) => const SettingsScreen2(),
    // homescreen2: (context) => const HomeScreen2(),
    profilescreen2: (context) => const ProfileScreen2(),
    // threadroomscreen2: (context) => ThreadRoomScreen2(),
    forgotpassword2: (context) => const ForgotPasswordScreen2(),
    myThreadsscreen2: (context) => const MyThreadsScreen2(),
    likedThreadsscreen2: (context) => const LikedThreadsScreen2(),
  };
}
