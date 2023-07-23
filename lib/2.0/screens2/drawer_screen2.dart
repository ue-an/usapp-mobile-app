import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/auth_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/directmessage_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/drawerpage_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/models/student.dart';

class DrawerScreen2 extends StatefulWidget {
  const DrawerScreen2({Key? key}) : super(key: key);
  @override
  _DrawerScreen2State createState() => _DrawerScreen2State();
}

class _DrawerScreen2State extends State<DrawerScreen2> {
  late String _myEmail = '';
  late String _myCollege = '';
  late String _myFname = '';
  late String _myMinitial = '';
  late String _myLname = '';
  late int _myYearLevel = 0;
  late int _mySection = 0;
  late String _myYearSec = '';
  late String _myPhoto = '';
  late String _myStudentNumber = '';
  late String _myCourse = '';
  late int _myCompletionYear = 0;

  _launchURL() async {
    const url = 'https://www.usapp-download.ga';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _getDetailsFromLocal() async {
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
    int myCompletionYear =
        await context.read<LocalDataProvider2>().getLocalCompletionYear();
    setState(() {
      _myEmail = myEmail!;
      _myCollege = myCollege!;
      _myCourse = myCourse!;
      _myFname = myFname!;
      _myMinitial = myMinitial!;
      _myLname = myLname!;
      _myYearLevel = myYearLvl;
      _mySection = mySection;
      _myYearSec = myYearSec;
      _myPhoto = myPhoto!;
      _myStudentNumber = myStudentNumber!;
      _myCompletionYear = myCompletionYear;
    });

    print('thissss ' + _myFname);
    print('thissss ' + _myMinitial);
    print('thissss ' + _myLname);
    print('thissss ' + _myYearSec);
    print('thissss ' + _myPhoto);
    print('thissss ' + _myCollege);
    print('thissss ' + _myEmail);
    print('thissss ' + _myCourse);
    print('thissss ' + _myStudentNumber);
  }

  @override
  void initState() {
    _getDetailsFromLocal();
    // setState(() {
    //   _isVisited = true;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Wraps the overall screen
    return Container(
      padding: EdgeInsets.only(top: size.height / 12, bottom: 70, left: 30),
      // Side drawer
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                FutureBuilder<String?>(
                  future:
                      context.read<LocalDataProvider2>().getLocalStudentPhoto(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<DrawerPageProvider2>()
                              .changeDrawerPageSelected = 5;
                          context
                              .read<AdvDrawerController>()
                              .advDrawerController
                              .hideDrawer();
                        },
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(60)),
                          child: Image.network(
                            snapshot.data!,
                            // _myPhoto,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return const Text('No image');
                    }
                  },
                ),
                FutureBuilder<String?>(
                  future: context.read<LocalDataProvider2>().getLocalFullName(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return const Text(
                        'No name',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder<String?>(
                  future: context
                      .read<LocalDataProvider2>()
                      .getLocalStudentNumber(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return const Text(
                        'No number',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder<int>(
                  future: context
                      .read<LocalDataProvider2>()
                      .getLocalCompletionYear(),
                  builder: (context, completeYearSnap) {
                    if (completeYearSnap.hasData) {
                      return FutureBuilder<String?>(
                        future:
                            context.read<LocalDataProvider2>().getLocalCourse(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return _myYearLevel > _myCompletionYear
                                ? const Text(
                                    'Alumnus',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    snapshot.data!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  );
                          } else {
                            return const Text(
                              'No course',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return const Text(
                        'No completion year',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder<int?>(
                  future:
                      context.read<LocalDataProvider2>().getLocalYearLevel(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _myYearLevel > _myCompletionYear
                          ? const Text('')
                          : Text(
                              _myYearSec,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            );
                    } else {
                      return const Text(
                        'No section',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          //===========================
          // Drawer items
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed(Routes2.homepage2);
                  context.read<DrawerPageProvider2>().changeDrawerPageSelected =
                      0;
                  print(context.read<DrawerPageProvider2>().drawerPageSelected);
                  context
                      .read<AdvDrawerController>()
                      .advDrawerController
                      .hideDrawer();
                },
                child: Row(
                  children: const [
                    Icon(
                      FontAwesomeIcons.home,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  context.read<DirectMessageProvider2>().changeSenderEmail =
                      _myEmail;
                  context.read<DirectMessageProvider2>().changeSenderName =
                      (_myFname + ' ' + _myLname);
                  context.read<DirectMessageProvider2>().changeSenderYearSec =
                      _myYearSec;
                  context.read<DirectMessageProvider2>().changeSenderPhotoUrl =
                      _myPhoto;
                  context.read<DirectMessageProvider2>().changeSenderID =
                      _myStudentNumber;
                  // Navigator.of(context).pushReplacementNamed(Routes2.homepage2);
                  context.read<DrawerPageProvider2>().changeDrawerPageSelected =
                      1;
                  print(context.read<DrawerPageProvider2>().drawerPageSelected);
                  context
                      .read<AdvDrawerController>()
                      .advDrawerController
                      .hideDrawer();
                },
                child: Row(
                  children: const [
                    Icon(
                      FontAwesomeIcons.userFriends,
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Members',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Navigator.of(context).pushReplacementNamed(Routes2.homepage2);
              //     // context.read<DrawerPageProvider2>().changeDrawerPageSelected =
              //     //     2;
              //     // print(context.read<DrawerPageProvider2>().drawerPageSelected);
              //     // context
              //     //     .read<AdvDrawerController>()
              //     //     .advDrawerController
              //     //     .hideDrawer();
              //   },
              //   child: Row(
              //     children: const [
              //       Icon(
              //         FontAwesomeIcons.landmark,
              //         size: 15,
              //         color: Colors.white,
              //       ),
              //       SizedBox(
              //         width: 12,
              //       ),
              //       Text(
              //         '????',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 16,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed(Routes2.homepage2);
                  context.read<DrawerPageProvider2>().changeDrawerPageSelected =
                      3;
                  print(context.read<DrawerPageProvider2>().drawerPageSelected);
                  context
                      .read<AdvDrawerController>()
                      .advDrawerController
                      .hideDrawer();
                },
                child: Row(
                  children: const [
                    Icon(
                      // FontAwesomeIcons.info,
                      FontAwesomeIcons.landmark,
                      size: 15,
                      // color: Theme.of(context).backgroundColor,
                      // color: kMiddleColor,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'About URS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed(Routes2.homepage2);
                  context.read<DrawerPageProvider2>().changeDrawerPageSelected =
                      4;
                  print(context.read<DrawerPageProvider2>().drawerPageSelected);
                  context
                      .read<AdvDrawerController>()
                      .advDrawerController
                      .hideDrawer();
                },
                child: Row(
                  children: const [
                    Icon(
                      FontAwesomeIcons.code,
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Developers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).pushReplacementNamed(Routes2.homepage2);
                  context.read<DrawerPageProvider2>().changeDrawerPageSelected =
                      6;
                  print(context.read<DrawerPageProvider2>().drawerPageSelected);
                  context
                      .read<AdvDrawerController>()
                      .advDrawerController
                      .hideDrawer();
                },
                child: Row(
                  children: const [
                    Icon(
                      FontAwesomeIcons.history,
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Activities',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  //go to about UsApp page
                  context.read<DrawerPageProvider2>().changeDrawerPageSelected =
                      2;
                  print(context.read<DrawerPageProvider2>().drawerPageSelected);
                  context
                      .read<AdvDrawerController>()
                      .advDrawerController
                      .hideDrawer();
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'About UsApp',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  _launchURL();
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.upgrade,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Update App',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //=================================================
          // Bottom of drawer
          Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes2.settings2);
                    },
                    child: const Text(
                      'Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 2,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextButton(
                      onPressed: () async {
                        SharedPreferences studentDetailsPrefs =
                            await SharedPreferences.getInstance();
                        studentDetailsPrefs.reload();
                        await studentDetailsPrefs.remove('localstud-fullname');
                        // context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalFullname('', '');
                        await studentDetailsPrefs.remove('localstud-firstname');
                        // await context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalFirstName('');
                        await studentDetailsPrefs.remove('localstud-minitial');
                        // await context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalMinitial('');
                        await studentDetailsPrefs.remove('localstud-lastname');
                        // await context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalLastName('');
                        await studentDetailsPrefs.remove('localstud-course');
                        // await context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalCourse('');
                        await studentDetailsPrefs.remove('localstud-college');
                        // await context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalCollege('');
                        await studentDetailsPrefs.remove('localstud-yearsec');
                        // await context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalYearSec('');
                        await studentDetailsPrefs.remove('localstud-email');
                        // await context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalEmail('');
                        await studentDetailsPrefs
                            .remove('localstud-studentNum');
                        // await context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalStudentNumber('');
                        await studentDetailsPrefs.remove('localstud-photo');
                        // await context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalStudentPhoto('');
                        await studentDetailsPrefs.remove('localstud-about');
                        // await context
                        //     .read<LocalDataProvider2>()
                        //     .storeLocalStudentAbout('');
                        // await studentDetailsPrefs.remove('completion-year');

                        await context.read<AuthProvider2>().signOutAccount();
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                        Future.delayed(Duration(milliseconds: 1000), () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes2.splashscreen2);
                        });
                      },
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/urs_logo-2.png',
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      Image.asset(
                        'assets/images/UsAppLogoWelcome.png',
                        height: 40,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  Container(),
                  const SizedBox(),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
