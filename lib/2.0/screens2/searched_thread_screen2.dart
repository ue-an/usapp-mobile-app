import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/report_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/search_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/thread_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/authentication/create_acct_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/homescreen_component/empty_block.dart';
import 'package:usapp_mobile/2.0/screens2/homescreen_component/empty_block_searchedthreads.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/profile_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/threadroom_screen2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/models/student.dart';
import 'package:usapp_mobile/models/thread.dart';

class SearchedThreadScreen2 extends StatefulWidget {
  String searchText;
  SearchedThreadScreen2({
    Key? key,
    required this.searchText,
  }) : super(key: key);

  @override
  _SearchedThreadScreen2State createState() => _SearchedThreadScreen2State();
}

class _SearchedThreadScreen2State extends State<SearchedThreadScreen2>
    with AutomaticKeepAliveClientMixin<SearchedThreadScreen2> {
  @override
  bool get wantKeepAlive => true;
  int _selectedIndex = 0; //New
  FirestoreService2 firestoreService2 = FirestoreService2();
  late Stream<List<Thread>> _streamThread;
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
  late String _searchText = '';
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
    String? myYearSec = myYearLvl!.toString() + '-' + mySection!.toString();
    String? myPhoto =
        await context.read<LocalDataProvider2>().getLocalStudentPhoto();
    String? myStudentNumber =
        await context.read<LocalDataProvider2>().getLocalStudentNumber();
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
    _storeDetailsOnLocal();
    _streamThread = firestoreService2.fetchThreads();
    // _streamCurrentStudent = firestoreService2.getCurrentStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Results ' + '"' + widget.searchText + '"'),
        actions: [
          IconButton(
            onPressed: () {
              //nav pop: back to previous screen (home)
              Navigator.of(context).pop();
              context.read<SearchProvider2>().changeThrSearchText = '';
            },
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: StreamBuilder<List<Thread>>(
          stream: _streamThread,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data!
                  .sort((a, b) => b.likers.length.compareTo(a.likers.length));
              List titles = [];
              for (var item in snapshot.data!) {
                titles.add(item.title);
              }
              return Scaffold(
                body: context.watch<SearchProvider2>().thrSearchText == ''
                    ? GFShimmer(
                        child: const Center(
                          child: EmptyBlockSearchedThreads(),
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
                          top: size.height / 90,
                          bottom: size.height / 12,
                        ),
                        padding: const EdgeInsets.only(
                          // top: size.height / 3,
                          left: 14,
                          right: 14,
                        ),
                        // height: size.height,
                        width: size.width,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            List likers = snapshot.data![index].likers;
                            DateTime myDateTime =
                                snapshot.data![index].tSdate.toDate();
                            String formattedDate =
                                DateFormat('yyyy-MM-dd – KK:mm a (EEE)')
                                    .format(myDateTime);
                            if (snapshot.data![index].college == _myCollege) {
                              if (snapshot.data![index].isDeletedByOwner ==
                                  false) {
                                if (snapshot.data![index].title ==
                                    context
                                        .read<SearchProvider2>()
                                        .thrSearchText) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ThreadRoomScreen2(
                                                    threadID: snapshot
                                                        .data![index].id,
                                                    threadTitle: snapshot
                                                        .data![index].title,
                                                    threadDescription: snapshot
                                                        .data![index]
                                                        .description,
                                                    creatorName: snapshot
                                                        .data![index]
                                                        .creatorName,
                                                    creatorSection: snapshot
                                                        .data![index]
                                                        .creatorSection,
                                                    formattedDate:
                                                        formattedDate,
                                                    threadCreatorID: snapshot
                                                        .data![index].studID,
                                                    likersTokens: snapshot
                                                        .data![index]
                                                        .likersTokens
                                                        .cast<String>(),
                                                    authorToken: snapshot
                                                        .data![index]
                                                        .authorToken,
                                                  )));
                                    },
                                    child: GFCard(
                                      margin: EdgeInsets.only(
                                        top: size.height / 150,
                                        bottom: 5,
                                      ),
                                      showImage: true,
                                      title: GFListTile(
                                        avatar: GFAvatar(
                                            backgroundImage: (() {
                                          for (var i = 0;
                                              i < snapshot.data!.length;
                                              i++) {
                                            if (_myCollege.toUpperCase() ==
                                                'CCS') {
                                              return const AssetImage(
                                                  'assets/images/ic_ccs-logo.png');
                                            }
                                            if (_myCollege
                                                    .toUpperCase()
                                                    .toUpperCase() ==
                                                'COA') {
                                              return const AssetImage(
                                                  'assets/images/ic_coa-logo.png');
                                            }
                                            if (_myCollege
                                                    .toUpperCase()
                                                    .toUpperCase() ==
                                                'COB') {
                                              return const AssetImage(
                                                  'assets/images/ic_cob-logo.png');
                                            }
                                          }

                                          return const AssetImage('');
                                        }())),
                                        title: Text(
                                          snapshot.data![index].title
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        subTitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index]
                                                      .creatorName +
                                                  ', ' +
                                                  snapshot.data![index]
                                                      .creatorSection,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              formattedDate,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      content: Text(
                                          snapshot.data![index].description),
                                      buttonBar: GFButtonBar(
                                        children: [
                                          Row(
                                            children: [
                                              likers.contains(_myEmail)
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              'You unlike this thread'),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  1000),
                                                        ));
                                                        context
                                                            .read<
                                                                ThreadProvider2>()
                                                            .unLike(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .id,
                                                                _myEmail);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          GFAvatar(
                                                            size: GFSize.SMALL,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: Icon(
                                                              Icons
                                                                  .thumb_up_alt,
                                                              color: context
                                                                      .read<
                                                                          ThemeProvider2>()
                                                                      .isDark
                                                                  ? Colors
                                                                      .lightBlue
                                                                  : kPrimaryColor,
                                                            ),
                                                          ),
                                                          likers.length <= 1
                                                              ? Text('Liked (' +
                                                                  likers.length
                                                                      .toString() +
                                                                  ' like)')
                                                              : Text('Liked (' +
                                                                  likers.length
                                                                      .toString() +
                                                                  ' likes)'),
                                                        ],
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              'You liked this thread'),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  1000),
                                                        ));
                                                        context
                                                            .read<
                                                                ThreadProvider2>()
                                                            .saveLike(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .id,
                                                                _myEmail);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const GFAvatar(
                                                            size: GFSize.SMALL,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: Icon(
                                                              Icons
                                                                  .thumb_up_alt,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          // Text('Like (' +
                                                          //     likers.length
                                                          //         .toString() +
                                                          //     ' likes)'),
                                                          likers.length <= 1
                                                              ? Text('Like (' +
                                                                  likers.length
                                                                      .toString() +
                                                                  ' like)')
                                                              : Text('Like (' +
                                                                  likers.length
                                                                      .toString() +
                                                                  ' likes)'),
                                                        ],
                                                      ),
                                                    ),
                                              const Spacer(),
                                              snapshot.data![index]
                                                      .reportersEmail
                                                      .contains(_myEmail)
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(20.0))),
                                                                content:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            ListBody(
                                                                          children: <
                                                                              Widget>[
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
                                                                                    'You already reported this thread. Wait for the admin approval',
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: <
                                                                              Widget>[
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
                                                          const Text(
                                                              'Reported'),
                                                          GFAvatar(
                                                            size: GFSize.SMALL,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: Icon(
                                                              Icons.error,
                                                              color: Colors
                                                                  .grey[700],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20.0))),
                                                              content: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          ListBody(
                                                                        children: <
                                                                            Widget>[
                                                                          Row(
                                                                            children: const [
                                                                              Icon(
                                                                                FontAwesomeIcons.exclamationCircle,
                                                                                color: kPrimaryColor,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 12,
                                                                              ),
                                                                              Text('Report Thread'),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                21,
                                                                          ),
                                                                          Row(
                                                                            children: const [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  'Are you sure this thread violates UsApp\'s terms and conditions?',
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                21,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: <
                                                                            Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                RaisedButton(
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
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                RaisedButton(
                                                                              color: kPrimaryColor,
                                                                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
                                                                              child: const Text(
                                                                                "REPORT",
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                              onPressed: () {
                                                                                if (reason != null) {
                                                                                  print('not null!');
                                                                                  //data from thread
                                                                                  String reportID = snapshot.data![index].id; //threadID for reportID as well
                                                                                  String thrTitle = snapshot.data![index].title;
                                                                                  String thrCreatorID = snapshot.data![index].id;
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
                                                                                      reportProvider.addReportFields();
                                                                                      reportProvider.clickNow();
                                                                                      Navigator.of(context).pop();
                                                                                    }
                                                                                  } else {
                                                                                    reportProvider.saveReport();
                                                                                    reportProvider.clickNow();
                                                                                    Navigator.of(context).pop();
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
                                                                                                              'Tell us the reason for reporting this thread',
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
                                                          const Text('Report'),
                                                          GFAvatar(
                                                            size: GFSize.SMALL,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: Icon(
                                                              Icons
                                                                  .error_outline,
                                                              color: context
                                                                      .watch<
                                                                          ThemeProvider2>()
                                                                      .isDark
                                                                  ? Colors
                                                                      .red[400]
                                                                  : Colors.red,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          },
                        ),
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
          }),
    );
  }
}
