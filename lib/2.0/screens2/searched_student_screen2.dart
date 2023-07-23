import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/directmessage_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/directmessagescontent_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/keep_alive_provider.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/notfuturedetails_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/search_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/studentnumber_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/directmessages_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/homescreen_component/empty_block_members.dart';
import 'package:usapp_mobile/2.0/screens2/homescreen_component/searchbar_members.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/upload_image/upload_image_provider.dart';
import 'package:usapp_mobile/2.0/screens2/reload_try/reload.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/view_profile_screen2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/models/account.dart';
import 'package:usapp_mobile/models/student.dart';

class SearchedStudentScreen2 extends StatefulWidget {
  String searchText;
  SearchedStudentScreen2({Key? key, required this.searchText})
      : super(key: key);

  @override
  _SearchedStudentScreen2State createState() => _SearchedStudentScreen2State();
}

class _SearchedStudentScreen2State extends State<SearchedStudentScreen2>
    with AutomaticKeepAliveClientMixin<SearchedStudentScreen2> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;
  // => _isVisited;
  FirestoreService2 firestoreService2 = FirestoreService2();
  late Stream<List<StudentNumber>> _streamMembers;
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
  late String _myToken = '';
  late String _myAbout = '';

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
    String? myAbout = await context.read<LocalDataProvider2>().getLocalAbout();
    String? myToken = await context.read<LocalDataProvider2>().getDeviceToken();

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
      _myYearLevel = myYearLvl;
      _mySection = mySection;
      _myYearSec = myYearSec;
      _myPhoto = myPhoto!;
      _myStudentNumber = myStudentNumber!;
      _myAbout = myAbout!;
      _myToken = myToken!;
    });
  }

  @override
  void initState() {
    _getDetailsFromLocal();
    _streamMembers = firestoreService2.fetchMembers();
    setState(() {
      _isVisited = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
        // color: Colors.grey[200],
        // borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 21,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Results for "' + widget.searchText + '"'),
        ),
        body: StreamBuilder(
          stream: _streamMembers,
          builder: (context, AsyncSnapshot<List<StudentNumber>> snapshot) {
            if (snapshot.hasData) {
              String getConversationID(String userID, String peerID) {
                return userID.hashCode <= peerID.hashCode
                    ? userID + '_' + peerID
                    : peerID + '_' + userID;
              }

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: context.read<SearchProvider2>().studentSearchText ==
                            ''
                        ? GFShimmer(
                            child: const Center(
                              child: EmptyBlockMembers(),
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
                          )
                        : Container(
                            margin: EdgeInsets.only(
                              top: size.height / 30,
                            ),
                            padding: const EdgeInsets.only(
                              // top: size.height / 3,
                              left: 14,
                              right: 14,
                            ),
                            height: size.height,
                            width: size.width,
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  StudentNumber dataStudent;
                                  dataStudent = snapshot.data![index];
                                  String dataStudentYearSec =
                                      dataStudent.course +
                                          ' ' +
                                          dataStudent.yearLvl.toString() +
                                          '-' +
                                          dataStudent.section.toString();
                                  String convoID = getConversationID(
                                      _myEmail, snapshot.data![index].email);
                                  return context
                                              .read<SearchProvider2>()
                                              .studentSearchText ==
                                          (dataStudent.firstName +
                                              ' ' +
                                              dataStudent.lastName)
                                      ? dataStudent.studentNumber ==
                                              _myStudentNumber
                                          ? GFListTile(
                                              padding: EdgeInsets.all(12),
                                              color: context
                                                      .read<ThemeProvider2>()
                                                      .isDark
                                                  ? kMiddleColor
                                                  : kMiddleColor,
                                              avatar: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(50),
                                                ),
                                                child: dataStudent.photoUrl !=
                                                        ''
                                                    ? Image.network(
                                                        dataStudent.photoUrl,
                                                        height: 40,
                                                        width: 40,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Initicon(
                                                        text: dataStudent
                                                                .firstName +
                                                            ' ' +
                                                            dataStudent
                                                                .lastName),
                                              ),
                                              titleText: dataStudent.firstName +
                                                  ' ' +
                                                  dataStudent.lastName +
                                                  ' (You)',
                                              subTitleText: dataStudentYearSec,
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                //update sender details on provider
                                                context
                                                    .read<
                                                        DirectMessageProvider2>()
                                                    .changeSenderEmail = _myEmail;
                                                context
                                                        .read<
                                                            DirectMessageProvider2>()
                                                        .changeSenderName =
                                                    (_myFname + ' ' + _myLname);
                                                context
                                                        .read<
                                                            DirectMessageProvider2>()
                                                        .changeSenderYearSec =
                                                    _myYearSec;
                                                context
                                                        .read<
                                                            DirectMessageProvider2>()
                                                        .changeSenderPhotoUrl =
                                                    _myPhoto;
                                                context
                                                        .read<
                                                            DirectMessageProvider2>()
                                                        .changeSenderID =
                                                    _myStudentNumber;

                                                context
                                                    .read<
                                                        DirectMessageProvider2>()
                                                    .changeSenderToken = _myToken;
                                                //update reciever details on provider
                                                context
                                                        .read<
                                                            DirectMessageProvider2>()
                                                        .changeRecieverEmail =
                                                    dataStudent.email;
                                                context
                                                        .read<
                                                            DirectMessageProvider2>()
                                                        .changeRecieverName =
                                                    (dataStudent.firstName +
                                                        ' ' +
                                                        dataStudent.lastName);
                                                context
                                                        .read<
                                                            DirectMessageProvider2>()
                                                        .changeRecieverID =
                                                    dataStudent.studentNumber;
                                                context
                                                        .read<
                                                            DirectMessageProvider2>()
                                                        .changeRecieverYearSec =
                                                    dataStudentYearSec;
                                                context
                                                        .read<
                                                            DirectMessageProvider2>()
                                                        .changeRecieverPhotoUrl =
                                                    dataStudent.photoUrl;
                                                context
                                                        .read<
                                                            DirectMessageProvider2>()
                                                        .changeRecieverToken =
                                                    dataStudent.deviceToken;
                                                //
                                                context
                                                    .read<
                                                        DirectMessageProvider2>()
                                                    .changeDmID = convoID;
                                                //
                                                context
                                                    .read<
                                                        DirectMessageProvider2>()
                                                    .changePeer = StudentNumber(
                                                  studentNumber:
                                                      dataStudent.studentNumber,
                                                  lastName:
                                                      dataStudent.lastName,
                                                  firstName:
                                                      dataStudent.firstName,
                                                  mInitial:
                                                      dataStudent.mInitial,
                                                  college: dataStudent.college,
                                                  course: dataStudent.course,
                                                  email: dataStudent.email,
                                                  isused: dataStudent.isused,
                                                  yearLvl: dataStudent.yearLvl,
                                                  section: dataStudent.section,
                                                  photoUrl: snapshot
                                                      .data![index].photoUrl,
                                                  about: snapshot
                                                      .data![index].about,
                                                  deviceToken: snapshot
                                                      .data![index].deviceToken,
                                                  isEnabled: snapshot
                                                      .data![index].isEnabled,
                                                );
                                                context
                                                    .read<
                                                        DirectMessageProvider2>()
                                                    .saveDirectMessageCollection();
                                                context
                                                    .read<
                                                        DirectMessageProvider2>()
                                                    .changeUser = StudentNumber(
                                                  studentNumber:
                                                      _myStudentNumber,
                                                  lastName: _myLname,
                                                  firstName: _myFname,
                                                  mInitial: _myMinitial,
                                                  college: _myCollege,
                                                  course: _myCourse,
                                                  email: _myEmail,
                                                  isused: true,
                                                  yearLvl: dataStudent.yearLvl,
                                                  section: dataStudent.section,
                                                  photoUrl: _myPhoto,
                                                  about: _myAbout,
                                                  deviceToken: _myToken,
                                                  isEnabled: snapshot
                                                      .data![index].isEnabled,
                                                );

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DirectMessageScreen2(
                                                        senderName: _myFname +
                                                            ' ' +
                                                            _myLname,
                                                        senderYearSec:
                                                            _myYearSec,
                                                        senderPhotoUrl:
                                                            _myPhoto,
                                                        senderEmail: _myEmail,
                                                        recieverName:
                                                            dataStudent
                                                                    .firstName +
                                                                ' ' +
                                                                dataStudent
                                                                    .lastName,
                                                        recieverYearSec:
                                                            dataStudentYearSec,
                                                        recieverPhotoUrl:
                                                            dataStudent
                                                                .photoUrl,
                                                        receiverEmail:
                                                            dataStudent.email,
                                                        senderToken: _myToken,
                                                        recieverToken:
                                                            dataStudent
                                                                .deviceToken,
                                                        convoID: convoID,
                                                      ),
                                                    ));
                                              },
                                              child: GFListTile(
                                                padding: EdgeInsets.all(12),
                                                color: context
                                                        .read<ThemeProvider2>()
                                                        .isDark
                                                    ? Colors.white
                                                    : Colors.white,
                                                avatar: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(50),
                                                  ),
                                                  child: dataStudent.photoUrl !=
                                                          ''
                                                      ? Image.network(
                                                          dataStudent.photoUrl,
                                                          height: 40,
                                                          width: 40,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Initicon(
                                                          text: dataStudent
                                                                  .firstName +
                                                              ' ' +
                                                              dataStudent
                                                                  .lastName),
                                                ),
                                                titleText:
                                                    dataStudent.firstName +
                                                        ' ' +
                                                        dataStudent.lastName,
                                                subTitleText:
                                                    dataStudentYearSec,
                                              ),
                                            )
                                      : Container();
                                }),
                          ),
                  ),
                ],
              );
            } else {
              return GFShimmer(
                child: const Center(
                  child: EmptyBlockMembers(),
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
          },
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    context.read<AdvDrawerController>().advDrawerController.showDrawer();
  }
}
