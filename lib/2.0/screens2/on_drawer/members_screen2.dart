import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/directmessage_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/directmessagescontent_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/keep_alive_provider.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/notfuturedetails_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/post_notif_provider.dart';
import 'package:usapp_mobile/2.0/providers2/search_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/studentnumber_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/directmessages_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/homescreen_component/empty_block_members.dart';
import 'package:usapp_mobile/2.0/screens2/homescreen_component/searchbar_members.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/profile_screen2.dart';
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

class MembersScreen2 extends StatefulWidget {
  const MembersScreen2({Key? key}) : super(key: key);

  @override
  _MembersScreen2State createState() => _MembersScreen2State();
}

class _MembersScreen2State extends State<MembersScreen2>
    with AutomaticKeepAliveClientMixin<MembersScreen2> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;
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
      _myCompletionYear = myCompletionYear;
    });
  }

  @override
  void initState() {
    // _getDetailsFromLocal();
    _storeDetailsOnLocal();
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
            offset: const Offset(0, 1),
            blurRadius: 21,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
      child: Scaffold(
        body: StreamBuilder<List<StudentNumber>>(
          stream: _streamMembers,
          builder: (context, AsyncSnapshot<List<StudentNumber>> snapshot) {
            if (snapshot.hasData) {
              List membersNames = [];
              for (var member in snapshot.data!) {
                membersNames.add((member.firstName + ' ' + member.lastName));
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
                      top: size.height / 6,
                    ),
                    padding: EdgeInsets.only(
                      top: size.height * .027,
                      // top: 30,
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
                          String dataStudentYearSec = dataStudent.course +
                              ' ' +
                              dataStudent.yearLvl.toString() +
                              '-' +
                              dataStudent.section.toString();
                          String convoID =
                              getConversationID(_myEmail, dataStudent.email);
                          if (dataStudent.college == _myCollege) {
                            context
                                .read<PostNotifProvider>()
                                .collegeMatesTokens
                                .add(dataStudent.deviceToken);
                          }

                          return dataStudent.studentNumber == _myStudentNumber
                              ? GFListTile(
                                  padding: const EdgeInsets.all(12),
                                  color: context.read<ThemeProvider2>().isDark
                                      ? kMiddleColor
                                      : kMiddleColor,
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

                              // : FutureBuilder(
                              //     future: context
                              //         .read<LocalDataProvider2>()
                              //         .getLocalFirstName(),
                              //     builder: (context, snapshot) {
                              //       if (snapshot.hasData) {
                              //         return Text(_myFname);
                              //       } else {
                              //         return Container();
                              //       }
                              //     },
                              //   );
                              : GFListTile(
                                  padding: const EdgeInsets.all(12),
                                  color: context.read<ThemeProvider2>().isDark
                                      ? Colors.white
                                      : Colors.white,
                                  avatar: dataStudent.photoUrl == null ||
                                          dataStudent.photoUrl == ''
                                      ? Initicon(
                                          text: dataStudent.firstName +
                                              ' ' +
                                              dataStudent.lastName,
                                          size: 40,
                                        )
                                      : ClipRRect(
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
                                      Icons.more_horiz,
                                      color:
                                          context.read<ThemeProvider2>().isDark
                                              ? Colors.black
                                              : kPrimaryColor,
                                    ),
                                    itemBuilder: (BuildContext contesxt) {
                                      return [
                                        PopupMenuItem(
                                          child: GestureDetector(
                                            onTap: () async {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewProfileScreen2(
                                                  userEmail: dataStudent.email,
                                                  userName:
                                                      dataStudent.firstName +
                                                          ' ' +
                                                          dataStudent.lastName,
                                                  userSection:
                                                      dataStudentYearSec,
                                                  userPhoto:
                                                      dataStudent.photoUrl,
                                                  userCollege:
                                                      dataStudent.college,
                                                  userAbout: dataStudent.about,
                                                ),
                                              ));
                                              print(_myStudentNumber);
                                              print('sdsds');
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
                                            onTap: () async {
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
                                                  _myYearLevel >
                                                          _myCompletionYear
                                                      ? 'Alumnus'
                                                      : _myYearSec;
                                              context
                                                  .read<
                                                      DirectMessageProvider2>()
                                                  .changeSenderPhotoUrl = _myPhoto;
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
                                                lastName: dataStudent.lastName,
                                                firstName:
                                                    dataStudent.firstName,
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
                                                isEnabled:
                                                    dataStudent.isEnabled,
                                              );

                                              context
                                                  .read<
                                                      DirectMessageProvider2>()
                                                  .changeUser = StudentNumber(
                                                studentNumber: _myStudentNumber,
                                                lastName: _myLname,
                                                firstName: _myFname,
                                                mInitial: _myMinitial,
                                                college: _myCollege,
                                                course: _myCourse,
                                                email: _myEmail,
                                                isused: true,
                                                yearLvl: _myYearLevel,
                                                section: _mySection,
                                                photoUrl: _myPhoto,
                                                about: _myAbout,
                                                deviceToken: _myToken,
                                                isEnabled: true,
                                              );
                                              context
                                                  .read<
                                                      DirectMessageProvider2>()
                                                  .saveDirectMessageCollection();

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DirectMessageScreen2(
                                                      senderName: _myFname +
                                                          ' ' +
                                                          _myLname,
                                                      senderYearSec: _myYearLevel >
                                                              _myCompletionYear
                                                          ? 'Alumnus'
                                                          : _myYearSec,
                                                      senderPhotoUrl: _myPhoto,
                                                      senderEmail: _myEmail,
                                                      recieverName: dataStudent
                                                              .firstName +
                                                          ' ' +
                                                          dataStudent.lastName,
                                                      recieverYearSec:
                                                          dataStudentYearSec,
                                                      recieverPhotoUrl:
                                                          dataStudent.photoUrl,
                                                      receiverEmail:
                                                          dataStudent.email,
                                                      senderToken: _myToken,
                                                      recieverToken: dataStudent
                                                          .deviceToken,
                                                      convoID: convoID,
                                                    ),
                                                  ));
                                              // print(await context
                                              //     .read<LocalDataProvider2>()
                                              //     .getLocalFirstName());
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
                  //TOPBANNER CUSTOM APPBAR
                  Container(
                    // It will cover 20% of our total height

                    padding: const EdgeInsets.only(
                        // bottom: 12,
                        ),
                    // height: size.height / 2.3 - (size.height / 4.1),
                    // height: 180,
                    height: 159,
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
                                icon:
                                    ValueListenableBuilder<AdvancedDrawerValue>(
                                  valueListenable: context
                                      .watch<AdvDrawerController>()
                                      .advDrawerController,
                                  builder: (_, value, __) {
                                    return AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 250),
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
                                    'UsApp Users',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.userFriends,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: size.width / 7,
                              ),
                            ],
                          ),
                          GFSearchBar(
                            searchList: membersNames,
                            overlaySearchListItemBuilder: (name) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  name.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: context.read<ThemeProvider2>().isDark
                                        ? Colors.black
                                        : Colors.black,
                                  ),
                                ),
                              );
                            },
                            searchQueryBuilder:
                                (String searchText, membersList) {
                              return membersList
                                  .where((name) => name
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()))
                                  .toList();
                            },
                            onItemSelected: (name) {
                              if (name != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchedStudentScreen2(
                                              searchText: name.toString(),
                                            )));
                                context
                                    .read<SearchProvider2>()
                                    .changeStudSearchText = name.toString();
                              }
                            },
                          ),
                        ],
                      ),
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
