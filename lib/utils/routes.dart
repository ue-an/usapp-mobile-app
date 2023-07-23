import 'package:usapp_mobile/main.dart';
import 'package:usapp_mobile/screens/authentication/login_screen.dart';
import 'package:usapp_mobile/screens/authentication/signup_screen.dart';
import 'package:usapp_mobile/screens/authentication/studentnum_reg_screen.dart';
import 'package:usapp_mobile/screens/bottomnav/directmsg_screen.dart';
import 'package:usapp_mobile/screens/bottomnav/messages_screen.dart';
import 'package:usapp_mobile/screens/main/main_view.dart';
import 'package:usapp_mobile/screens/mainchats_screen.dart';
import 'package:usapp_mobile/screens/option_sreen.dart';
import 'package:usapp_mobile/screens/sidebar/about_screen.dart';
import 'package:usapp_mobile/screens/main/home_screen.dart';
import 'package:usapp_mobile/screens/sidebar/developers_screen.dart';
import 'package:usapp_mobile/screens/sidebar/invite_screen.dart';
import 'package:usapp_mobile/screens/sidebar/members_screen.dart';
import 'package:usapp_mobile/screens/sidebar/profile_screen.dart';
import 'package:usapp_mobile/screens/sidebar/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:usapp_mobile/screens/splash_screen.dart';
import 'package:usapp_mobile/screens/bottomnav/thread_screen.dart';

class Routes {
  Routes._();

  //authentication
  static const String signup = '/signup';
  static const String login = '/login';
  static const String authWrapper = '/authWwrapper';

  static const String splashScreen = '/splashScreen';
  static const String homeScreen = '/homeScreen';
  static const String profile = '/profile';
  static const String options = '/options';
  static const String studentReg = '/studentReg';
  static const String mainView = '/mainView';
  // static const String initialPage = '/';
  static const String threads = '/threads';
  static const String messages = '/messages';
  static const String notifications = '/notifications';
  static const String directmsg = '/directmessage';
  static const String mainchats = '/mainchats';

  //sidebar
  static const String about = '/about';
  static const String developers = '/developers';
  static const String invite = '/invite';
  static const String members = '/members';
  static const String settings = '/settings';

  static final routes = <String, WidgetBuilder>{
    signup: (BuildContext context) => const SignupScreen(),
    login: (BuildContext context) => const LoginScreen(),
    mainView: (BuildContext context) => const MainView(),
    homeScreen: (BuildContext context) => const HomeScreen(),
    profile: (BuildContext context) => const ProfileScreen(),
    about: (BuildContext context) => const AboutScreen(),
    developers: (BuildContext context) => const DevelopersScreen(),
    invite: (BuildContext context) => const InviteScreen(),
    members: (BuildContext context) => const MembersScreen(),
    settings: (BuildContext context) => const SettingsScreen(),
    options: (BuildContext context) => const OptionScreen(),
    studentReg: (BuildContext context) => const StudnumregScreen(),
    authWrapper: (BuildContext context) => const AuthWrapper(),
    splashScreen: (BuildContext context) => const SplashScreen(),
    // initialPage: (BuildContext context) => const SplashToWelcome(),
    threads: (BuildContext context) => const ThreadScreen(),
    messages: (BuildContext context) => const MessagesScreen(),
    directmsg: (BuildContext context) => const DirectMessage1(),
    mainchats: (BuildContext context) => const MainChats(),
  };
}
