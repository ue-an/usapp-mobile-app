import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:usapp_mobile/2.0/models/push_notification.dart';
import 'package:usapp_mobile/2.0/models/replyer.dart';
import 'package:usapp_mobile/2.0/models/thread_message.dart';
import 'package:usapp_mobile/2.0/models/thread_reply.dart';
import 'package:usapp_mobile/2.0/providers2/activity_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/report_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/thread_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/threadmessage_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/threadreply_provider.dart';
import 'package:usapp_mobile/2.0/screens2/homescreen_component/empty_block.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/upload_image/upload_image_provider.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_provider.dart';
import 'package:usapp_mobile/2.0/screens2/replies_widget.dart';
import 'package:usapp_mobile/2.0/screens2/show_replies_button_widget.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:usapp_mobile/models/thread.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
//
import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:http/http.dart' as http;

class ThreadRoomScreen2 extends StatefulWidget {
  String threadID;
  String threadTitle;
  String threadDescription;
  String creatorName;
  String creatorSection;
  String formattedDate;
  String threadCreatorID;
  List<String> likersTokens;
  String authorToken;
  ThreadRoomScreen2({
    Key? key,
    required this.threadID,
    required this.threadTitle,
    required this.threadDescription,
    required this.creatorName,
    required this.creatorSection,
    required this.formattedDate,
    required this.threadCreatorID,
    required this.likersTokens,
    required this.authorToken,
  }) : super(key: key);

  @override
  State<ThreadRoomScreen2> createState() => _ThreadRoomScreen2State();
}

class _ThreadRoomScreen2State extends State<ThreadRoomScreen2>
    with AutomaticKeepAliveClientMixin<ThreadRoomScreen2> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;
  get fetchLocalDataProvider2 => null;
  final _formKey = GlobalKey<FormState>();
  TextEditingController threadMessageContentCtrl = TextEditingController();
  TextEditingController replyCtrl = TextEditingController();
  FirestoreService2 firestoreService2 = FirestoreService2();
  late Stream<List<ThreadMessage>> _streamThreadMessage;
  late String _myStudentNumber = '';
  late Stream<List<Thread>> _streamThread;
  late String _myEmail = '';
  late int _myYearLvl = 0;
  late int _mySection = 0;
  late int _myCompletionYear = 0;
  late String _myYearSec = '';
  late String _myFullname = '';
  late String _myCourse = '';
  late String _myDeviceToken = '';
  late final FirebaseMessaging _firebaseMessaging;
  // List<String> sendTokens = [];
  // late int _totalNotificationCounter;
  // int _increment = 0;
  List<String> reasons = [
    'Cheating source',
    'Violent/Abusive words',
    'Sexual Harrassment'
  ];
  // List<String> years = [];
  String? option, reason;
  //------------------------------------------------------------------
  ///Default text to be shown initially
  // String _text = 'This is the default text';

  ///This is the sender's name
  // String myName = 'Annsh Singh';

  ///List of all the names in the group - Assuming here that you get this list in chat window
  late List<String> otherNamesList = [
    // 'Annsh Singh',
    // 'Michael Scott',
    // 'Dwight Schrute',
    // "Jim Halpert"
  ];

  late TextEditingController _textController;
  late FocusNode _focusNode;
  //------------------------------------------------------------------
  _launchURL(String commentUrl) async {
    final url = commentUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _storeDetailsOnLocal() async {
    String? myStudentNumber =
        await context.read<LocalDataProvider2>().getLocalStudentNumber();
    String? myEmail = await context.read<LocalDataProvider2>().getLocalEmail();
    String? myCourse =
        await context.read<LocalDataProvider2>().getLocalCourse();
    int? myYearLvl =
        await context.read<LocalDataProvider2>().getLocalYearLevel();
    int? mySection = await context.read<LocalDataProvider2>().getLocalSection();
    int myCompletionYear =
        await context.read<LocalDataProvider2>().getLocalCompletionYear();
    String? myYearSec =
        myCourse! + ' ' + myYearLvl!.toString() + '-' + mySection!.toString();
    String? myFullName =
        await context.read<LocalDataProvider2>().getLocalFullName();

    String? myDeviceToken =
        await context.read<LocalDataProvider2>().getDeviceToken();
    setState(() {
      _myStudentNumber = myStudentNumber!;
      _myEmail = myEmail!;
      _myFullname = myFullName!;
      _myCourse = myCourse;
      _myYearLvl = myYearLvl;
      _mySection = mySection;
      _myYearSec = myYearSec;
      _myDeviceToken = myDeviceToken!;
      _myCompletionYear = myCompletionYear;
    });
  }

  checkForInitialMessage() async {
    // int newVal = _increment += 1;
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification!.title,
        body: initialMessage.notification!.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
      // context.read<NotificationProvider>().pushNotification = notification;
      // context.read<NotificationProvider>().totalNotificationCounter = newVal;
    }
  }

  @override
  void initState() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _streamThread = firestoreService2.fetchThreads();
    _streamThreadMessage =
        firestoreService2.fetchThreadMessages(widget.threadID);
    context.read<ThreadReplyProvider>().changethrMessageID = '';
    _storeDetailsOnLocal();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // int newVal = _increment += 1;
      PushNotification notification = PushNotification(
        title: message.notification!.title,
        body: message.notification!.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
      //normal notification
      context.read<NotificationProvider>().registerNotification();
      //when app is terminated
      checkForInitialMessage();
      context.read<NotificationProvider>().pushNotification = notification;
    });
    setState(() {
      _isVisited = true;
    });
    _textController = TextEditingController();
    _focusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Discussion'),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<ThreadMessage>>(
            stream: _streamThreadMessage,
            builder: (context, commentSnap) {
              if (commentSnap.hasData) {
                //fill othersListNames (mention names)
                commentSnap.data!.forEach((comment) {
                  otherNamesList.add(comment.thrSenderName);
                  //
                });
                //

                return Container(
                  padding: EdgeInsets.only(
                    bottom: size.height * .10,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: StreamBuilder<List<Thread>>(
                            stream: _streamThread,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                for (var i = 0;
                                    i < snapshot.data!.length;
                                    i++) {
                                  if (snapshot.data![i].title ==
                                      widget.threadTitle) {
                                    List likers = snapshot.data![i].likers;
                                    return GFCard(
                                      margin: EdgeInsets.only(
                                        top: size.height / 150,
                                        bottom: 5,
                                      ),
                                      showImage: true,
                                      title: GFListTile(
                                        title: Text(
                                          widget.threadTitle.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        subTitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.creatorName +
                                                  ', ' +
                                                  widget.creatorSection,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              widget.formattedDate,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      content: Text(widget.threadDescription),
                                      buttonBar: GFButtonBar(
                                        children: [
                                          Row(
                                            children: [
                                              likers.contains(_myEmail)
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              'You unlike this forum'),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  1000),
                                                        ));
                                                        //remove from likers
                                                        await context
                                                            .read<
                                                                ThreadProvider2>()
                                                            .unLike(
                                                                snapshot
                                                                    .data![i]
                                                                    .id,
                                                                _myEmail);
                                                        //remove myToken from likersTokens
                                                        await context
                                                            .read<
                                                                ThreadProvider2>()
                                                            .removeUnlikerToken(
                                                                snapshot
                                                                    .data![i]
                                                                    .id,
                                                                _myDeviceToken);
                                                        //remove myStudentNumber(ID) from likers_ids
                                                        await context
                                                            .read<
                                                                ThreadProvider2>()
                                                            .removeLikerID(
                                                                snapshot
                                                                    .data![i]
                                                                    .id,
                                                                _myStudentNumber);
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
                                                              ? Text(likers
                                                                      .length
                                                                      .toString() +
                                                                  ' like')
                                                              : Text(likers
                                                                      .length
                                                                      .toString() +
                                                                  ' likes'),
                                                        ],
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Text(
                                                              'You liked this forum'),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  1000),
                                                        ));
                                                        //add user to likers
                                                        await context
                                                            .read<
                                                                ThreadProvider2>()
                                                            .saveLike(
                                                                snapshot
                                                                    .data![i]
                                                                    .id,
                                                                _myEmail);
                                                        //add user token to liekrs tokens
                                                        await context
                                                            .read<
                                                                ThreadProvider2>()
                                                            .saveLikerToken(
                                                                snapshot
                                                                    .data![i]
                                                                    .id,
                                                                _myDeviceToken);
                                                        //add mystudentNumber(ID) to likers_ids
                                                        await context
                                                            .read<
                                                                ThreadProvider2>()
                                                            .saveLikerID(
                                                              snapshot
                                                                  .data![i].id,
                                                              _myStudentNumber,
                                                            );
                                                        //send like notif to author and notif object
                                                        snapshot.data![i]
                                                                    .authorToken ==
                                                                _myDeviceToken
                                                            ? null
                                                            : await _sendAndRetrieveLike(
                                                                snapshot
                                                                    .data![i]
                                                                    .authorToken);
                                                        //create activity
                                                        snapshot.data![i]
                                                                    .studID ==
                                                                _myStudentNumber
                                                            ? context
                                                                .read<
                                                                    ActivityProvider2>()
                                                                .createActivity(
                                                                  widget
                                                                      .threadID,
                                                                  widget
                                                                      .threadTitle,
                                                                  widget
                                                                      .threadDescription,
                                                                  widget
                                                                      .formattedDate,
                                                                  widget
                                                                      .threadCreatorID,
                                                                  widget
                                                                      .creatorName,
                                                                  widget
                                                                      .creatorSection,
                                                                  widget
                                                                      .authorToken,
                                                                  widget
                                                                      .likersTokens
                                                                      .cast<
                                                                          String>(),
                                                                  'You liked your forum',
                                                                  _myEmail,
                                                                  '',
                                                                )
                                                            : context
                                                                .read<
                                                                    ActivityProvider2>()
                                                                .createActivity(
                                                                  widget
                                                                      .threadID,
                                                                  widget
                                                                      .threadTitle,
                                                                  widget
                                                                      .threadDescription,
                                                                  widget
                                                                      .formattedDate,
                                                                  widget
                                                                      .threadCreatorID,
                                                                  widget
                                                                      .creatorName,
                                                                  widget
                                                                      .creatorSection,
                                                                  widget
                                                                      .authorToken,
                                                                  widget
                                                                      .likersTokens
                                                                      .cast<
                                                                          String>(),
                                                                  'You liked a forum',
                                                                  _myEmail,
                                                                  '',
                                                                );
                                                        //create notification
                                                        context
                                                            .read<
                                                                NotificationProvider>()
                                                            .setNotification(
                                                              notifReceiverStudnum:
                                                                  widget
                                                                      .threadCreatorID,
                                                              myStudentnumber:
                                                                  _myStudentNumber,
                                                              myEmail: _myEmail,
                                                              forumID: widget
                                                                  .threadID,
                                                              forumDescription:
                                                                  widget
                                                                      .threadDescription,
                                                              forumDate: widget
                                                                  .formattedDate,
                                                              forumTitle: widget
                                                                  .threadTitle,
                                                              authorName: widget
                                                                  .creatorName,
                                                              authorSection: widget
                                                                  .creatorSection,
                                                              authorID: widget
                                                                  .threadCreatorID,
                                                              authorToken: widget
                                                                  .authorToken,
                                                              likersTokens: widget
                                                                  .likersTokens,
                                                              title: _myFullname +
                                                                  ' liked your forum',
                                                              comment: '',
                                                            );
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
                                                              ? Text(likers
                                                                      .length
                                                                      .toString() +
                                                                  ' like')
                                                              : Text(likers
                                                                      .length
                                                                      .toString() +
                                                                  ' likes'),
                                                        ],
                                                      ),
                                                    ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  const GFAvatar(
                                                    size: GFSize.SMALL,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Icon(
                                                      Icons
                                                          .mode_comment_outlined,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(snapshot.data![i]
                                                              .msgSent >
                                                          1
                                                      ? snapshot
                                                              .data![i].msgSent
                                                              .toString() +
                                                          ' comments'
                                                      : snapshot
                                                              .data![i].msgSent
                                                              .toString() +
                                                          ' comment'),
                                                ],
                                              ),
                                              const Spacer(),
                                              snapshot.data![i].studID ==
                                                      _myStudentNumber
                                                  ? Container()
                                                  : snapshot.data![i]
                                                          .reportersEmail
                                                          .contains(_myEmail)
                                                      ? GestureDetector(
                                                          onTap: () {
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
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: <
                                                                            Widget>[
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                ListBody(
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
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Row(
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
                                                              const Text(
                                                                  'Reported'),
                                                              GFAvatar(
                                                                size: GFSize
                                                                    .SMALL,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                child: Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
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
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
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
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
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
                                                                                  onPressed: () {
                                                                                    if (reason != null) {
                                                                                      print('not null!');
                                                                                      //data from thread
                                                                                      String reportID = snapshot.data![i].id; //threadID for reportID as well
                                                                                      String thrTitle = snapshot.data![i].title;
                                                                                      String thrCreatorID = snapshot.data![i].id;
                                                                                      String thrCreatorName = snapshot.data![i].creatorName;
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
                                                                                      if (snapshot.data![i].reportersEmail.isNotEmpty) {
                                                                                        if (snapshot.data![i].reportersEmail.contains(_myEmail) == false) {
                                                                                          reportProvider.addReportFields();
                                                                                          reportProvider.clickNow();
                                                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                            content: Text('Reported successfully'),
                                                                                            duration: Duration(milliseconds: 1000),
                                                                                          ));
                                                                                          Navigator.of(context).pop();
                                                                                        }
                                                                                      } else {
                                                                                        reportProvider.saveReport();
                                                                                        reportProvider.clickNow();
                                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                          content: Text('Reported successfully'),
                                                                                          duration: Duration(milliseconds: 1000),
                                                                                        ));
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
                                                              const Text(
                                                                  'Report'),
                                                              GFAvatar(
                                                                size: GFSize
                                                                    .SMALL,
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
                                                                      ? Colors.red[
                                                                          400]
                                                                      : Colors
                                                                          .red,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }

                                //[---------------------]
                                //eto sa for loop
                              } //has data to!
                              else {
                                return Container();
                              }

                              return Container();
                            },
                          ),
                        ),
                        //COMMENT BODY
                        Container(
                          child: ListView.builder(
                            // physics: const AlwaysScrollableScrollPhysics(),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: commentSnap.data!.length,
                            itemBuilder: (context, index) {
                              // List<bool> _isExpanded =
                              //     List.generate(10, (_) => false);
                              print(commentSnap.data![index].thrMessageSender);
                              DateTime myDateTime = commentSnap
                                  .data![index].thrMessageDate
                                  .toDate();
                              String formattedDate = timeago.format(
                                myDateTime,
                                locale: 'en_short',
                              );
                              bool _isRepliesOpen = false;
                              // DateFormat('yyyy-MM-dd – KK:mm a (EEE)')
                              //     .format(myDateTime);
                              //reading comment replies data
                              context
                                  .read<ThreadReplyProvider>()
                                  .changeJustReadThreadID(widget.threadID);
                              context
                                      .read<ThreadReplyProvider>()
                                      .changeJustReadThrMessageID =
                                  commentSnap.data![index].thrMessageID;

                              return Column(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: ListTile(
                                          title: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50)),
                                                child: Image.network(
                                                  commentSnap.data![index]
                                                      .thrSenderPhoto,
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 9,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  commentSnap.data![index]
                                                              .thrSenderName ==
                                                          widget.creatorName
                                                      ? Text(
                                                          commentSnap
                                                                  .data![index]
                                                                  .thrSenderName +
                                                              ', ' +
                                                              commentSnap
                                                                  .data![index]
                                                                  .thrSenderYearSection,
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  kMiddleColor),
                                                        )
                                                      : Text(
                                                          commentSnap
                                                                  .data![index]
                                                                  .thrSenderName +
                                                              ', ' +
                                                              commentSnap
                                                                  .data![index]
                                                                  .thrSenderYearSection,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                  Text(
                                                    commentSnap.data![index]
                                                                .thrSenderName ==
                                                            widget.creatorName
                                                        ? 'Author'
                                                        : '',
                                                    style: const TextStyle(
                                                      color: kMiddleColor,
                                                      fontSize: 9,
                                                      // fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          // title: Text(''),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              commentSnap.data![index]
                                                          .threadMessagePhoto !=
                                                      ''
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                        top: 3,
                                                      ),
                                                      child: Image.network(
                                                        commentSnap.data![index]
                                                            .threadMessagePhoto,
                                                        // height: size.height / 2,
                                                        // width: size.width / 2,
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5.0,
                                                        // bottom: 16.0,
                                                      ),
                                                      child: MarkdownBody(
                                                        data: _replaceMentions(
                                                          commentSnap
                                                              .data![index]
                                                              .thrMessageContent,
                                                        ).replaceAll(
                                                            '\n', '\\\n'),
                                                        onTapLink: (
                                                          String link,
                                                          String? href,
                                                          String title,
                                                        ) {
                                                          // print(
                                                          //     'Link clicked with $link')
                                                          _launchURL('$link');
                                                        },
                                                        builders: {
                                                          "coloredBox":
                                                              ColoredBoxMarkdownElementBuilder(
                                                                  context,
                                                                  otherNamesList,
                                                                  _myFullname),
                                                        },
                                                        inlineSyntaxes: [
                                                          ColoredBoxInlineSyntax(),
                                                        ],
                                                        styleSheet:
                                                            MarkdownStyleSheet
                                                                .fromTheme(
                                                          Theme.of(context)
                                                              .copyWith(
                                                            textTheme: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .apply(
                                                                  bodyColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSizeFactor:
                                                                      1,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              // Text(
                                              //   commentSnap.data![index]
                                              //       .thrMessageContent,
                                              //   style: const TextStyle(
                                              //     // color: Colors.white60,
                                              //     color: Colors.white,
                                              //     fontSize: 15,
                                              //   ),
                                              // ),
                                              // const SizedBox(
                                              //   height: 6,
                                              // ),
                                              Text(
                                                'Commented • ' + formattedDate,
                                                style: const TextStyle(
                                                  color: Colors.white30,
                                                  fontSize: 9,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  GFButton(
                                                    onPressed: () {
                                                      //reading only comments data
                                                      context
                                                          .read<
                                                              ThreadReplyProvider>()
                                                          .changeThreadID(
                                                              widget.threadID);
                                                      context
                                                              .read<
                                                                  ThreadReplyProvider>()
                                                              .changethrMessageID =
                                                          commentSnap
                                                              .data![index]
                                                              .thrMessageID;
                                                      print(commentSnap
                                                          .data![index]
                                                          .thrMessageID);
                                                    },
                                                    // color: kMiddleColor,
                                                    color: Colors.transparent,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons.comment,
                                                          color: Colors.white,
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        context
                                                                    .watch<
                                                                        ThreadReplyProvider>()
                                                                    .justReadthrMessageID ==
                                                                ''
                                                            ? Container()
                                                            : context
                                                                        .read<
                                                                            ThreadReplyProvider>()
                                                                        .justReadthrMessageID ==
                                                                    commentSnap
                                                                        .data![
                                                                            index]
                                                                        .thrMessageID
                                                                ? ShowRepliesButtonWidget(
                                                                    commentID: commentSnap
                                                                        .data![
                                                                            index]
                                                                        .thrMessageID,
                                                                    commentContent: commentSnap
                                                                        .data![
                                                                            index]
                                                                        .thrMessageContent,
                                                                    commenterToken: commentSnap
                                                                        .data![
                                                                            index]
                                                                        .thrSenderToken,
                                                                    myFullName:
                                                                        _myFullname,
                                                                    othersNames:
                                                                        otherNamesList,
                                                                    likersTokens:
                                                                        widget
                                                                            .likersTokens,
                                                                    myDeviceToken:
                                                                        _myDeviceToken,
                                                                    myEmail:
                                                                        _myEmail,
                                                                    myStudentNumber:
                                                                        _myStudentNumber,
                                                                    mySection:
                                                                        _myYearSec,
                                                                    threadID: widget
                                                                        .threadID,
                                                                    threadTitle:
                                                                        widget
                                                                            .threadTitle,
                                                                    threadCreatorID:
                                                                        widget
                                                                            .threadCreatorID,
                                                                    threadDescription:
                                                                        widget
                                                                            .threadDescription,
                                                                    creatorName:
                                                                        widget
                                                                            .creatorName,
                                                                    creatorSection:
                                                                        widget
                                                                            .creatorSection,
                                                                    formattedDate:
                                                                        widget
                                                                            .formattedDate,
                                                                    authorToken:
                                                                        widget
                                                                            .authorToken,
                                                                  )
                                                                : Container(),
                                                      ],
                                                    ),
                                                  ),
                                                  //COMMENT REPLY BUTTON
                                                  GFButton(
                                                    onPressed: () {
                                                      //CHANGE REPLY VALUES BEFORE TO FIREBASE
                                                      context
                                                          .read<
                                                              ThreadReplyProvider>()
                                                          .changeReplyer = Replyer(
                                                        name: _myFullname,
                                                        section: _myYearLvl >
                                                                _myCompletionYear
                                                            ? 'Alumnus'
                                                            : _myYearSec,
                                                        studentNumber:
                                                            _myStudentNumber,
                                                        token: _myDeviceToken,
                                                      );
                                                      context
                                                          .read<
                                                              ThreadReplyProvider>()
                                                          .changeReplyForumID(
                                                              widget.threadID);
                                                      context
                                                              .read<
                                                                  ThreadReplyProvider>()
                                                              .changeReplyForumCommentID =
                                                          commentSnap
                                                              .data![index]
                                                              .thrMessageID;
                                                      print(context
                                                          .read<
                                                              ThreadReplyProvider>()
                                                          .replyForumID);
                                                      print(context
                                                          .read<
                                                              ThreadReplyProvider>()
                                                          .replyForumCommentID);
                                                      //REPLY TEXTAREA
                                                      showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        builder: (context) {
                                                          return AnimatedPadding(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        150),
                                                            curve:
                                                                Curves.easeOut,
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .27,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                  top: 12,
                                                                  left: 12,
                                                                  right: 12,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    const Text(
                                                                      'Reply',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          20.0,
                                                                    ),
                                                                    //REPLY TEXTFIELD
                                                                    TextFormField(
                                                                      minLines:
                                                                          2,
                                                                      maxLines:
                                                                          4,
                                                                      // maxLength: 600,
                                                                      // controller:
                                                                      //     replyCtrl,
                                                                      // labelText:
                                                                      //     'Write a reply',
                                                                      initialValue: commentSnap.data![index].thrSenderName !=
                                                                              _myFullname
                                                                          ? '@' +
                                                                              commentSnap.data![index].thrSenderName +
                                                                              ' '
                                                                          : '',
                                                                      onChanged: (value) => context
                                                                          .read<
                                                                              ThreadReplyProvider>()
                                                                          .changeContent = value,
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
                                                                                .reply,
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor),
                                                                      ),
                                                                    ),
                                                                    //REPLY BUTTONS
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        //IMAGE REPLY BUTTON
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            //pick photo from phone storage
                                                                            final results =
                                                                                await FilePicker.platform.pickFiles(
                                                                              allowMultiple: false,
                                                                              type: FileType.custom,
                                                                              allowedExtensions: [
                                                                                'png',
                                                                                'jpg'
                                                                              ],
                                                                            );
                                                                            //set photo as reply
                                                                            if (results !=
                                                                                null) {
                                                                              //get the file path and filename (photo)
                                                                              final path = results.files.single.path;
                                                                              final fileName = results.files.single.name;
                                                                              //store in firebase storage
                                                                              //save image to firebase storage
                                                                              context.read<UploadImageProvider>().changeStorageFilePath = File(path!);
                                                                              await context.read<UploadImageProvider>().uploadReplyPhoto(path, fileName).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                                                                                    const SnackBar(
                                                                                      content: Text('Reply sent successfully'),
                                                                                      duration: Duration(milliseconds: 4000),
                                                                                    ),
                                                                                  ));

                                                                              //my forum
                                                                              if (commentSnap.data![index].thrSenderToken == _myDeviceToken) {
                                                                                //create activity
                                                                                await context.read<ActivityProvider2>().createActivity(
                                                                                      widget.threadID,
                                                                                      widget.threadTitle,
                                                                                      widget.threadDescription,
                                                                                      widget.formattedDate,
                                                                                      widget.threadCreatorID,
                                                                                      widget.creatorName,
                                                                                      widget.creatorSection,
                                                                                      widget.authorToken,
                                                                                      widget.likersTokens.cast<String>(),
                                                                                      'You replied to your comment:',
                                                                                      _myEmail,
                                                                                      commentSnap.data![index].thrMessageContent,
                                                                                    );
                                                                              } else {
                                                                                // //send reply banner notif on forum author
                                                                                // widget.authorToken != _myDeviceToken ? _sendAndRetrieveReplyAuthor() : null;
                                                                                //create activity
                                                                                await context.read<ActivityProvider2>().createActivity(
                                                                                      widget.threadID,
                                                                                      widget.threadTitle,
                                                                                      widget.threadDescription,
                                                                                      widget.formattedDate,
                                                                                      widget.threadCreatorID,
                                                                                      widget.creatorName,
                                                                                      widget.creatorSection,
                                                                                      widget.authorToken,
                                                                                      widget.likersTokens.cast<String>(),
                                                                                      'You replied to a comment:',
                                                                                      _myEmail,
                                                                                      commentSnap.data![index].thrMessageContent,
                                                                                    );
                                                                              }
                                                                              //get photoUrl from firebase storage after uploading it
                                                                              final replyPhotoURL = await context.read<UploadImageProvider>().getDownloadURLFromReplies(fileName);
                                                                              //change replyPhoto data in provider
                                                                              context.read<ThreadReplyProvider>().changeReplyPhoto = replyPhotoURL;
                                                                              //save to replies collection
                                                                              await context.read<ThreadReplyProvider>().saveImageReply();

                                                                              //send reply notif on commenter
                                                                              commentSnap.data![index].thrSenderToken == _myDeviceToken ? null : await _sendAndRetrieveReply(commentSnap.data![index].thrSenderToken);

                                                                              //create notification
                                                                              commentSnap.data![index].thrMessageSender == _myStudentNumber
                                                                                  ? null
                                                                                  : await context.read<NotificationProvider>().setNotification(
                                                                                        notifReceiverStudnum: commentSnap.data![index].thrMessageSender,
                                                                                        myStudentnumber: _myStudentNumber,
                                                                                        myEmail: _myEmail,
                                                                                        forumID: widget.threadID,
                                                                                        forumDescription: widget.threadDescription,
                                                                                        forumDate: widget.formattedDate,
                                                                                        forumTitle: widget.threadTitle,
                                                                                        authorName: widget.creatorName,
                                                                                        authorSection: widget.creatorSection,
                                                                                        authorID: widget.threadCreatorID,
                                                                                        authorToken: widget.authorToken,
                                                                                        likersTokens: widget.likersTokens,
                                                                                        title: _myFullname + ' replied to your comment',
                                                                                        comment: commentSnap.data![index].thrMessageContent,
                                                                                      );
                                                                              Future.delayed(const Duration(seconds: 1), () {
                                                                                Navigator.of(context).pop();
                                                                              });

                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(
                                                                                  content: Text('Reply sent successfully!'),
                                                                                  duration: Duration(milliseconds: 1500),
                                                                                ),
                                                                              );
                                                                              context.read<ThreadReplyProvider>().changeContent = '';
                                                                            }
                                                                            replyCtrl.clear();
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.add_photo_alternate_outlined,
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              size.width / 21,
                                                                        ),
                                                                        //TEXT REPLY BUTTON
                                                                        GFButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (context.read<ThreadReplyProvider>().content != null &&
                                                                                context.read<ThreadReplyProvider>().content != '') {
                                                                              //save to replies collection
                                                                              await context.read<ThreadReplyProvider>().saveThreadReply();
                                                                              //send reply notif on commenter
                                                                              commentSnap.data![index].thrSenderToken == _myDeviceToken ? null : await _sendAndRetrieveReply(commentSnap.data![index].thrSenderToken);
                                                                              //my forum
                                                                              if (commentSnap.data![index].thrSenderToken == _myDeviceToken) {
                                                                                //create activity
                                                                                await context.read<ActivityProvider2>().createActivity(
                                                                                      widget.threadID,
                                                                                      widget.threadTitle,
                                                                                      widget.threadDescription,
                                                                                      widget.formattedDate,
                                                                                      widget.threadCreatorID,
                                                                                      widget.creatorName,
                                                                                      widget.creatorSection,
                                                                                      widget.authorToken,
                                                                                      widget.likersTokens.cast<String>(),
                                                                                      'You replied to your comment:',
                                                                                      _myEmail,
                                                                                      commentSnap.data![index].thrMessageContent,
                                                                                    );
                                                                              } else {
                                                                                // //send reply banner notif on forum author
                                                                                // widget.authorToken != _myDeviceToken ? _sendAndRetrieveReplyAuthor() : null;
                                                                                //create activity
                                                                                await context.read<ActivityProvider2>().createActivity(
                                                                                      widget.threadID,
                                                                                      widget.threadTitle,
                                                                                      widget.threadDescription,
                                                                                      widget.formattedDate,
                                                                                      widget.threadCreatorID,
                                                                                      widget.creatorName,
                                                                                      widget.creatorSection,
                                                                                      widget.authorToken,
                                                                                      widget.likersTokens.cast<String>(),
                                                                                      'You replied to a comment:',
                                                                                      _myEmail,
                                                                                      commentSnap.data![index].thrMessageContent,
                                                                                    );
                                                                              }
                                                                              //create notification
                                                                              commentSnap.data![index].thrMessageSender == _myStudentNumber
                                                                                  ? null
                                                                                  : await context.read<NotificationProvider>().setNotification(
                                                                                        notifReceiverStudnum: commentSnap.data![index].thrMessageSender,
                                                                                        myStudentnumber: _myStudentNumber,
                                                                                        myEmail: _myEmail,
                                                                                        forumID: widget.threadID,
                                                                                        forumDescription: widget.threadDescription,
                                                                                        forumDate: widget.formattedDate,
                                                                                        forumTitle: widget.threadTitle,
                                                                                        authorName: widget.creatorName,
                                                                                        authorSection: widget.creatorSection,
                                                                                        authorID: widget.threadCreatorID,
                                                                                        authorToken: widget.authorToken,
                                                                                        likersTokens: widget.likersTokens,
                                                                                        title: _myFullname + ' replied to your comment',
                                                                                        comment: commentSnap.data![index].thrMessageContent,
                                                                                      );
                                                                              Future.delayed(const Duration(seconds: 1), () {
                                                                                Navigator.of(context).pop();
                                                                              });
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(
                                                                                  content: Text('Reply sent successfully!'),
                                                                                  duration: Duration(milliseconds: 1500),
                                                                                ),
                                                                              );
                                                                              context.read<ThreadReplyProvider>().changeContent = '';
                                                                            }
                                                                            replyCtrl.clear();
                                                                          },
                                                                          child:
                                                                              const Text('Reply'),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    color: Colors.transparent,
                                                    child: Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.reply,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          'Reply',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    // horizontal: size.width / 12,
                                                    ),
                                                child: Divider(
                                                  thickness: 2,
                                                  color: Colors.lightBlue
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //====================================================
                                      context
                                                  .watch<ThreadReplyProvider>()
                                                  .thrMessageID ==
                                              ''
                                          ? Container()
                                          : context
                                                      .read<
                                                          ThreadReplyProvider>()
                                                      .thrMessageID ==
                                                  commentSnap
                                                      .data![index].thrMessageID
                                              ? RepliesWidget(
                                                  commentID: commentSnap
                                                      .data![index]
                                                      .thrMessageID,
                                                  commentContent: commentSnap
                                                      .data![index]
                                                      .thrMessageContent,
                                                  commenterToken: commentSnap
                                                      .data![index]
                                                      .thrSenderToken,
                                                  myFullName: _myFullname,
                                                  othersNames: otherNamesList,
                                                  likersTokens:
                                                      widget.likersTokens,
                                                  myDeviceToken: _myDeviceToken,
                                                  myEmail: _myEmail,
                                                  myStudentNumber:
                                                      _myStudentNumber,
                                                  mySection: _myYearSec,
                                                  threadID: widget.threadID,
                                                  threadTitle:
                                                      widget.threadTitle,
                                                  threadCreatorID:
                                                      widget.threadCreatorID,
                                                  threadDescription:
                                                      widget.threadDescription,
                                                  creatorName:
                                                      widget.creatorName,
                                                  creatorSection:
                                                      widget.creatorSection,
                                                  formattedDate:
                                                      widget.formattedDate,
                                                  authorToken:
                                                      widget.authorToken,
                                                  // sendAndRetrieveReply:
                                                  //     _sendAndRetrieveReply(
                                                  //         commentSnap
                                                  //             .data![index]
                                                  //             .thrSenderToken),
                                                  // sendAndRetrieveReplyAuthor:
                                                  //     _sendAndRetrieveReplyAuthor(),
                                                )
                                              : Container(),

                                      //===================================================

                                      // const SizedBox(
                                      //   height: 12,
                                      // ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),

          // bottom textformfield send
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * .03,
              ),
              width: double.infinity,
              color: Theme.of(context).cardColor,
              child: Row(
                children: <Widget>[
                  //IMAGE COMMENT BUTTON
                  GestureDetector(
                    onTap: () async {
                      //pick photo from phone storage
                      final results = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: ['png', 'jpg'],
                      );
                      //set photo as reply
                      if (results != null) {
                        //get the file path and filename (photo)
                        final path = results.files.single.path;
                        final fileName = results.files.single.name;
                        //store in firebase storage
                        //save image to firebase storage
                        context
                            .read<UploadImageProvider>()
                            .changeStorageFilePath = File(path!);
                        await context
                            .read<UploadImageProvider>()
                            .uploadCommentPhoto(path, fileName)
                            .then((value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Comment sent successfully'),
                                    duration: Duration(milliseconds: 1500),
                                  ),
                                ));
                        //my own topic/forum
                        if (_myDeviceToken == widget.authorToken) {
                          //create activity
                          await context
                              .read<ActivityProvider2>()
                              .createActivity(
                                widget.threadID,
                                widget.threadTitle,
                                widget.threadDescription,
                                widget.formattedDate,
                                widget.threadCreatorID,
                                widget.creatorName,
                                widget.creatorSection,
                                widget.authorToken,
                                widget.likersTokens.cast<String>(),
                                'You commented on your forum',
                                _myEmail,
                                threadMessageContentCtrl.text,
                              );
                          Future.delayed(const Duration(seconds: 1), () {
                            threadMessageContentCtrl.clear();
                          });
                        } //not my forum
                        else {
                          //create activity
                          await context
                              .read<ActivityProvider2>()
                              .createActivity(
                                widget.threadID,
                                widget.threadTitle,
                                widget.threadDescription,
                                widget.formattedDate,
                                widget.threadCreatorID,
                                widget.creatorName,
                                widget.creatorSection,
                                widget.authorToken,
                                widget.likersTokens.cast<String>(),
                                'You commented on a forum',
                                _myEmail,
                                threadMessageContentCtrl.text,
                              );
                          threadMessageContentCtrl.clear();
                        }
                        //get photoUrl from firebase storage after uploading it
                        final commentPhotoURL = await context
                            .read<UploadImageProvider>()
                            .getDownloadURLFromComments(fileName);
                        //change commentPhoto data in provider
                        context
                            .read<ThreadMessageProvider2>()
                            .changeCommentPhoto = commentPhotoURL;
                        //save to comments collection
                        await context
                            .read<ThreadMessageProvider2>()
                            .saveCommentPhoto(widget.threadID, commentPhotoURL);
                        //send comment notif to likers
                        await _sendAndRetrieveComment();
                        //a banner message for the forum author/creator

                        widget.threadCreatorID == _myStudentNumber
                            ? null
                            : await _sendAndRetrieveCommentAuthor();

                        //create notification
                        widget.threadCreatorID == _myStudentNumber
                            ? null
                            : await context
                                .read<NotificationProvider>()
                                .setNotification(
                                  notifReceiverStudnum: widget.threadCreatorID,
                                  myStudentnumber: _myStudentNumber,
                                  myEmail: _myEmail,
                                  forumID: widget.threadID,
                                  forumDescription: widget.threadDescription,
                                  forumDate: widget.formattedDate,
                                  forumTitle: widget.threadTitle,
                                  authorName: widget.creatorName,
                                  authorSection: widget.creatorSection,
                                  authorID: widget.threadCreatorID,
                                  authorToken: widget.authorToken,
                                  likersTokens: widget.likersTokens,
                                  title:
                                      _myFullname + ' commented on your forum',
                                  comment: threadMessageContentCtrl.text,
                                );
                        //update comments count
                        await context
                            .read<ThreadMessageProvider2>()
                            .updateThreadMsgCount(widget.threadID);
                      }
                    },
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      color: context.read<ThemeProvider2>().isDark
                          ? Colors.white
                          : kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    width: size.width / 21,
                  ),
                  //COMMENT TEXT AREA
                  Expanded(
                    child: TextFormField(
                      maxLines: 2,
                      controller: threadMessageContentCtrl,
                      focusNode: _focusNode,
                      onChanged: (value) => context
                          .read<ThreadMessageProvider2>()
                          .changeThrMessageContent = value,
                      decoration: const InputDecoration(
                          hintText: "Share your ideas...",
                          border: InputBorder.none),
                      // cursorHeight: 12,
                    ),
                  ),
                  //TEXT COMMENT BUTTON
                  GFButton(
                    onPressed: () async {
                      if (threadMessageContentCtrl.text != '') {
                        //send comment notif to likers
                        await _sendAndRetrieveComment();
                        //a banner message for the forum author/creator

                        widget.threadCreatorID == _myStudentNumber
                            ? null
                            : await _sendAndRetrieveCommentAuthor();

                        //save to comments collection
                        await context
                            .read<ThreadMessageProvider2>()
                            .saveThreadMessage(widget.threadID);
                        //my own topic/forum
                        if (_myDeviceToken == widget.authorToken) {
                          //create activity
                          await context
                              .read<ActivityProvider2>()
                              .createActivity(
                                widget.threadID,
                                widget.threadTitle,
                                widget.threadDescription,
                                widget.formattedDate,
                                widget.threadCreatorID,
                                widget.creatorName,
                                widget.creatorSection,
                                widget.authorToken,
                                widget.likersTokens.cast<String>(),
                                'You commented on your forum',
                                _myEmail,
                                threadMessageContentCtrl.text,
                              );
                          Future.delayed(const Duration(seconds: 1), () {
                            threadMessageContentCtrl.clear();
                          });
                        } //not my forum
                        else {
                          //create activity
                          await context
                              .read<ActivityProvider2>()
                              .createActivity(
                                widget.threadID,
                                widget.threadTitle,
                                widget.threadDescription,
                                widget.formattedDate,
                                widget.threadCreatorID,
                                widget.creatorName,
                                widget.creatorSection,
                                widget.authorToken,
                                widget.likersTokens.cast<String>(),
                                'You commented on a forum',
                                _myEmail,
                                threadMessageContentCtrl.text,
                              );

                          threadMessageContentCtrl.clear();
                        }
                        //create notification
                        widget.threadCreatorID == _myStudentNumber
                            ? null
                            : await context
                                .read<NotificationProvider>()
                                .setNotification(
                                  notifReceiverStudnum: widget.threadCreatorID,
                                  myStudentnumber: _myStudentNumber,
                                  myEmail: _myEmail,
                                  forumID: widget.threadID,
                                  forumDescription: widget.threadDescription,
                                  forumDate: widget.formattedDate,
                                  forumTitle: widget.threadTitle,
                                  authorName: widget.creatorName,
                                  authorSection: widget.creatorSection,
                                  authorID: widget.threadCreatorID,
                                  authorToken: widget.authorToken,
                                  likersTokens: widget.likersTokens,
                                  title:
                                      _myFullname + ' commented on your forum',
                                  comment: threadMessageContentCtrl.text,
                                );
                        //update comments count
                        await context
                            .read<ThreadMessageProvider2>()
                            .updateThreadMsgCount(widget.threadID);
                        FocusManager.instance.primaryFocus?.unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Comment sent successfully'),
                            duration: Duration(milliseconds: 1500),
                          ),
                        );
                        print('tokensss ' + widget.authorToken);
                      }
                    },
                    child: const Text('Comment'),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Wrapping mentioned users with brackets to identify them easily
  String _replaceMentions(String text) {
    otherNamesList.map((u) => u).toSet().forEach((userName) {
      text = text.replaceAll('@$userName', '[@$userName]');
    });
    return text;
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
            'body': _myFullname + ' liked your forum.',
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

  Future<void> _sendAndRetrieveCommentAuthor() async {
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
            'body': threadMessageContentCtrl.text == ''
                ? 'sent a photo'
                : threadMessageContentCtrl.text,
            'title': 'Someone commented on your forum',
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

          'registration_ids': [widget.authorToken],
        },
      ),
    );
  }

  Future<void> _sendAndRetrieveComment() async {
    // Go to Firebase console -> Project settings -> Cloud Messaging -> copy Server key
    // the Server key will start "AAAAMEjC64Y..."
    List sendTokens = [];
    widget.likersTokens.forEach((token) {
      if (token != _myDeviceToken && token != widget.authorToken) {
        sendTokens.add(token);
      }
    });
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
            'body': threadMessageContentCtrl.text == ''
                ? 'sent a photo'
                : threadMessageContentCtrl.text,
            'title': 'Someone commented on a forum you liked',
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

          'registration_ids': sendTokens,
        },
      ),
    );
  }

  Future<void> _sendAndRetrieveReply(String commentToken) async {
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
            'body': context.read<ThreadReplyProvider>().content == ''
                ? 'sent a photo'
                : context.read<ThreadReplyProvider>().content,
            'title': 'Someone replied on your comment:',
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
          'registration_ids': [commentToken],
        },
      ),
    );
  }

  Future<void> _sendAndRetrieveReplyAuthor() async {
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
            'body': context.read<ThreadReplyProvider>().content == ''
                ? 'sent a photo'
                : context.read<ThreadReplyProvider>().content,
            'title': widget.authorToken == _myDeviceToken
                ? 'Your reply:'
                : 'Someone replied in your forum:',
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
          'registration_ids': [widget.authorToken],
        },
      ),
    );
  }
}

class ColoredBoxInlineSyntax extends md.InlineSyntax {
  ColoredBoxInlineSyntax({
    String pattern = r'\[(.*?)\]',
  }) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    /// This creates a new element with the tag name `coloredBox`
    /// The `textContent` of this new tag will be the
    /// pattern match with the @ symbol
    ///
    /// We can change how this looks by creating a custom
    /// [MarkdownElementBuilder] from the `flutter_markdown` package.
    final withoutBracket1 = match.group(0)!.replaceAll('[', "");
    final withoutBracket2 = withoutBracket1.replaceAll(']', "");
    md.Element mentionedElement =
        md.Element.text("coloredBox", withoutBracket2);
    print('Mentioned user ${mentionedElement.textContent}');
    parser.addNode(mentionedElement);
    return true;
  }
}

class ColoredBoxMarkdownElementBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  final List<String> mentionedUsers;
  final String myName;

  ColoredBoxMarkdownElementBuilder(
      this.context, this.mentionedUsers, this.myName);

  ///This method would help us figure out if the text element needs styling
  ///The background color of the text would be Color(0xffDCECF9) if it is the
  ///sender's name that is mentioned in the text, otherwise it would be transparent
  Color _backgroundColorForElement(String text) {
    Color color = Colors.transparent;
    if (mentionedUsers != null) {
      if (mentionedUsers.contains(myName) && text.contains(myName)) {
        color = Color(0xffDCECF9);
      } else {
        color = Colors.transparent;
      }
    }
    return color;
  }

  ///This method would help us figure out if the text element needs styling
  ///The text color would be blue if the text is a user's name and is mentioned
  ///in the text
  Color _textColorForBackground(Color backgroundColor, String textContent) {
    return checkIfFormattingNeeded(textContent) ? Colors.blue : Colors.black;
  }

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 2),
      decoration: element.textContent.contains(myName)
          ? BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: _backgroundColorForElement(element.textContent),
            )
          : null,
      child: Padding(
        padding: element.textContent.contains(myName)
            ? EdgeInsets.all(4.0)
            : EdgeInsets.all(0),
        child: Text(
          element.textContent,
          style: TextStyle(
            color: _textColorForBackground(
              _backgroundColorForElement(
                element.textContent.replaceAll('@', ''),
              ),
              element.textContent.replaceAll('@', ''),
            ),
            fontWeight: checkIfFormattingNeeded(
              element.textContent.replaceAll('@', ''),
            )
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  bool checkIfFormattingNeeded(String text) {
    var checkIfFormattingNeeded = false;
    if (mentionedUsers != null && mentionedUsers.isNotEmpty) {
      if (mentionedUsers.contains(text) || mentionedUsers.contains(myName)) {
        checkIfFormattingNeeded = true;
      } else {
        checkIfFormattingNeeded = false;
      }
    }
    return checkIfFormattingNeeded;
  }
}
