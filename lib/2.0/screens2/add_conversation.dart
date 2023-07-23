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
import 'package:usapp_mobile/2.0/screens2/searched_student_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/view_profile_screen2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/models/account.dart';
import 'package:usapp_mobile/models/student.dart';

class AddConversatioScreen2 extends StatefulWidget {
  const AddConversatioScreen2({Key? key}) : super(key: key);

  @override
  _AddConversatioScreen2State createState() => _AddConversatioScreen2State();
}

class _AddConversatioScreen2State extends State<AddConversatioScreen2>
    with AutomaticKeepAliveClientMixin<AddConversatioScreen2> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;
  // => _isVisited;
  FirestoreService2 firestoreService2 = FirestoreService2();
  late Stream<List<StudentNumber>> _streamMembers;
  late String _myStudentNumber = '';
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
  late String _myCourse = '';
  late String _myAbout = '';
  late String _myToken = '';
  void _getDetailsFromLocal() async {
    String? myStudentNumber =
        await context.read<LocalDataProvider2>().getLocalStudentNumber();
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
    String? myAbout = await context.read<LocalDataProvider2>().getLocalAbout();
    String? myToken = await context.read<LocalDataProvider2>().getDeviceToken();
    int myCompletionYear =
        await context.read<LocalDataProvider2>().getLocalCompletionYear();
    setState(() {
      _myEmail = myEmail!;
      _myCollege = myCollege!;
      _myCourse = myCourse;
      _myFname = myFname!;
      _myMinitial = myMinitial!;
      _myLname = myLname!;
      _myYearLevel = myYearLvl;
      _mySection = mySection;
      _myYearSec = myYearSec;
      _myPhoto = myPhoto!;
      _myStudentNumber = myStudentNumber!;
      _myAbout = myAbout!;
      _myToken = myToken!;
      _myCompletionYear = myCompletionYear;
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
    return Scaffold(
      backgroundColor: context.read<ThemeProvider2>().isDark
          ? Theme.of(context).backgroundColor
          : kMiddleColor,
      appBar: AppBar(
        title: const Text('Add to your personal chats'),
      ),
      body: StreamBuilder(
        stream: _streamMembers,
        builder: (context, AsyncSnapshot<List<StudentNumber>> snapshot) {
          if (snapshot.hasData) {
            List members = [];
            for (var member in snapshot.data!) {
              members.add((member.firstName + ' ' + member.lastName));
            }

            String getConversationID(String userID, String peerID) {
              return userID.hashCode <= peerID.hashCode
                  ? userID + '_' + peerID
                  : peerID + '_' + userID;
            }

            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: size.height / 10,
                  ),
                  padding: const EdgeInsets.only(
                    // top: size.height / 3,
                    left: 14,
                    right: 14,
                  ),
                  height: size.height,
                  width: size.width,
                  // child: context.watch<SearchProvider2>().studentSearchText ==
                  //         ''
                  //     ? Column(
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: const [Text('Search student')],
                  //           ),
                  //         ],
                  //       )
                  //     :
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        StudentNumber dataStudent;
                        String convoID = getConversationID(
                            _myEmail, snapshot.data![index].email);
                        List n = snapshot.data!
                            .where((student) =>
                                (student.firstName + ' ' + student.lastName)
                                    .toString()
                                    .toLowerCase()
                                    .contains(context
                                        .read<SearchProvider2>()
                                        .studentSearchText
                                        .toLowerCase()))
                            .toList();
                        dataStudent = snapshot.data![index];
                        String dataStudentYearSec = dataStudent.course +
                            ' ' +
                            dataStudent.yearLvl.toString() +
                            '-' +
                            dataStudent.section.toString();
                        return dataStudent.studentNumber == _myStudentNumber
                            ? GFListTile(
                                padding: EdgeInsets.all(12),
                                color: context.read<ThemeProvider2>().isDark
                                    ? kMiddleColor
                                    : kPrimaryColor.withOpacity(0.5),
                                avatar: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  child: dataStudent.photoUrl != ''
                                      ? Image.network(
                                          dataStudent.photoUrl,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        )
                                      : Initicon(
                                          text: dataStudent.firstName +
                                              ' ' +
                                              dataStudent.lastName),
                                ),
                                titleText: dataStudent.firstName +
                                    ' ' +
                                    dataStudent.lastName +
                                    ' (You)',
                                subTitleText:
                                    dataStudent.yearLvl > _myCompletionYear
                                        ? 'Alumnus'
                                        : dataStudentYearSec,
                              )
                            : GFListTile(
                                padding: EdgeInsets.all(12),
                                color: context.read<ThemeProvider2>().isDark
                                    ? Colors.white
                                    : Colors.white,
                                avatar: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  child: dataStudent.photoUrl != ''
                                      ? Image.network(
                                          dataStudent.photoUrl,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        )
                                      : Initicon(
                                          text: dataStudent.firstName +
                                              ' ' +
                                              dataStudent.lastName),
                                ),
                                titleText: dataStudent.firstName +
                                    ' ' +
                                    dataStudent.lastName,
                                subTitleText:
                                    dataStudent.yearLvl > _myCompletionYear
                                        ? 'Alumnus'
                                        : dataStudentYearSec,
                                icon: PopupMenuButton<String>(
                                  icon: Icon(
                                    // Icons.more_vert,
                                    Icons.more_horiz,
                                    color: context.read<ThemeProvider2>().isDark
                                        ? Colors.black
                                        : kPrimaryColor,
                                  ),
                                  itemBuilder: (BuildContext contesxt) {
                                    return [
                                      PopupMenuItem(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewProfileScreen2(
                                                userEmail: dataStudent.email,
                                                userName:
                                                    dataStudent.firstName +
                                                        ' ' +
                                                        dataStudent.lastName,
                                                userSection: dataStudentYearSec,
                                                userPhoto: dataStudent.photoUrl,
                                                userCollege:
                                                    dataStudent.college,
                                                userAbout: dataStudent.about,
                                              ),
                                            ));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text('View Profile'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: GestureDetector(
                                          onTap: () {
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
                                                .changeSenderToken = _myToken;
                                            // update reciever details on provider
                                            context
                                                    .read<DirectMessageProvider2>()
                                                    .changeRecieverEmail =
                                                dataStudent.email;
                                            context
                                                .read<DirectMessageProvider2>()
                                                .changeRecieverName = (dataStudent
                                                    .firstName +
                                                ' ' +
                                                dataStudent.lastName);
                                            context
                                                    .read<DirectMessageProvider2>()
                                                    .changeRecieverID =
                                                dataStudent.studentNumber;
                                            context
                                                    .read<DirectMessageProvider2>()
                                                    .changeRecieverYearSec =
                                                dataStudentYearSec;
                                            context
                                                    .read<DirectMessageProvider2>()
                                                    .changeRecieverPhotoUrl =
                                                dataStudent.photoUrl;
                                            context
                                                    .read<DirectMessageProvider2>()
                                                    .changeRecieverToken =
                                                dataStudent.deviceToken;
                                            //
                                            context
                                                .read<DirectMessageProvider2>()
                                                .changeDmID = convoID;
                                            //
                                            context
                                                .read<DirectMessageProvider2>()
                                                .changePeer = StudentNumber(
                                              studentNumber:
                                                  dataStudent.studentNumber,
                                              lastName: dataStudent.lastName,
                                              firstName: dataStudent.firstName,
                                              mInitial: dataStudent.mInitial,
                                              college: dataStudent.college,
                                              course: dataStudent.course,
                                              email: dataStudent.email,
                                              isused: dataStudent.isused,
                                              yearLvl: dataStudent.yearLvl,
                                              section: dataStudent.section,
                                              photoUrl: dataStudent.photoUrl,
                                              about: dataStudent.about,
                                              deviceToken:
                                                  dataStudent.deviceToken,
                                              isEnabled: dataStudent.isEnabled,
                                            );
                                            context
                                                .read<DirectMessageProvider2>()
                                                .saveDirectMessageCollection();
                                            context
                                                .read<DirectMessageProvider2>()
                                                .changeUser = StudentNumber(
                                              studentNumber: _myStudentNumber,
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
                                              isEnabled: true,
                                            );

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DirectMessageScreen2(
                                                    senderName: _myFname +
                                                        ' ' +
                                                        _myLname,
                                                    senderYearSec: _myYearSec,
                                                    senderPhotoUrl: _myPhoto,
                                                    senderEmail: _myEmail,
                                                    recieverName: snapshot
                                                            .data![index]
                                                            .firstName +
                                                        ' ' +
                                                        snapshot.data![index]
                                                            .lastName,
                                                    recieverYearSec:
                                                        dataStudentYearSec,
                                                    recieverPhotoUrl: snapshot
                                                        .data![index].photoUrl,
                                                    receiverEmail: snapshot
                                                        .data![index].email,
                                                    senderToken: _myToken,
                                                    recieverToken: snapshot
                                                        .data![index]
                                                        .deviceToken,
                                                    convoID: convoID,
                                                  ),
                                                ));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text('Send Message'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              );
                      }),
                ),
                GFSearchBar(
                    searchList: members,
                    overlaySearchListItemBuilder: (member) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          member.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            // context.read<ThemeProvider2>().isDark
                            //     ? Colors.black
                            //     : Colors.black,
                          ),
                        ),
                      );
                    },
                    searchQueryBuilder: (String searchText, membersList) {
                      return membersList
                          .where((name) => name
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase()))
                          .toList();
                    },
                    onItemSelected: (name) {
                      if (name != null) {
                        context
                            .read<DirectMessageProvider2>()
                            .changeSenderEmail = _myEmail;
                        context
                            .read<DirectMessageProvider2>()
                            .changeSenderName = (_myFname + ' ' + _myLname);
                        context
                            .read<DirectMessageProvider2>()
                            .changeSenderYearSec = _myYearSec;
                        context
                            .read<DirectMessageProvider2>()
                            .changeSenderPhotoUrl = _myPhoto;
                        context.read<DirectMessageProvider2>().changeSenderID =
                            _myStudentNumber;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchedStudentScreen2(
                                    searchText: name.toString())));
                        context.read<SearchProvider2>().changeStudSearchText =
                            name.toString();
                      }
                    }),
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 20,
                //   ),
                //   child: TextFormField(
                //     onChanged: (value) => context
                //         .read<SearchProvider2>()
                //         .changeStudSearchText = value,
                //     decoration: InputDecoration(
                //       suffixIcon: const Icon(
                //         Icons.search,
                //         color: kPrimaryColor,
                //       ),
                //     ),
                //   ),
                // ),
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
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    context.read<AdvDrawerController>().advDrawerController.showDrawer();
  }
}
