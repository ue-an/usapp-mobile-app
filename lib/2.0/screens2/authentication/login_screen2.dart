import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/auth_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/studentnumber_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/will_pop_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_provider.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/drawerpage_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/models/student.dart';

class LoginScreen2 extends StatefulWidget {
  final Function onSignUpSelected;
  final Size size;
  const LoginScreen2(
      {Key? key, required this.onSignUpSelected, required this.size})
      : super(key: key);

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  bool _isObscure = true;
  FirestoreService2 firestoreService2 = FirestoreService2();
  late String _myEmail = '';
  late String _myCollege = '';
  late String _myFname = '';
  late String _myMinitial = '';
  late String _myLname = '';
  late int _myYearLvl = 0;
  late int _mySection = 0;
  late String _myYearSec = '';
  late String _myPhoto = '';
  late String _myStudentNumber = '';
  late String _myCourse = '';
  late String _myAbout = '';
  late String _myDeviceToken = '';
  late final FirebaseMessaging _firebaseMessaging;

  initFBMessaging() async {
    await Firebase.initializeApp();
    setState(() {
      _firebaseMessaging = FirebaseMessaging.instance;
    });
  }

  void _storeDetailsOnLocal() async {
    String? myEmail = await context.read<LocalDataProvider2>().getLocalEmail();
    String? myCollege =
        await context.read<LocalDataProvider2>().getLocalCollege();
    String? myCourse =
        await context.read<LocalDataProvider2>().getLocalCourse();
    String? myFname =
        await context.read<LocalDataProvider2>().getLocalFirstName();
    String? myMinitial =
        await context.read<LocalDataProvider2>().getLocalMinitial();
    String? myLname =
        await context.read<LocalDataProvider2>().getLocalLastName();
    int? myYearLvl =
        await context.read<LocalDataProvider2>().getLocalYearLevel();
    int? mySection = await context.read<LocalDataProvider2>().getLocalSection();
    String? myYearSec = myYearLvl!.toString() + '-' + mySection!.toString();
    String? myPhoto =
        await context.read<LocalDataProvider2>().getLocalStudentPhoto();
    String? myStudentNumber =
        await context.read<LocalDataProvider2>().getLocalStudentNumber();
    String? myAbout = await context.read<LocalDataProvider2>().getLocalAbout();
    String? myDeviceToken =
        await context.read<LocalDataProvider2>().getDeviceToken();
    //---------------------------------
    await context
        .read<LocalDataProvider2>()
        .storeLocalFullname(myFname!, myLname!);
    setState(() {
      _myEmail = myEmail!;
      _myCollege = myCollege!;
      _myCourse = myCourse!;
      _myFname = myFname;
      _myMinitial = myMinitial!;
      _myLname = myLname;
      _myYearLvl = myYearLvl;
      _mySection = mySection;
      _myYearSec = myYearSec;
      _myPhoto = myPhoto!;
      _myStudentNumber = myStudentNumber!;
      _myAbout = myAbout!;
      _myDeviceToken = myDeviceToken!;
    });

    print('login ' + _myFname);
    print('login ' + _myMinitial);
    print('login ' + _myLname);
    print('login ' + _myYearSec);
    print('login ' + _myPhoto);
    print('login ' + _myCollege);
    print('login ' + _myEmail);
    print('login ' + _myCourse);
    print('login ' + _myStudentNumber);
  }

  Widget _authScreen(BuildContext context, AuthProvider2 authProvider2) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: widget.size.height > 770
            ? 64
            : widget.size.height > 670
                ? 32
                : 16,
        horizontal: widget.size.width > 770
            ? 32
            : widget.size.width > 670
                ? 16
                : 8,
      ),
      child: Center(
        child: Card(
          elevation: 9,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: kPrimaryColor,
              width: 6,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: AnimatedContainer(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.white,
            ),
            duration: const Duration(milliseconds: 200),
            height: widget.size.height *
                (widget.size.height > 770
                    ? 0.6
                    : widget.size.height > 670
                        ? 0.7
                        : 0.8),
            width: 500,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "LOG IN",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 30,
                        child: const Divider(
                          color: kPrimaryColor,
                          thickness: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        onChanged: (value) =>
                            authProvider2.email = value.trim(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: const BorderSide(
                              color: kPrimaryColor,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: const BorderSide(
                              color: kPrimaryColor,
                              width: 2,
                            ),
                          ),
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: kPrimaryColor,
                          ),
                          prefixIcon: const Icon(
                            Icons.mail_outline,
                            color: kPrimaryColor,
                          ),
                        ),
                        cursorColor: kPrimaryColor,
                        style: const TextStyle(color: kPrimaryColor),
                        validator: (email) => email!.trim() != null &&
                                !EmailValidator.validate(email.trim())
                            ? 'Enter a valid email'
                            : null,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        onChanged: (value) => authProvider2.password = value,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: const BorderSide(
                              color: kPrimaryColor,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: const BorderSide(
                              color: kPrimaryColor,
                              width: 2,
                            ),
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: kPrimaryColor,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: kPrimaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: _isObscure
                                ? const Icon(
                                    Icons.visibility,
                                    color: kPrimaryColor,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: kPrimaryColor,
                                  ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        obscureText: _isObscure,
                        cursorColor: kPrimaryColor,
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(Routes2.forgotpassword2);
                        },
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Forgot password",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              // Icons.contact_support_outlined,
                              FontAwesomeIcons.question,
                              color: kPrimaryColor,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      GFButton(
                        onPressed: () async {
                          if (authProvider2.email != '' &&
                              authProvider2.password != '') {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                            Future.delayed(const Duration(milliseconds: 2000),
                                () async {
                              // await context
                              //     .read<AuthProvider2>()
                              //     .checkUserEnabled();
                              // if (context.read<AuthProvider2>().isEnabled ==
                              //     true) {
                              await authProvider2.logInAccount();
                              context
                                  .read<DrawerPageProvider2>()
                                  .changeDrawerPageSelected = 0;
                              print(context
                                  .read<DrawerPageProvider2>()
                                  .drawerPageSelected);
                              context
                                  .read<AdvDrawerController>()
                                  .advDrawerController
                                  .hideDrawer();
                              context.read<NotificationProvider>().ownerEmail =
                                  authProvider2.email;

                              if (authProvider2.isVerifiedAcct == true) {
                                print('verified');
                                await context
                                    .read<AuthProvider2>()
                                    .checkUserEnabled();
                                if (context.read<AuthProvider2>().isEnabled ==
                                    true) {
                                  var data =
                                      firestoreService2.getCurrentStudent();
                                  List<StudentNumber> studentDetails =
                                      await data.first;
                                  for (var student in studentDetails) {
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalCollege(student.college);
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalFirstName(student.firstName);
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalMinitial(student.mInitial);
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalLastName(student.lastName);
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalCourse(student.course);
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalEmail(student.email);
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalYearLevel(student.yearLvl);
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalSection(student.section);
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalStudentPhoto(
                                            student.photoUrl);
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalStudentNumber(
                                            student.studentNumber);
                                    context
                                        .read<LocalDataProvider2>()
                                        .storeLocalFullname(student.firstName,
                                            student.lastName);
                                    await context
                                        .read<LocalDataProvider2>()
                                        .storeLocalStudentAbout(student.about);
                                    //get new token

                                    //get device token
                                    await _firebaseMessaging
                                        .getToken()
                                        .then((val) async {
                                      FirestoreService2 firestoreService2 =
                                          FirestoreService2();
                                      print('Token: ' + val!);
                                      //local save token
                                      await context
                                          .read<LocalDataProvider2>()
                                          .storeDeviceToken(val);
                                      //token to firebase
                                      await firestoreService2.updateDeviceToken(
                                          studnum: student.studentNumber,
                                          deviceToken: val);
                                    });
                                    Navigator.of(context).pushReplacementNamed(
                                        Routes2.splashscreen2);
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Row(
                                          children: const [
                                            Icon(Icons.warning),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text('Access Denied'),
                                          ],
                                        ),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                  'Sorry, your account has been disabled. Unable to access the app.'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Close'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Row(
                                        children: const [
                                          Icon(Icons.warning),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text('Incorrect Input'),
                                        ],
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text('Wrong username or password'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            });
                          } else {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: const [
                                      Icon(
                                        Icons.warning,
                                        color: kPrimaryColor,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        'Invalid Input',
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: const <Widget>[
                                        Text('Please provide all fields'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        shape: GFButtonShape.pills,
                        fullWidthButton: true,
                        color: kPrimaryColor,
                        text: 'Log In',
                        size: GFSize.LARGE,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don\'t have an account?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.onSignUpSelected();
                              });
                            },
                            child: Row(
                              children: const [
                                Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: kPrimaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    initFBMessaging();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => context.read<WillPopProvider2>().onWillPop(context),
      child: Consumer<AuthProvider2>(
        builder: (context, authProvider, child) =>
            _authScreen(context, authProvider),
      ),
    );
  }
}
