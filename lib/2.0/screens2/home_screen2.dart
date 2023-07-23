import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/models/academic_year_dates.dart';
import 'package:usapp_mobile/2.0/models/chat.dart';
import 'package:usapp_mobile/2.0/models/course.dart';
import 'package:usapp_mobile/2.0/models/notification.dart';
import 'package:usapp_mobile/2.0/models/push_notification.dart';
import 'package:usapp_mobile/2.0/models/topicforum_screen.dart';
import 'package:usapp_mobile/2.0/models/user_chat.dart';
import 'package:usapp_mobile/2.0/providers2/activity_provider2.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/auth_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/directmessage_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/directmessagescontent_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/post_notif_provider.dart';
import 'package:usapp_mobile/2.0/providers2/report_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/search_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/sort_provider.dart';
import 'package:usapp_mobile/2.0/providers2/studentnumber_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/thread_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/threadreply_provider.dart';
import 'package:usapp_mobile/2.0/screens2/add_conversation.dart';
import 'package:usapp_mobile/2.0/screens2/bottomnav_notif_indicator/chat_badge.dart';
import 'package:usapp_mobile/2.0/screens2/bottomnav_notif_indicator/notification_badge.dart';
import 'package:usapp_mobile/2.0/screens2/directmessages_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/homescreen_component/empty_block.dart';
import 'package:usapp_mobile/2.0/screens2/homescreen_component/empty_block_pmdm.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_provider.dart';
import 'package:usapp_mobile/2.0/screens2/searched_thread_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/threadroom_screen2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/models/student.dart';
import 'package:usapp_mobile/models/thread.dart';
import 'package:timeago/timeago.dart' as timeago;
//

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen2 extends StatefulWidget {
  HomeScreen2({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>
    with AutomaticKeepAliveClientMixin<HomeScreen2> {
  @override
  bool get wantKeepAlive => true;
  int _selectedIndex = 0; //New
  FirestoreService2 firestoreService2 = FirestoreService2();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late Stream<List<Thread>> _streamThread;
  late Stream<List<UserChat>> _streamPDmPm;
  late Stream<List<UsappNotification>> _streamUsappNotifications;
  late Stream<List<UsappNotification>> _streamUsappNotifications2;
  late Stream<List<AcademicYearDates>> _streamAYDates;
  late Stream<List<StudentNumber>> _streamMembers;
  late Stream<List<Course>> _streamCourse;
  late String _myEmail = '';
  late String _myCollege = '';
  late String _myFname = '';
  late String _myMinitial = '';
  late String _myLname = '';
  late int _myYearLevel = 0;
  late int _mySection = 0;
  late int _myCompletionYear = 0;
  late String _myYearSec = '';
  late String _myPhoto = '';
  late String _myStudentNumber = '';
  late String _myCourse = '';
  late String _myAbout = '';
  late String _peerName = '';
  late String _peerPhoto = '';
  late String _peerSection = '';
  late String _myDeviceToken = '';
  late bool _isUpdated = true;
  late String _userStatus = '';
  //initial values
  int _increment = 0;
  bool isFetching = false;
  List<String> dataList = [];

  List<String> reasons = [
    'Cheating source',
    'Violent/Abusive words',
    'Sexual Harrassment'
  ];
  // List<String> years = [];
  String? option, reason;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
    String? myYearSec =
        myCourse! + ' ' + myYearLvl!.toString() + '-' + mySection!.toString();
    String? myPhoto =
        await context.read<LocalDataProvider2>().getLocalStudentPhoto();
    String? myStudentNumber =
        await context.read<LocalDataProvider2>().getLocalStudentNumber();
    String? myAbout = await context.read<LocalDataProvider2>().getLocalAbout();
    String? myDeviceToken =
        await context.read<LocalDataProvider2>().getDeviceToken();
    bool isUpdated =
        await context.read<LocalDataProvider2>().getLocalUpdatedStatus();
    String userStatus =
        await context.read<LocalDataProvider2>().getLocalUserStatus();
    int myCompletionYear =
        await context.read<LocalDataProvider2>().getLocalCompletionYear();
    //---------------------------------
    await context
        .read<LocalDataProvider2>()
        .storeLocalFullname(myFname!, myLname!);
    setState(() {
      _myEmail = myEmail!;
      _myCollege = myCollege!;
      _myCourse = myCourse;
      _myFname = myFname;
      _myMinitial = myMinitial!;
      _myLname = myLname;
      _myYearLevel = myYearLvl;
      _mySection = mySection;
      _myYearSec = myYearSec;
      _myPhoto = myPhoto!;
      _myStudentNumber = myStudentNumber!;
      _myAbout = myAbout!;
      _myDeviceToken = myDeviceToken!;
      _isUpdated = isUpdated;
      _userStatus = userStatus;
      timeago.setLocaleMessages('en', timeago.EnMessages());
      timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
    });

    print('thissss token: ' + _myDeviceToken);
    print('thissss update status: ' + _isUpdated.toString());
  }

  checkForInitialMessage() async {
    int newVal = _increment += 1;
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification!.title,
        body: initialMessage.notification!.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
      context.read<NotificationProvider>().pushNotification = notification;
    }
  }

  @override
  void initState() {
    //notif when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      int newVal = _increment += 1;
      PushNotification notification = PushNotification(
        title: message.notification!.title,
        body: message.notification!.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
      context.read<NotificationProvider>().pushNotification = notification;
    });
    //normal notification
    context.read<NotificationProvider>().registerNotification();
    //when app is terminated
    checkForInitialMessage();
    //initialize deviceToken in provider
    context.read<NotificationProvider>().deviceToken = _myDeviceToken;
    _storeDetailsOnLocal();
    _streamPDmPm = firestoreService2.getLastColl();
    _streamThread = firestoreService2.fetchThreads();
    _streamUsappNotifications = firestoreService2.getUsappNotifications();
    _streamUsappNotifications2 = firestoreService2.getUsappNotifications();
    _streamAYDates = firestoreService2.getAcademicYearDates();
    _streamCourse = firestoreService2.getCourses();
    _streamMembers = firestoreService2.fetchMembers();
    print('NOTIFFF ' + context.read<NotificationProvider>().ownerEmail);

    _peerName = '';
    _peerPhoto = '';
    _peerSection = '';

    context.read<NotificationProvider>().changeIsNotifClicked = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();
    List<Widget> _pages = <Widget>[
      //FIRST SCREEN: FORUMS
      StreamBuilder<List<Course>>(
          stream: _streamCourse,
          builder: (context, courseSnap) {
            if (courseSnap.hasData) {
              late int myCourseCompletionYear = 0;

              courseSnap.data!.forEach((course) async {
                if (course.courseName ==
                    await context.read<LocalDataProvider2>().getLocalCourse()) {
                  myCourseCompletionYear = course.years;
                  print('my completion year: ' + course.years.toString());
                  // print(await context
                  //     .read<LocalDataProvider2>()
                  //     .getLocalCompletionYear());
                }
              });

              return StreamBuilder<List<AcademicYearDates>>(
                  stream: _streamAYDates,
                  builder: (context, ayDateSnap) {
                    if (ayDateSnap.hasData) {
                      AcademicYearDates acadDates = ayDateSnap.data![0];
                      //get acaddate 'date' only (w/o time) of AY start
                      String ayStartDateOnly = DateFormat("yyyy-MM-dd")
                          .format(acadDates.ayStart.toDate());
                      //get acaddate 'date' only (w/o time) of AY end
                      String ayEndDateOnly = DateFormat("yyyy-MM-dd")
                          .format(acadDates.ayEnd.toDate());
                      //get date now (w/o time)
                      String dateNowOnly =
                          DateFormat("yyyy-MM-dd").format(DateTime.now());
                      print('now: ' + dateNowOnly);
                      print('start AY: ' + ayStartDateOnly);
                      print('end AY: ' + ayEndDateOnly);

                      if ((dateNowOnly == ayStartDateOnly &&
                              _isUpdated == false) &&
                          _userStatus != '') {
                        //updated status = true
                        context
                            .read<StudentNumberProvider2>()
                            .updateLocalUpdatedStatusAYSTART();
                        (() async {
                          if (_myYearLevel <= (myCourseCompletionYear + 1)) {
                            //yearlevel++
                            await context
                                .read<StudentNumberProvider2>()
                                .updateYearLevel();

                            _handleMenuButtonPressed();

                            await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListBody(
                                              children: <Widget>[
                                                Row(
                                                  children: const [
                                                    Icon(
                                                      FontAwesomeIcons
                                                          .exclamationCircle,
                                                      color: kPrimaryColor,
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text(
                                                        'Student Details Update'),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 21,
                                                ),
                                                Row(
                                                  children: const [
                                                    Expanded(
                                                      child: Text(
                                                        'New Academic Year has officially started.\nWe are expecting you have already enrolled this semester. \n\nPlease logout then login again for your new details to reflect.',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: RaisedButton(
                                                    color: kPrimaryColor,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    2.0))),
                                                    child: const Text(
                                                      "Log out",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      SharedPreferences
                                                          studentDetailsPrefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      studentDetailsPrefs
                                                          .reload();
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-fullname');
                                                      // context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalFullname('', '');
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-firstname');
                                                      // await context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalFirstName('');
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-minitial');
                                                      // await context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalMinitial('');
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-lastname');
                                                      // await context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalLastName('');
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-course');
                                                      // await context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalCourse('');
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-college');
                                                      // await context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalCollege('');
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-yearsec');
                                                      // await context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalYearSec('');
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-email');
                                                      // await context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalEmail('');
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-studentNum');
                                                      // await context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalStudentNumber('');
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-photo');
                                                      // await context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalStudentPhoto('');
                                                      await studentDetailsPrefs
                                                          .remove(
                                                              'localstud-about');
                                                      // await context
                                                      //     .read<LocalDataProvider2>()
                                                      //     .storeLocalStudentAbout('');

                                                      await context
                                                          .read<AuthProvider2>()
                                                          .signOutAccount();
                                                      showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (context) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        },
                                                      );
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  1000), () {
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                                Routes2
                                                                    .splashscreen2);
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                          print('object here');
                        }());
                      }
                      if (dateNowOnly == ayEndDateOnly && _isUpdated == true) {
                        context
                            .read<StudentNumberProvider2>()
                            .updateLocalUpdatedStatusAYEND();
                      }
                      return FutureBuilder<String?>(
                        future: context
                            .read<LocalDataProvider2>()
                            .getLocalCollege(),
                        builder: (context, snapshott) {
                          if (snapshott.hasData) {
                            return StreamBuilder<List<Thread>>(
                                stream: _streamThread,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    (() {
                                      if (context
                                              .read<SortProvider>()
                                              .sortType ==
                                          'mostpopular') {
                                        snapshot.data!.sort((a, b) => b
                                            .likers.length
                                            .compareTo(a.likers.length));
                                      }
                                      if (context
                                              .read<SortProvider>()
                                              .sortType ==
                                          'newest') {
                                        snapshot.data!.sort((a, b) =>
                                            b.tSdate.compareTo(a.tSdate));
                                      }
                                    }());
                                    List titles = [];

                                    return Scaffold(
                                      body: Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 204,
                                              bottom: size.height / 15,
                                            ),
                                            padding: const EdgeInsets.only(
                                              // top: size.height / 3,
                                              left: 14,
                                              right: 14,
                                            ),
                                            // height: size.height,
                                            width: size.width,
                                            child: ShaderMask(
                                              shaderCallback: (Rect rect) {
                                                return const LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.purple,
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                    Colors.purple
                                                  ],
                                                  stops: [
                                                    0.0,
                                                    0.0,
                                                    0.8,
                                                    1.0
                                                  ], // 10% purple, 80% transparent, 10% purple
                                                ).createShader(rect);
                                              },
                                              blendMode: BlendMode.dstOut,
                                              child: ListView.builder(
                                                  itemCount:
                                                      snapshot.data!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    List likers = snapshot
                                                        .data![index].likers;
                                                    DateTime myDateTime =
                                                        snapshot
                                                            .data![index].tSdate
                                                            .toDate();
                                                    String formattedDate =
                                                        DateFormat(
                                                                'yyyy-MM-dd – KK:mm a (EEE)')
                                                            .format(myDateTime);

                                                    //Timeago version
                                                    String formattedDatee =
                                                        timeago.format(
                                                      myDateTime,
                                                      locale: 'en_short',
                                                    );
                                                    (() {
                                                      //get this commentID to match replyID
                                                      context
                                                          .read<
                                                              ThreadReplyProvider>()
                                                          .changeThreadID(
                                                              snapshot
                                                                  .data![index]
                                                                  .id);
                                                    }());
                                                    if (snapshot.data![index]
                                                                .college ==
                                                            snapshott.data &&
                                                        snapshot.data![index]
                                                                .isDeletedByOwner ==
                                                            false) {
                                                      titles.add(snapshot
                                                          .data![index].title);
                                                      return GestureDetector(
                                                        onTap: () {
                                                          print(snapshot
                                                              .data![index].id);
                                                          // context
                                                          //         .read<ThreadMessageProvider2>()
                                                          //         .changeLikersTokens =
                                                          //     snapshot
                                                          //         .data![index].likersTokens;
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ThreadRoomScreen2(
                                                                            threadID:
                                                                                snapshot.data![index].id,
                                                                            threadTitle:
                                                                                snapshot.data![index].title,
                                                                            threadDescription:
                                                                                snapshot.data![index].description,
                                                                            creatorName:
                                                                                snapshot.data![index].creatorName,
                                                                            creatorSection:
                                                                                snapshot.data![index].creatorSection,
                                                                            formattedDate:
                                                                                formattedDate,
                                                                            threadCreatorID:
                                                                                snapshot.data![index].studID,
                                                                            likersTokens:
                                                                                snapshot.data![index].likersTokens.cast<String>(),
                                                                            authorToken:
                                                                                snapshot.data![index].authorToken,
                                                                          )));
                                                        },
                                                        child: GFCard(
                                                          margin:
                                                              EdgeInsets.only(
                                                            top: size.height /
                                                                150,
                                                            bottom: 5,
                                                          ),
                                                          showImage: true,
                                                          title: GFListTile(
                                                            avatar: GFAvatar(
                                                                backgroundImage:
                                                                    (() {
                                                              for (var i = 0;
                                                                  i <
                                                                      snapshot
                                                                          .data!
                                                                          .length;
                                                                  i++) {
                                                                if (snapshott
                                                                        .data!
                                                                        .toUpperCase() ==
                                                                    'CCS') {
                                                                  return const AssetImage(
                                                                      'assets/images/ic_ccs-logo.png');
                                                                }
                                                                if (snapshott
                                                                        .data!
                                                                        .toUpperCase() ==
                                                                    'COA') {
                                                                  return const AssetImage(
                                                                      'assets/images/ic_coa-logo.png');
                                                                }
                                                                if (snapshott
                                                                        .data!
                                                                        .toUpperCase() ==
                                                                    'COB') {
                                                                  return const AssetImage(
                                                                      'assets/images/ic_cob-logo.png');
                                                                }
                                                              }

                                                              return const AssetImage(
                                                                  '');
                                                            }())),
                                                            title: Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .title
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            subTitle: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  snapshot
                                                                          .data![
                                                                              index]
                                                                          .creatorName +
                                                                      ', ' +
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .creatorSection,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  formattedDate,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  formattedDatee ==
                                                                          'now'
                                                                      ? formattedDatee
                                                                      : formattedDatee +
                                                                          ' ago',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          content: Text(snapshot
                                                              .data![index]
                                                              .description),
                                                          buttonBar:
                                                              GFButtonBar(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  likers.contains(
                                                                          _myEmail)
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                              content: Text('You unlike this forum'),
                                                                              duration: Duration(milliseconds: 1000),
                                                                            ));
                                                                            //remove from likers
                                                                            await context.read<ThreadProvider2>().unLike(snapshot.data![index].id,
                                                                                _myEmail);
                                                                            //remove myToken from likersTokens
                                                                            await context.read<ThreadProvider2>().removeUnlikerToken(snapshot.data![index].id,
                                                                                _myDeviceToken);
                                                                            //remove myStudentNumber(ID) from likers_ids
                                                                            await context.read<ThreadProvider2>().removeLikerID(snapshot.data![index].id,
                                                                                _myStudentNumber);
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              GFAvatar(
                                                                                size: GFSize.SMALL,
                                                                                backgroundColor: Colors.transparent,
                                                                                child: Icon(
                                                                                  Icons.thumb_up_alt,
                                                                                  color: context.read<ThemeProvider2>().isDark ? Colors.lightBlue : kPrimaryColor,
                                                                                ),
                                                                              ),
                                                                              likers.length <= 1 ? Text(likers.length.toString() + ' like') : Text(likers.length.toString() + ' likes'),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                              content: Text('You liked this forum'),
                                                                              duration: Duration(milliseconds: 1000),
                                                                            ));
                                                                            //add user to likers
                                                                            await context.read<ThreadProvider2>().saveLike(snapshot.data![index].id,
                                                                                _myEmail);
                                                                            //add user token to liekrs tokens
                                                                            await context.read<ThreadProvider2>().saveLikerToken(snapshot.data![index].id,
                                                                                _myDeviceToken);
                                                                            //add mystudentNumber(ID) to likers_ids
                                                                            await context.read<ThreadProvider2>().saveLikerID(
                                                                                  snapshot.data![index].id,
                                                                                  _myStudentNumber,
                                                                                );
                                                                            //send like notif to author and notif object
                                                                            snapshot.data![index].authorToken == _myDeviceToken
                                                                                ? null
                                                                                : await _sendAndRetrieveLike(snapshot.data![index].authorToken);
                                                                            //create activity
                                                                            snapshot.data![index].studID == _myStudentNumber
                                                                                ? context.read<ActivityProvider2>().createActivity(
                                                                                      snapshot.data![index].id,
                                                                                      snapshot.data![index].title,
                                                                                      snapshot.data![index].description,
                                                                                      formattedDate,
                                                                                      snapshot.data![index].studID,
                                                                                      snapshot.data![index].creatorName,
                                                                                      snapshot.data![index].creatorSection,
                                                                                      snapshot.data![index].authorToken,
                                                                                      snapshot.data![index].likersTokens.cast<String>(),
                                                                                      'You liked your forum',
                                                                                      _myEmail,
                                                                                      '',
                                                                                    )
                                                                                : context.read<ActivityProvider2>().createActivity(
                                                                                      snapshot.data![index].id,
                                                                                      snapshot.data![index].title,
                                                                                      snapshot.data![index].description,
                                                                                      formattedDate,
                                                                                      snapshot.data![index].studID,
                                                                                      snapshot.data![index].creatorName,
                                                                                      snapshot.data![index].creatorSection,
                                                                                      snapshot.data![index].authorToken,
                                                                                      snapshot.data![index].likersTokens.cast<String>(),
                                                                                      'You liked a forum',
                                                                                      _myEmail,
                                                                                      '',
                                                                                    );
                                                                            //create notification
                                                                            context.read<NotificationProvider>().setNotification(
                                                                                  notifReceiverStudnum: snapshot.data![index].studID,
                                                                                  myStudentnumber: _myStudentNumber,
                                                                                  myEmail: _myEmail,
                                                                                  forumID: snapshot.data![index].id,
                                                                                  forumDescription: snapshot.data![index].description,
                                                                                  forumDate: formattedDatee,
                                                                                  forumTitle: snapshot.data![index].title,
                                                                                  authorName: snapshot.data![index].creatorName,
                                                                                  authorSection: snapshot.data![index].creatorSection,
                                                                                  authorID: snapshot.data![index].studID,
                                                                                  authorToken: snapshot.data![index].authorToken,
                                                                                  likersTokens: snapshot.data![index].likers,
                                                                                  title: _myFname + ' ' + _myLname + ' liked your forum',
                                                                                  comment: '',
                                                                                );
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const GFAvatar(
                                                                                size: GFSize.SMALL,
                                                                                backgroundColor: Colors.transparent,
                                                                                child: Icon(
                                                                                  Icons.thumb_up_alt,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                              likers.length <= 1 ? Text(likers.length.toString() + ' like') : Text(likers.length.toString() + ' likes'),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                  const Spacer(),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                          builder: (context) => ThreadRoomScreen2(
                                                                                threadID: snapshot.data![index].id,
                                                                                threadTitle: snapshot.data![index].title,
                                                                                threadDescription: snapshot.data![index].description,
                                                                                creatorName: snapshot.data![index].creatorName,
                                                                                creatorSection: snapshot.data![index].creatorSection,
                                                                                formattedDate: formattedDate,
                                                                                threadCreatorID: snapshot.data![index].studID,
                                                                                likersTokens: snapshot.data![index].likersTokens.cast<String>(),
                                                                                authorToken: snapshot.data![index].authorToken,
                                                                              )));
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        const GFAvatar(
                                                                          size:
                                                                              GFSize.SMALL,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          child:
                                                                              Icon(
                                                                            Icons.mode_comment_outlined,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                        Text(snapshot.data![index].msgSent > 1
                                                                            ? snapshot.data![index].msgSent.toString() +
                                                                                ' comments'
                                                                            : snapshot.data![index].msgSent.toString() +
                                                                                ' comment'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                  snapshot.data![index].studID ==
                                                                          _myStudentNumber
                                                                      ? Container()
                                                                      : snapshot
                                                                              .data![index]
                                                                              .reportersEmail
                                                                              .contains(_myEmail)
                                                                          ? GestureDetector(
                                                                              onTap: () {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    barrierDismissible: false,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                                        content: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: <Widget>[
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                child: ListBody(
                                                                                                  children: <Widget>[
                                                                                                    Row(
                                                                                                      children: const [
                                                                                                        Icon(
                                                                                                          FontAwesomeIcons.exclamationCircle,
                                                                                                          color: kPrimaryColor,
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 12,
                                                                                                        ),
                                                                                                        Text('Already Reported'),
                                                                                                      ],
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      height: 21,
                                                                                                    ),
                                                                                                    Row(
                                                                                                      children: const [
                                                                                                        Expanded(
                                                                                                          child: Text(
                                                                                                            'You already reported this forum. Wait for the admin approval',
                                                                                                            textAlign: TextAlign.center,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                  children: <Widget>[
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: RaisedButton(
                                                                                                        color: kPrimaryColor,
                                                                                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                                        child: const Text(
                                                                                                          "Close",
                                                                                                          style: TextStyle(
                                                                                                            color: Colors.white,
                                                                                                          ),
                                                                                                        ),
                                                                                                        onPressed: () {
                                                                                                          setState(() {
                                                                                                            reason = null;
                                                                                                          });

                                                                                                          Navigator.of(context).pop();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    });
                                                                              },
                                                                              child: Row(
                                                                                children: [
                                                                                  GFAvatar(
                                                                                    size: GFSize.SMALL,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    child: Icon(
                                                                                      Icons.error,
                                                                                      color: Colors.grey[700],
                                                                                    ),
                                                                                  ),
                                                                                  const Text('Reported  '),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : GestureDetector(
                                                                              onTap: () {
                                                                                showDialog(
                                                                                  context: context,
                                                                                  barrierDismissible: false,
                                                                                  builder: (BuildContext context) {
                                                                                    return AlertDialog(
                                                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                                      content: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: <Widget>[
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: ListBody(
                                                                                                children: <Widget>[
                                                                                                  Row(
                                                                                                    children: const [
                                                                                                      Icon(
                                                                                                        FontAwesomeIcons.exclamationCircle,
                                                                                                        color: kPrimaryColor,
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        width: 12,
                                                                                                      ),
                                                                                                      Text('Report Forum'),
                                                                                                    ],
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 21,
                                                                                                  ),
                                                                                                  Row(
                                                                                                    children: const [
                                                                                                      Expanded(
                                                                                                        child: Text(
                                                                                                          'Are you sure this forum violates UsApp\'s terms and conditions?',
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    height: 21,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                                children: <Widget>[
                                                                                                  Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                      Container(
                                                                                                        decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                                                        width: size.width * 0.5,
                                                                                                        child: DropdownButtonFormField<String>(
                                                                                                          decoration: const InputDecoration(contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0), filled: true, fillColor: Colors.white, hintText: 'Reason for report', hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)),
                                                                                                          value: reason,
                                                                                                          icon: const Icon(Icons.arrow_drop_down, color: kPrimaryColor),
                                                                                                          iconSize: 24,
                                                                                                          elevation: 16,
                                                                                                          style: const TextStyle(color: Colors.black),
                                                                                                          onChanged: (String? newValue) {
                                                                                                            setState(() {
                                                                                                              reason = newValue!;
                                                                                                            });
                                                                                                          },
                                                                                                          validator: (value) {
                                                                                                            if (value == null) {
                                                                                                              return "Reason for report";
                                                                                                            }
                                                                                                            return null;
                                                                                                          },
                                                                                                          items: reasons.map<DropdownMenuItem<String>>((String option) {
                                                                                                            return DropdownMenuItem<String>(
                                                                                                              value: option,
                                                                                                              child: Text(
                                                                                                                option,
                                                                                                                style: const TextStyle(
                                                                                                                  color: kPrimaryColor,
                                                                                                                ),
                                                                                                              ),
                                                                                                            );
                                                                                                          }).toList(),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                children: <Widget>[
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: RaisedButton(
                                                                                                      color: kPrimaryColor,
                                                                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                                      child: const Text(
                                                                                                        "CANCEL",
                                                                                                        style: TextStyle(
                                                                                                          color: Colors.white,
                                                                                                        ),
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        setState(() {
                                                                                                          reason = null;
                                                                                                        });
                                                                                                        Navigator.of(context).pop();
                                                                                                      },
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: RaisedButton(
                                                                                                      color: kPrimaryColor,
                                                                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                                      child: const Text(
                                                                                                        "REPORT",
                                                                                                        style: TextStyle(color: Colors.white),
                                                                                                      ),
                                                                                                      onPressed: () async {
                                                                                                        if (reason != null) {
                                                                                                          print('not null!');
                                                                                                          //data from thread
                                                                                                          String reportID = snapshot.data![index].id; //threadID for reportID as well
                                                                                                          String thrTitle = snapshot.data![index].title;
                                                                                                          String thrCreatorID = snapshot.data![index].studID;
                                                                                                          String thrCreatorName = snapshot.data![index].creatorName;
                                                                                                          //data from report dialog
                                                                                                          String reasonPicked = reason!;
                                                                                                          //send to report provider
                                                                                                          ReportProvider reportProvider = ReportProvider();
                                                                                                          reportProvider.changeReason = reasonPicked;
                                                                                                          reportProvider.changeThrCreatorID = thrCreatorID;
                                                                                                          reportProvider.changeThrCreatorName = thrCreatorName;
                                                                                                          reportProvider.changeThreadID = reportID;
                                                                                                          reportProvider.changeThreadTitle = thrTitle;
                                                                                                          reportProvider.changeReportCount = 1;
                                                                                                          if (snapshot.data![index].reportersEmail.isNotEmpty) {
                                                                                                            if (snapshot.data![index].reportersEmail.contains(_myEmail) == false) {
                                                                                                              await reportProvider.addReportFields();
                                                                                                              await reportProvider.clickNow();
                                                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                                                content: Text('Reported successfully'),
                                                                                                                duration: Duration(milliseconds: 1000),
                                                                                                              ));
                                                                                                              Navigator.of(context).pop();
                                                                                                              //send report notif to author and notif object
                                                                                                              snapshot.data![index].authorToken == _myDeviceToken ? null : await _sendAndRetrieveReport(snapshot.data![index].authorToken);

                                                                                                              //create activity
                                                                                                              context.read<ActivityProvider2>().createActivity(
                                                                                                                    snapshot.data![index].id, //forum id
                                                                                                                    snapshot.data![index].title, //forum title
                                                                                                                    snapshot.data![index].description, //forum description
                                                                                                                    formattedDate, //forum date
                                                                                                                    snapshot.data![index].studID, // creator id
                                                                                                                    snapshot.data![index].creatorName, // creator name
                                                                                                                    snapshot.data![index].creatorSection, // creatoe section
                                                                                                                    snapshot.data![index].authorToken, // author token
                                                                                                                    snapshot.data![index].likersTokens.cast<String>(), //likers tokens
                                                                                                                    'You reported a forum.',
                                                                                                                    _myEmail,
                                                                                                                    '',
                                                                                                                  );
                                                                                                            }
                                                                                                          } else {
                                                                                                            await reportProvider.saveReport();
                                                                                                            await reportProvider.clickNow();
                                                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                                              content: Text('Reported successfully'),
                                                                                                              duration: Duration(milliseconds: 1000),
                                                                                                            ));
                                                                                                            Navigator.of(context).pop();
                                                                                                            //create activity
                                                                                                            context.read<ActivityProvider2>().createActivity(
                                                                                                                  snapshot.data![index].id, //forum id
                                                                                                                  snapshot.data![index].title, //forum title
                                                                                                                  snapshot.data![index].description, //forum description
                                                                                                                  formattedDate, //forum date
                                                                                                                  snapshot.data![index].studID, // creator id
                                                                                                                  snapshot.data![index].creatorName, // creator name
                                                                                                                  snapshot.data![index].creatorSection, // creatoe section
                                                                                                                  snapshot.data![index].authorToken, // author token
                                                                                                                  snapshot.data![index].likersTokens.cast<String>(), //likers tokens
                                                                                                                  'You reported a forum',
                                                                                                                  _myEmail,
                                                                                                                  '',
                                                                                                                );
                                                                                                          }
                                                                                                        } else {
                                                                                                          print('null');
                                                                                                          showDialog(
                                                                                                              context: context,
                                                                                                              builder: (BuildContext context) {
                                                                                                                return AlertDialog(
                                                                                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                                                                  content: Padding(
                                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                                    child: Column(
                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                      children: <Widget>[
                                                                                                                        Padding(
                                                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                                                          child: ListBody(
                                                                                                                            children: <Widget>[
                                                                                                                              Row(
                                                                                                                                children: const [
                                                                                                                                  Icon(
                                                                                                                                    FontAwesomeIcons.exclamationTriangle,
                                                                                                                                    color: kPrimaryColor,
                                                                                                                                  ),
                                                                                                                                  SizedBox(
                                                                                                                                    width: 12,
                                                                                                                                  ),
                                                                                                                                  Text('Empty Reason Field'),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                              const SizedBox(
                                                                                                                                height: 21,
                                                                                                                              ),
                                                                                                                              Row(
                                                                                                                                children: const [
                                                                                                                                  Expanded(
                                                                                                                                    child: Text(
                                                                                                                                      'Tell us the reason for reporting this forum',
                                                                                                                                      textAlign: TextAlign.center,
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Padding(
                                                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                                                          child: Row(
                                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                                            children: <Widget>[
                                                                                                                              Padding(
                                                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                                                child: RaisedButton(
                                                                                                                                  color: kPrimaryColor,
                                                                                                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                                                                  child: const Text(
                                                                                                                                    "Close",
                                                                                                                                    style: TextStyle(
                                                                                                                                      color: Colors.white,
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                  onPressed: () {
                                                                                                                                    setState(() {
                                                                                                                                      reason = null;
                                                                                                                                    });

                                                                                                                                    Navigator.of(context).pop();
                                                                                                                                  },
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                );
                                                                                                              });
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: Row(
                                                                                children: [
                                                                                  GFAvatar(
                                                                                    size: GFSize.SMALL,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    child: Icon(
                                                                                      Icons.error_outline,
                                                                                      color: context.watch<ThemeProvider2>().isDark ? Colors.red[400] : Colors.red,
                                                                                    ),
                                                                                  ),
                                                                                  const Text('Report  '),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                      //---------------
                                                      // return Container();

                                                    } else {
                                                      return Container();
                                                    }
                                                  }
                                                  // else {
                                                  //   return Container();
                                                  // }
                                                  // },
                                                  ),
                                            ),
                                          ),

                                          //TOPBANNER CUSTOM APPBAR
                                          Container(
                                            // It will cover 20% of our total height

                                            // height: size.height / 3.16,
                                            // height: 228,
                                            height: 226,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                              ),
                                            ),
                                            child: SafeArea(
                                              child: Column(
                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      IconButton(
                                                        onPressed:
                                                            _handleMenuButtonPressed,
                                                        icon: ValueListenableBuilder<
                                                            AdvancedDrawerValue>(
                                                          valueListenable: context
                                                              .watch<
                                                                  AdvDrawerController>()
                                                              .advDrawerController,
                                                          builder:
                                                              (_, value, __) {
                                                            return AnimatedSwitcher(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          250),
                                                              child: Icon(
                                                                value.visible
                                                                    ? Icons
                                                                        .arrow_back_ios
                                                                    : Icons
                                                                        .menu,
                                                                color: Colors
                                                                    .white,
                                                                key: ValueKey<
                                                                    bool>(
                                                                  value.visible,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      (() {
                                                        for (var i = 0;
                                                            i <
                                                                snapshot.data!
                                                                    .length;
                                                            i++) {
                                                          if (snapshott.data!
                                                                  .toUpperCase() ==
                                                              'CCS') {
                                                            return Image.asset(
                                                              'assets/images/ic_ccs-logo.png',
                                                              height: 30,
                                                            );
                                                          }
                                                          if (snapshott.data!
                                                                  .toUpperCase() ==
                                                              'COA') {
                                                            return Image.asset(
                                                              'assets/images/ic_coa-logo.png',
                                                              height: 30,
                                                            );
                                                          }
                                                          if (snapshott.data!
                                                                  .toUpperCase() ==
                                                              'COB') {
                                                            return Image.asset(
                                                              'assets/images/ic_cob-logo.png',
                                                              height: 30,
                                                            );
                                                          }
                                                        }
                                                        return Container();
                                                      }()),
                                                      StreamBuilder<
                                                              List<
                                                                  StudentNumber>>(
                                                          stream:
                                                              _streamMembers,
                                                          builder: (context,
                                                              membersSnap) {
                                                            if (membersSnap
                                                                .hasData) {
                                                              membersSnap.data!
                                                                  .forEach(
                                                                      (member) {
                                                                if (member.college ==
                                                                        _myCollege &&
                                                                    member.deviceToken !=
                                                                        _myDeviceToken) {
                                                                  context
                                                                          .read<
                                                                              PostNotifProvider>()
                                                                          .collegeMatesTokens
                                                                          .contains(member
                                                                              .deviceToken)
                                                                      ? null
                                                                      : context
                                                                          .read<
                                                                              PostNotifProvider>()
                                                                          .collegeMatesTokens
                                                                          .add(member
                                                                              .deviceToken);
                                                                }
                                                              });
                                                              return Row(
                                                                children: [
                                                                  Text(
                                                                    ' ' +
                                                                        (() {
                                                                          for (var student
                                                                              in snapshot.data!) {
                                                                            if (student.college ==
                                                                                snapshott.data!) {
                                                                              return student.college;
                                                                            }
                                                                          }
                                                                          return '';
                                                                        }()) +
                                                                        ' Forums'
                                                                    //  + ' ' +
                                                                    // myCourseCompletionYear
                                                                    //     .toString()
                                                                    ,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          21,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/forums.png',
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            } else {
                                                              return Container();
                                                            }
                                                          }),
                                                      const Spacer(),
                                                      PopupMenuButton<String>(
                                                        icon: const Icon(
                                                          Icons.more_vert,
                                                          color: Colors.white,
                                                        ),
                                                        itemBuilder:
                                                            (BuildContext
                                                                contesxt) {
                                                          return [
                                                            PopupMenuItem(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          Routes2
                                                                              .myThreadsscreen2);
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: const [
                                                                    Text(
                                                                        'My Forums'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          Routes2
                                                                              .likedThreadsscreen2);
                                                                },
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: const [
                                                                    Text(
                                                                        'Liked Forums'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ];
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(() {});
                                                            context
                                                                    .read<
                                                                        SortProvider>()
                                                                    .changeSortType =
                                                                'mostpopular';
                                                          },
                                                          child: _buildChip(
                                                              ' Most Popular',
                                                              Colors.teal)),
                                                      const SizedBox(
                                                        width: 12,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(() {});
                                                            context
                                                                    .read<
                                                                        SortProvider>()
                                                                    .changeSortType =
                                                                'newest';
                                                          },
                                                          child: _buildChip(
                                                            ' Newest',
                                                            Colors.cyan,
                                                          )),
                                                    ],
                                                  ),
                                                  GFSearchBar(
                                                    searchList: titles,
                                                    overlaySearchListItemBuilder:
                                                        (title) {
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: Text(
                                                          title.toString(),
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: context
                                                                    .read<
                                                                        ThemeProvider2>()
                                                                    .isDark
                                                                ? Colors.black
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    searchQueryBuilder:
                                                        (String searchText,
                                                            threadsList) {
                                                      return threadsList
                                                          .where((title) => title
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(searchText
                                                                  .toLowerCase()))
                                                          .toList();
                                                    },
                                                    onItemSelected: (title) {
                                                      setState(() {
                                                        print('$title');
                                                        // _searchText = title.toString();
                                                      });
                                                      if (title != null) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    SearchedThreadScreen2(
                                                                        searchText:
                                                                            title.toString())));
                                                        context
                                                                .read<
                                                                    SearchProvider2>()
                                                                .changeThrSearchText =
                                                            title.toString();
                                                        setState(() {});
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          //CUSTOM FAB
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: size.height / 1.2,
                                                left: size.width / 1.2),
                                            child: FloatingActionButton(
                                              // heroTag: 'btn1',
                                              child: const Icon(
                                                Icons.add,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                              backgroundColor: Theme.of(context)
                                                  .backgroundColor,
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20.0))),
                                                      title: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .post_add_rounded,
                                                            color: context
                                                                    .read<
                                                                        ThemeProvider2>()
                                                                    .isDark
                                                                ? Colors.white
                                                                : kPrimaryColor,
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          Text(
                                                            'Post a Forum',
                                                            style: TextStyle(
                                                              color: context
                                                                      .read<
                                                                          ThemeProvider2>()
                                                                      .isDark
                                                                  ? Colors.white
                                                                  : kPrimaryColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: ListBody(
                                                          children: <Widget>[
                                                            Form(
                                                              key: _formKey,
                                                              child: Column(
                                                                children: [
                                                                  TextFormField(
                                                                    textCapitalization:
                                                                        TextCapitalization
                                                                            .sentences,
                                                                    onChanged: (value) => context
                                                                            .read<
                                                                                ThreadProvider2>()
                                                                            .changeThreadTitle =
                                                                        value =
                                                                            value,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? Colors.white
                                                                              : kPrimaryColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? Colors.lightBlue
                                                                              : kPrimaryColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      labelText:
                                                                          'Forum Topic/Title',
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        // color: kPrimaryColor,
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor,
                                                                      ),
                                                                      prefixIcon: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? Colors.white
                                                                              : kPrimaryColor),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 12,
                                                                  ),
                                                                  TextFormField(
                                                                    textCapitalization:
                                                                        TextCapitalization
                                                                            .sentences,
                                                                    minLines: 2,
                                                                    maxLines: 4,
                                                                    // maxLength: 600,
                                                                    onChanged: (value) => context
                                                                            .read<
                                                                                ThreadProvider2>()
                                                                            .changeDescription =
                                                                        value =
                                                                            value,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? Colors.white
                                                                              : kPrimaryColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(24.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? Colors.lightBlue
                                                                              : kPrimaryColor,
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      labelText:
                                                                          'Description',
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        // color: kPrimaryColor,
                                                                        color: context.read<ThemeProvider2>().isDark
                                                                            ? Colors.white
                                                                            : kPrimaryColor,
                                                                      ),
                                                                      prefixIcon: Icon(
                                                                          Icons
                                                                              .format_align_left,
                                                                          color: context.read<ThemeProvider2>().isDark
                                                                              ? Colors.white
                                                                              : kPrimaryColor),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text(
                                                            'Post',
                                                            style: TextStyle(
                                                                color: context
                                                                        .read<
                                                                            ThemeProvider2>()
                                                                        .isDark
                                                                    ? Colors
                                                                        .white
                                                                    : kPrimaryColor),
                                                          ),
                                                          onPressed: () async {
                                                            if ((context.read<ThreadProvider2>().threadTitle !=
                                                                        null &&
                                                                    context
                                                                            .read<
                                                                                ThreadProvider2>()
                                                                            .threadTitle !=
                                                                        '') &&
                                                                (context.read<ThreadProvider2>().description !=
                                                                        null &&
                                                                    context
                                                                            .read<ThreadProvider2>()
                                                                            .description !=
                                                                        '')) {
                                                              //send nootif
                                                              _sendPostNotif();
                                                              await context
                                                                  .read<
                                                                      ThreadProvider2>()
                                                                  .saveThread();
                                                              print(context
                                                                  .read<
                                                                      ThreadProvider2>()
                                                                  .threadTitle);
                                                              print(context
                                                                  .read<
                                                                      ThreadProvider2>()
                                                                  .description);

                                                              //create activity
                                                              await context
                                                                  .read<
                                                                      ActivityProvider2>()
                                                                  .createActivity(
                                                                    '',
                                                                    '',
                                                                    '',
                                                                    '',
                                                                    '',
                                                                    '',
                                                                    '',
                                                                    '',
                                                                    [],
                                                                    'You posted a forum',
                                                                    _myEmail,
                                                                    context
                                                                        .read<
                                                                            ThreadProvider2>()
                                                                        .threadTitle!,
                                                                  );
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  () {
                                                                context
                                                                    .read<
                                                                        ThreadProvider2>()
                                                                    .changeThreadTitle = '';
                                                                context
                                                                    .read<
                                                                        ThreadProvider2>()
                                                                    .changeDescription = '';
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              // print('object clicked');
                                                            } else {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(20.0))),
                                                                      content:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: ListBody(
                                                                                children: <Widget>[
                                                                                  Row(
                                                                                    children: const [
                                                                                      Icon(
                                                                                        FontAwesomeIcons.exclamationCircle,
                                                                                        color: kPrimaryColor,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 12,
                                                                                      ),
                                                                                      Text('Empty Fields'),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    height: 21,
                                                                                  ),
                                                                                  Row(
                                                                                    children: const [
                                                                                      Expanded(
                                                                                        child: Text(
                                                                                          'Please provide necessary information.',
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: <Widget>[
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: RaisedButton(
                                                                                      color: kPrimaryColor,
                                                                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                                      child: const Text(
                                                                                        "Close",
                                                                                        style: TextStyle(
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          reason = null;
                                                                                        });

                                                                                        Navigator.of(context).pop();
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    // return const Center(
                                    //   child: Text('No Data'),
                                    // );
                                    return GFShimmer(
                                      child: const Center(
                                        child: EmptyBlock(),
                                      ),
                                      showGradient: true,
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomRight,
                                        end: Alignment.centerLeft,
                                        stops: const <double>[
                                          0,
                                          0.3,
                                          0.6,
                                          0.9,
                                          1
                                        ],
                                        colors: [
                                          Colors.grey.withOpacity(0.1),
                                          Colors.grey.withOpacity(0.3),
                                          Colors.grey.withOpacity(0.5),
                                          Colors.grey.withOpacity(0.7),
                                          Colors.grey.withOpacity(0.9),
                                        ],
                                      ),
                                    );
                                  }
                                });
                          } else {
                            return Container();
                          }
                        },
                      );
                    } else {
                      return Container();
                    }
                  });
            } else {
              return Container();
            }
          }),
      // PERSONAL MESSAGE TAB/PAGE
      Scaffold(
        body: Stack(
          children: [
            StreamBuilder<List<UserChat>>(
                stream: _streamPDmPm,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Chat myChatModel = Chat(
                      name: _myFname + ' ' + _myLname,
                      photo: _myPhoto,
                      section: _myYearSec,
                      token: _myDeviceToken,
                    );
                    List<Chat> chatters = [];
                    List<String> emails = [];
                    List<bool> unreads = [];
                    return Container(
                      margin: EdgeInsets.only(top: size.height / 9),
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          snapshot.data!
                              .sort((a, b) => b.date.compareTo(a.date));
                          UserChat docData = snapshot.data![index];
                          String notMyName = '';
                          String notMySection = _myYearSec;
                          String notMyPhoto = '';
                          String notMyEmail = '';
                          List splitNotMyName = [];
                          String notMyToken = '';
                          chatters = docData.chatters;

                          // for (var i = 0; i < chatters.length; i++) {
                          //   if (chatters[i].section != myChatModel.section) {
                          //     chatters[i].section == 'Alumnus'
                          //         ? notMySection = 'Alumnus'
                          //         : notMySection = chatters[i].section;
                          //   }
                          // }

                          chatters.forEach((chatter) {
                            if (chatter.name != myChatModel.name) {
                              // setState(() {
                              notMyName = chatter.name;
                              splitNotMyName = notMyName.split(' ');
                              // });
                            }

                            if (chatter.section != myChatModel.section &&
                                chatter.name != myChatModel.name) {
                              chatter.section == 'Alumnus'
                                  ? notMySection = 'Alumnus'
                                  : notMySection = chatter.section;
                            }

                            print(chatter.section + ' ' + chatter.name);

                            if (chatter.photo != myChatModel.photo &&
                                chatter.name != myChatModel.name) {
                              // setState(() {
                              notMyPhoto = chatter.photo;
                              // });
                            }
                            if (chatter.token != myChatModel.token) {
                              notMyToken = chatter.token;
                            }
                          });
                          emails = docData.ids;
                          emails.forEach((id) {
                            if (id != _myEmail) {
                              notMyEmail = id;
                            }
                          });
                          if (docData.isRead == false &&
                              docData.sender != _myEmail) {
                            unreads.add(docData.isRead);
                          }
                          //check the 'is_read' property of userchat[index]: save to notifProvider notifCount
                          context
                              .read<NotificationProvider>()
                              .homeMsgNotifCount = unreads.length;

                          DateTime myDateTime2 = docData.date.toDate();
                          String formattedDate2 = timeago.format(
                            myDateTime2,
                            locale: 'en_short',
                          );
                          return GestureDetector(
                            onTap: () async {
                              context
                                      .read<DirectMessagesContentProvider2>()
                                      .changeChatID =
                                  context
                                          .read<DirectMessagesContentProvider2>()
                                          .changeLatestMessage =
                                      docData.latestMessage;
                              context
                                      .read<DirectMessagesContentProvider2>()
                                      .changeSenderName =
                                  (_myFname + ' ' + _myLname);
                              context
                                      .read<DirectMessagesContentProvider2>()
                                      .changeSenderYearSec =
                                  _myYearLevel > _myCompletionYear
                                      ? 'Alumnus'
                                      : _myYearSec;
                              context
                                  .read<DirectMessagesContentProvider2>()
                                  .changeSenderPhotoUrl = _myPhoto;
                              context
                                  .read<DirectMessagesContentProvider2>()
                                  .changeSenderEmail = _myEmail;
                              //
                              context
                                  .read<DirectMessagesContentProvider2>()
                                  .changeReceiverName = notMyName;
                              context
                                  .read<DirectMessagesContentProvider2>()
                                  .changeReceiverYearSec = notMySection;
                              context
                                  .read<DirectMessagesContentProvider2>()
                                  .changeReceiverPhotoUrl = notMyPhoto;
                              context
                                  .read<DirectMessagesContentProvider2>()
                                  .changeReceiverEmail = notMyEmail;
                              context
                                  .read<DirectMessagesContentProvider2>()
                                  .changeChatID = docData.chatid;
                              if (docData.sender != _myEmail) {
                                await context
                                    .read<DirectMessagesContentProvider2>()
                                    .updateChat();
                                //
                                //RECYCLE FOR GENERAL NOTIFICATIONS
                                // docData.isRead == false
                                //     ? docData.receiver == _myEmail
                                //         ? context
                                //             .read<NotificationProvider>()
                                //             .decreaseNotifCount(_myEmail)
                                //         : null
                                //     : null;
                                //(remove shorthand if-else[above this])
                                // int newVal = _increment -= 1;
                                // context
                                //     .read<NotificationProvider>()
                                //     .totalNotificationCounter = newVal;
                                context
                                            .read<NotificationProvider>()
                                            .homeMsgNotifCount >=
                                        1
                                    ? context
                                        .read<NotificationProvider>()
                                        .homeMsgNotifCount = (context
                                            .read<NotificationProvider>()
                                            .homeMsgNotifCount -
                                        1)
                                    : null;
                              }
                              //update sender details on provider
                              context
                                  .read<DirectMessageProvider2>()
                                  .changeSenderEmail = _myEmail;
                              context
                                      .read<DirectMessageProvider2>()
                                      .changeSenderName =
                                  (_myFname + ' ' + _myLname);
                              context
                                      .read<DirectMessageProvider2>()
                                      .changeSenderYearSec =
                                  _myYearLevel > _myCompletionYear
                                      ? 'Alumnus'
                                      : _myYearSec;
                              context
                                  .read<DirectMessageProvider2>()
                                  .changeSenderPhotoUrl = _myPhoto;
                              context
                                  .read<DirectMessageProvider2>()
                                  .changeSenderID = _myStudentNumber;
                              context
                                  .read<DirectMessageProvider2>()
                                  .changeSenderToken = _myDeviceToken;
                              //update reciever details on provider
                              context
                                  .read<DirectMessageProvider2>()
                                  .changeRecieverEmail = notMyEmail;
                              context
                                  .read<DirectMessageProvider2>()
                                  .changeRecieverName = notMyName;
                              context
                                  .read<DirectMessageProvider2>()
                                  .changeRecieverYearSec = notMySection;
                              context
                                  .read<DirectMessageProvider2>()
                                  .changeRecieverPhotoUrl = notMyPhoto;
                              context
                                  .read<DirectMessageProvider2>()
                                  .changeRecieverToken = notMyToken;
                              //
                              context
                                  .read<DirectMessageProvider2>()
                                  .changeDmID = docData.chatid;

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DirectMessageScreen2(
                                      senderName: _myFname + ' ' + _myLname,
                                      senderYearSec:
                                          _myYearLevel > _myCompletionYear
                                              ? 'Alumnus'
                                              : _myYearSec,
                                      senderPhotoUrl: _myPhoto,
                                      senderEmail: _myEmail,
                                      recieverName: notMyName,
                                      recieverYearSec: notMySection,
                                      recieverPhotoUrl: notMyPhoto,
                                      receiverEmail: notMyEmail,
                                      senderToken: _myDeviceToken,
                                      recieverToken: notMyToken,
                                      convoID: docData.chatid,
                                    ),
                                  ));
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(bottom: size.height * .01),
                              padding: const EdgeInsets.only(
                                left: 21,
                                bottom: 21,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    child: Image.network(
                                      notMyPhoto,
                                      height: 45,
                                      width: 45,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  //message not read
                                  docData.isRead == false
                                      //if sender is me
                                      ? docData.sender == _myEmail
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  notMyName,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  notMySection,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: size.width / 1.6,
                                                      child: Text(
                                                        'You: ' +
                                                            docData
                                                                .latestMessage,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    Text(
                                                      formattedDate2,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          //sender not me
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  notMyName,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  notMySection,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: size.width / 1.6,
                                                      child: Text(
                                                        splitNotMyName[0] +
                                                            ': ' +
                                                            docData
                                                                .latestMessage,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    Text(
                                                      formattedDate2,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                      //message is read
                                      //sender is me
                                      : docData.sender == _myEmail
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  notMyName,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  notMySection,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: size.width / 1.6,
                                                      child: Text(
                                                        'You: ' +
                                                            docData
                                                                .latestMessage,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white60,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          'Seen',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          formattedDate2,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          //sender not me
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  notMyName,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  notMySection,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: size.width / 1.6,
                                                      child: Text(
                                                        splitNotMyName[0] +
                                                            ': ' +
                                                            docData
                                                                .latestMessage,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white60,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        const Text(
                                                          'Seen',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          formattedDate2,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return GFShimmer(
                      child: const Center(
                        child: EmptyBlockPmDm(),
                      ),
                      showGradient: true,
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.centerLeft,
                        stops: const <double>[0, 0.3, 0.6, 0.9, 1],
                        colors: [
                          Colors.grey.withOpacity(0.1),
                          Colors.grey.withOpacity(0.3),
                          Colors.grey.withOpacity(0.5),
                          Colors.grey.withOpacity(0.7),
                          Colors.grey.withOpacity(0.9),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    // child: Image.asset('assets/images/dont-care-idc.png'),
                    child: Text(
                      'No data',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }),
            //TOPBANNER CUSTOM APPBAR
            Container(
              // It will cover 20% of our total height
              padding: const EdgeInsets.only(
                  // bottom: 12,
                  ),
              height: size.height / 2.5 - (size.height / 3.5),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        IconButton(
                          onPressed: _handleMenuButtonPressed,
                          icon: ValueListenableBuilder<AdvancedDrawerValue>(
                            valueListenable: context
                                .watch<AdvDrawerController>()
                                .advDrawerController,
                            builder: (_, value, __) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  value.visible
                                      ? Icons.arrow_back_ios
                                      : Icons.menu,
                                  color: Colors.white,
                                  key: ValueKey<bool>(value.visible),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: const [
                            Text(
                              'Personal Chats',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Icon(
                              FontAwesomeIcons.solidCommentAlt,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const Spacer(),
                        // PopupMenuButton<String>(
                        //   icon: const Icon(
                        //     Icons.more_vert,
                        //     color: Colors.white,
                        //   ),
                        //   itemBuilder: (BuildContext contesxt) {
                        //     return [
                        //       PopupMenuItem(
                        //         child: GestureDetector(
                        //           onTap: () {
                        //             Navigator.of(context)
                        //                 .pushNamed(Routes2.myThreadsscreen2);
                        //           },
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: const [
                        //               Text('My Forums'),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       PopupMenuItem(
                        //         child: GestureDetector(
                        //           onTap: () {
                        //             Navigator.of(context)
                        //                 .pushNamed(Routes2.likedThreadsscreen2);
                        //           },
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: const [
                        //               Text('Liked Forums'),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ];
                        //   },
                        // ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //CUSTOM FAB
            Container(
              margin: EdgeInsets.only(
                  top: size.height / 1.2, left: size.width / 1.2),
              child: FloatingActionButton(
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
                backgroundColor: Theme.of(context).backgroundColor,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddConversatioScreen2()));
                },
              ),
            ),
          ],
        ),
      ),
      //Third Screen: Notifications
      Scaffold(
        body: Stack(
          children: [
            StreamBuilder<List<UsappNotification>>(
              stream: _streamUsappNotifications,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  snapshot.data!
                      .sort((a, b) => b.notifDate.compareTo(a.notifDate));
                  List<UsappNotification> filteredNotifs = [];
                  snapshot.data!.forEach((notif) {
                    if (notif.notifOwner == _myStudentNumber) {
                      filteredNotifs.add(notif);
                    }
                  });
                  List<TopicForumScreen> topicForumScreenList = [];
                  filteredNotifs.forEach((notif) {
                    if (notif.notifOwner == _myStudentNumber) {
                      topicForumScreenList.add(notif.topicForumScreen);
                    }
                  });
                  List<UsappNotification> notificationData = [];
                  filteredNotifs.forEach((notif) {
                    if (notif.notifOwner == _myStudentNumber) {
                      notificationData.add(notif);
                    }
                  });
                  //for notification count
                  DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm");
                  String formattedDateNow = dateFormat.format(DateTime.now());
                  List<UsappNotification> notifNow = [];
                  filteredNotifs.forEach((notif) {
                    if (notif.notifOwner == _myStudentNumber &&
                        dateFormat.format(notif.notifDate.toDate()) ==
                            formattedDateNow) {
                      notifNow.add(notif);

                      context
                              .read<NotificationProvider>()
                              .myNotifNow
                              .contains(notif.notifID)
                          ? context
                              .read<NotificationProvider>()
                              .myNotifNow
                              .clear()
                          : context
                              .read<NotificationProvider>()
                              .myNotifNow
                              .add(notif.notifID);
                    }
                  });

                  return Container(
                    // color: Colors.amber,
                    margin: EdgeInsets.only(
                      top: size.height / 9,
                      bottom: size.height / 15,
                    ),
                    child: ListView.builder(
                      itemCount: filteredNotifs.length,
                      itemBuilder: (context, index) {
                        DateTime myDateTime =
                            notificationData[index].notifDate.toDate();
                        String formattedDate = timeago.format(
                          myDateTime,
                          locale: 'en_short',
                        );
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ThreadRoomScreen2(
                                      threadID: notificationData[index]
                                          .topicForumScreen
                                          .forumID,
                                      threadTitle: notificationData[index]
                                          .topicForumScreen
                                          .forumTitle,
                                      threadDescription: notificationData[index]
                                          .topicForumScreen
                                          .forumDescription,
                                      creatorName: notificationData[index]
                                          .topicForumScreen
                                          .authorName,
                                      creatorSection: notificationData[index]
                                          .topicForumScreen
                                          .authorSection,
                                      formattedDate: notificationData[index]
                                          .topicForumScreen
                                          .forumDate,
                                      threadCreatorID: notificationData[index]
                                          .topicForumScreen
                                          .authorID,
                                      likersTokens: notificationData[index]
                                          .topicForumScreen
                                          .likersTokens
                                          .cast<String>(),
                                      authorToken: notificationData[index]
                                          .topicForumScreen
                                          .authorToken,
                                    )));
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * .05,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // const Divider(),
                                      Row(
                                        children: [
                                          Container(
                                            width: size.width / 1.2,
                                            child: Text(
                                              notificationData[index]
                                                  .notifTitle,
                                              style: const TextStyle(
                                                color: kMiddleColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: size.width / 1.3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  topicForumScreenList[index]
                                                      .forumTitle
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                ),
                                                filteredNotifs[index].comment ==
                                                        ''
                                                    ? Container()
                                                    : Text(
                                                        filteredNotifs[index]
                                                            .comment,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white60,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        softWrap: true,
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            formattedDate == 'now'
                                                ? formattedDate
                                                : formattedDate + '\n ago',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // const Divider(),
                                    ],
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: size.width * .05,
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 1,
                                color: context.read<ThemeProvider2>().isDark
                                    ? Colors.grey[800]
                                    : kPrimaryColor,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No data'),
                  );
                }
              },
            ),
            //top banner notifications
            Container(
              // It will cover 20% of our total height
              padding: const EdgeInsets.only(
                  // bottom: 12,
                  ),
              height: size.height / 2.5 - (size.height / 3.5),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        IconButton(
                          onPressed: _handleMenuButtonPressed,
                          icon: ValueListenableBuilder<AdvancedDrawerValue>(
                            valueListenable: context
                                .watch<AdvDrawerController>()
                                .advDrawerController,
                            builder: (_, value, __) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  value.visible
                                      ? Icons.arrow_back_ios
                                      : Icons.menu,
                                  color: Colors.white,
                                  key: ValueKey<bool>(value.visible),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: const [
                            Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    return AnimatedContainer(
      transform: Matrix4.translationValues(
          context.read<SwipeProvider2>().xOffset,
          context.read<SwipeProvider2>().yOffset,
          0)
        ..scale(context.read<SwipeProvider2>().scaleFactor)
        ..rotateY(context.read<SwipeProvider2>().isDrawerOpen ? -0.5 : 0),
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 21,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
      child: Scaffold(
        //=== BODY ===
        body: Stack(
          children: [
            _pages.elementAt(_selectedIndex),
            Container(
              margin: EdgeInsets.only(top: size.height - 50),
              child: CurvedNavigationBar(
                // color: kPrimaryColor,
                color: Theme.of(context).backgroundColor,
                height: size.height / 15,
                backgroundColor: Colors.transparent,
                items: <Widget>[
                  //FORUMS ICON
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      'assets/images/forums.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  //PERSONAL CHAT ICON
                  //make a separate widget for the icons or the yellow dot
                  //that has a parameter of stream where the notif count will
                  //base to appear or not.
                  //==========================
                  context.watch<NotificationProvider>().homeMsgNotifCount == 0
                      ? const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            FontAwesomeIcons.solidCommentAlt,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Stack(
                            children: [
                              const Icon(
                                FontAwesomeIcons.solidCommentAlt,
                                color: Colors.white,
                                size: 18,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 12,
                                ),
                                child: GFBadge(
                                  child: Text(context
                                      .watch<NotificationProvider>()
                                      .homeMsgNotifCount
                                      .toString()),
                                  shape: GFBadgeShape.circle,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),

                  //NOTIFICATIONS ICON
                  context.watch<NotificationProvider>().myNotifNow.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(
                            FontAwesomeIcons.solidBell,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Stack(
                            children: [
                              const Icon(
                                FontAwesomeIcons.solidBell,
                                color: Colors.white,
                                size: 18,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 12,
                                ),
                                child: GFBadge(
                                  child: Text(context
                                      .read<NotificationProvider>()
                                      .myNotifNow
                                      .length
                                      .toString()),
                                  shape: GFBadgeShape.circle,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
                onTap: (index) {
                  //Handle button tap
                  _onItemTapped(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    context.read<AdvDrawerController>().advDrawerController.showDrawer();
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: const EdgeInsets.all(2.0),
      avatar: const Icon(
        Icons.sort,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: const EdgeInsets.all(8.0),
    );
  }

  //NOTIFICATIONS
  Future<void> _sendAndRetrieveLike(String authorToken) async {
    // Go to Firebase console -> Project settings -> Cloud Messaging -> copy Server key
    // the Server key will start "AAAAMEjC64Y..."
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    const serverKey =
        'AAAApcnCYIw:APA91bHLAKGEAkAu9xl8nd4GC5OVYwR8Uu7jgjMrOSzzKzl81mfRXfYIZmdqmwCWUhO0nFusIJQrM_npC6bnkeEQjEZwFBqukIt4Ci5rrT2fGgw6w4qZUJxecVmIe9zqw5n7nsdlJOwF';
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': _myFname + ' ' + _myLname + ' liked your forum.',
            'title': 'Your forum got a like!',
            // 'image':
            //     'https://yt3.ggpht.com/ytc/AAUvwnjuH8xEOYQyRAE2NMrVieRw0GBbcJ9l5wLPpvgHDQ=s88-c-k-c0x00ffffff-no-rj'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          // FCM Token lists.

          'registration_ids': [authorToken],
        },
      ),
    );
  }

  Future<void> _sendAndRetrieveReport(String authorToken) async {
    // Go to Firebase console -> Project settings -> Cloud Messaging -> copy Server key
    // the Server key will start "AAAAMEjC64Y..."
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    const serverKey =
        'AAAApcnCYIw:APA91bHLAKGEAkAu9xl8nd4GC5OVYwR8Uu7jgjMrOSzzKzl81mfRXfYIZmdqmwCWUhO0nFusIJQrM_npC6bnkeEQjEZwFBqukIt4Ci5rrT2fGgw6w4qZUJxecVmIe9zqw5n7nsdlJOwF';
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': _myFname + ' ' + _myLname + ' reported your forum.',
            'title': 'Your forum was reported',
            // 'image':
            //     'https://yt3.ggpht.com/ytc/AAUvwnjuH8xEOYQyRAE2NMrVieRw0GBbcJ9l5wLPpvgHDQ=s88-c-k-c0x00ffffff-no-rj'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          // FCM Token lists.

          'registration_ids': [authorToken],
        },
      ),
    );
  }

  Future<void> _sendPostNotif() async {
    // Go to Firebase console -> Project settings -> Cloud Messaging -> copy Server key
    // the Server key will start "AAAAMEjC64Y..."
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    const serverKey =
        'AAAApcnCYIw:APA91bHLAKGEAkAu9xl8nd4GC5OVYwR8Uu7jgjMrOSzzKzl81mfRXfYIZmdqmwCWUhO0nFusIJQrM_npC6bnkeEQjEZwFBqukIt4Ci5rrT2fGgw6w4qZUJxecVmIe9zqw5n7nsdlJOwF';
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': _myFname + ' ' + _myLname + ' just posted.',
            'title': 'Check it out!',
            // 'image':
            //     'https://yt3.ggpht.com/ytc/AAUvwnjuH8xEOYQyRAE2NMrVieRw0GBbcJ9l5wLPpvgHDQ=s88-c-k-c0x00ffffff-no-rj'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          // FCM Token lists.

          'registration_ids':
              context.read<PostNotifProvider>().collegeMatesTokens,
        },
      ),
    );
  }
}
