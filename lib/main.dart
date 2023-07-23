import 'package:usapp_mobile/2.0/myapp2.dart';
import 'package:usapp_mobile/providers/signup_provider.dart';
import 'package:usapp_mobile/providers/studnumber_provider.dart';
import 'package:usapp_mobile/providers/user_provider.dart';
import 'package:usapp_mobile/screens/main/main_view.dart';
import 'package:usapp_mobile/screens/splash_to_welcome.dart';
import 'package:usapp_mobile/services/authentication/user_service.dart';
import 'package:usapp_mobile/providers/login_provider.dart';
import 'package:usapp_mobile/screens/welcome_screen.dart';
import 'package:usapp_mobile/services/authentication/auth_service.dart';
import 'package:usapp_mobile/services/authentication/studnumber_repo.dart';
import 'package:usapp_mobile/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp2());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UsApp',
        theme: ThemeData(
          // brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        routes: Routes.routes,
        // home: const AuthWrapper(),
        home: const SplashToWelcome(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    return StreamBuilder<User?>(
      stream: context.watch<AuthService>().authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          return const MainView();
          // return MainView2();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}
