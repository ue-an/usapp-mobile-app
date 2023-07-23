import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:usapp_mobile/2.0/providers2/activity_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/auth_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/directmessage_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/directmessagescontent_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/firstread_provider.dart';
import 'package:usapp_mobile/2.0/providers2/keep_alive_provider.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/otp_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/post_notif_provider.dart';
import 'package:usapp_mobile/2.0/providers2/report_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/request_provider.dart';
import 'package:usapp_mobile/2.0/providers2/search_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/sort_provider.dart';
import 'package:usapp_mobile/2.0/providers2/studentnumber_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/thread_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/threadmessage_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/threadreply_provider.dart';
import 'package:usapp_mobile/2.0/providers2/will_pop_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/authentication/splash_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/upload_image/upload_image_provider.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_provider.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/drawerpage_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/2.0/utils2/theme.dart';
import 'package:usapp_mobile/providers/login_provider.dart';
import 'package:usapp_mobile/providers/signup_provider.dart';
import 'package:usapp_mobile/providers/studnumber_provider.dart';
import 'package:usapp_mobile/providers/user_provider.dart';
import 'package:usapp_mobile/services/authentication/auth_service.dart';
import 'package:usapp_mobile/services/authentication/studnumber_repo.dart';
import 'package:usapp_mobile/services/authentication/user_service.dart';

class MyApp2 extends StatelessWidget {
  MyApp2({Key? key}) : super(key: key);

  final authService =
      AuthService(FirebaseAuth.instance, UserService(UserProvider()));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => AuthService(
                FirebaseAuth.instance, UserService(UserProvider()))),
        ChangeNotifierProvider<LoginProvider>(
            create: (_) => LoginProvider(authService: authService)),
        ChangeNotifierProvider<StudentnumberProvider>(
            create: (_) => StudentnumberProvider(StudnumberRepo())),
        ChangeNotifierProvider<SignupProvider>(
            create: (_) => SignupProvider(authService: authService)),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider2()),
        ChangeNotifierProvider(create: (_) => OtpProvider2()),
        ChangeNotifierProvider(create: (_) => StudentNumberProvider2()),
        ChangeNotifierProvider(create: (_) => ThemeProvider2()),
        ChangeNotifierProvider(create: (_) => SwipeProvider2()),
        ChangeNotifierProvider(create: (_) => DrawerPageProvider2()),
        ChangeNotifierProvider(create: (_) => UploadImageProvider()),
        //threads and messages
        ChangeNotifierProvider(create: (_) => ThreadProvider2()),
        ChangeNotifierProvider(create: (_) => LocalDataProvider2()),
        // ChangeNotifierProvider(create: (_) => NotFutureDetailsProvider2()),
        ChangeNotifierProvider(create: (_) => ThreadMessageProvider2()),
        //----------------
        ChangeNotifierProvider(create: (_) => DirectMessageProvider2()),
        ChangeNotifierProvider(create: (_) => DirectMessagesContentProvider2()),
        // ChangeNotifierProvider(create: (_) => PmDmProvider2()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => AdvDrawerController()),
        ChangeNotifierProvider(create: (_) => SearchProvider2()),
        ChangeNotifierProvider(create: (_) => RequestProvider2()),
        ChangeNotifierProvider(create: (_) => WillPopProvider2()),
        ChangeNotifierProvider(create: (_) => KeepAliveProvider2()),
        ChangeNotifierProvider(create: (_) => SortProvider()),
        ChangeNotifierProvider(create: (_) => ThreadReplyProvider()),
        ChangeNotifierProvider(create: (_) => FirstReadProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider2()),
        ChangeNotifierProvider(create: (_) => PostNotifProvider()),
      ],
      child: Consumer(
        builder: (context, ThemeProvider2 themeNotifier, child) {
          return OverlaySupport(
            child: MaterialApp(
              //v2.0
              theme: lightThemeData(context),
              darkTheme: darkThemeData(context),
              // themeMode: ThemeMode.light,
              themeMode:
                  themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
              scrollBehavior: MyCustomScrollBehavior(),
              //=============
              debugShowCheckedModeBanner: false,
              title: 'UsApp <testing mode>',
              routes: Routes2.routes2,
              home: const SplashScreen2(),
            ),
          );
        },
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
