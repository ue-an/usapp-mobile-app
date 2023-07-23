import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/models/direct_messages_content.dart';
import 'package:usapp_mobile/2.0/models/push_notification.dart';
import 'package:usapp_mobile/2.0/providers2/directmessage_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/directmessagescontent_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/keep_alive_provider.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_provider.dart';
//
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class DirectMessageScreen2 extends StatefulWidget {
  String senderName,
      senderYearSec,
      senderPhotoUrl,
      senderEmail,
      recieverName,
      recieverYearSec,
      recieverPhotoUrl,
      receiverEmail,
      senderToken,
      recieverToken,
      convoID;
  DirectMessageScreen2({
    Key? key,
    required this.senderEmail,
    required this.senderName,
    required this.senderYearSec,
    required this.senderPhotoUrl,
    required this.receiverEmail,
    required this.recieverName,
    required this.recieverYearSec,
    required this.recieverPhotoUrl,
    required this.senderToken,
    required this.recieverToken,
    required this.convoID,
  }) : super(key: key);

  @override
  _DirectMessageScreen2State createState() => _DirectMessageScreen2State();
}

class _DirectMessageScreen2State extends State<DirectMessageScreen2>
    with AutomaticKeepAliveClientMixin<DirectMessageScreen2> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;
  TextEditingController messageContentCtrl = TextEditingController();
  late String _myEmail = '';
  late String _myStudentNumber = '';
  late Stream<List<DirectMessagesContent>> _dmpmStream;
  late int _myCompletionYear = 0;
  late int _myYearLevel = 0;
  late String _myYearSec = '';
  late String _myFullName = '';
  late String _myPhoto = '';

  void _storeDetailsOnLocal() async {
    String? myEmail = await context.read<LocalDataProvider2>().getLocalEmail();
    String? myStudentNumber =
        await context.read<LocalDataProvider2>().getLocalStudentNumber();
    int myCompletionYear =
        await context.read<LocalDataProvider2>().getLocalCompletionYear();
    int? myYearLevel =
        await context.read<LocalDataProvider2>().getLocalYearLevel();
    String? myCourse =
        await context.read<LocalDataProvider2>().getLocalCourse();
    int? mySection = await context.read<LocalDataProvider2>().getLocalSection();
    String myYearSec =
        myCourse! + ' ' + myYearLevel.toString() + '-' + mySection.toString();
    String? myFullName =
        await context.read<LocalDataProvider2>().getLocalFullName();
    String? myPhoto =
        await context.read<LocalDataProvider2>().getLocalStudentPhoto();
    setState(() {
      _myEmail = myEmail!;
      _myStudentNumber = myStudentNumber!;
      _myYearLevel = myYearLevel!;
      _myCompletionYear = myCompletionYear;
      _myYearSec = myYearSec;
      _myFullName = myFullName!;
      _myPhoto = myPhoto!;
    });
  }

  initAlive() async {
    var visit = context.read<KeepAliveProvider2>().isDmPmScreenAlive = true;
    _isVisited = visit;
  }

  //initial values
  late String _myDeviceToken = '';
  late final FirebaseMessaging _firebaseMessaging;
  int _increment = 0;
  void _getDeviceTokenOnLocal() async {
    String? myDeviceToken =
        await context.read<LocalDataProvider2>().getDeviceToken();
    setState(() {
      _myDeviceToken = myDeviceToken!;
    });
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
      // context.read<NotificationProvider>().msgNotificationCounter = newVal;
    }
  }

  @override
  void initState() {
    _firebaseMessaging = FirebaseMessaging.instance;
    //update sender details on provider
    context.read<DirectMessageProvider2>().changeSenderEmail = _myEmail;
    // context.read<DirectMessageProvider2>().changeSenderName = widget.senderName;
    context.read<DirectMessageProvider2>().changeSenderName = _myFullName;
    context.read<DirectMessageProvider2>().changeSenderYearSec =
        // _myYearLevel > _myCompletionYear ? 'Alumnus' : widget.senderYearSec;
        _myYearSec;
    // context.read<DirectMessageProvider2>().changeSenderPhotoUrl =
    //     widget.senderPhotoUrl;
    context.read<DirectMessageProvider2>().changeSenderPhotoUrl = _myPhoto;
    context.read<DirectMessageProvider2>().changeSenderID = _myStudentNumber;

    //update reciever details on provider
    context.read<DirectMessageProvider2>().changeRecieverEmail =
        widget.receiverEmail;
    context.read<DirectMessageProvider2>().changeRecieverName =
        widget.recieverName;
    context.read<DirectMessageProvider2>().changeRecieverID = '';
    context.read<DirectMessageProvider2>().changeRecieverYearSec =
        widget.recieverYearSec;
    context.read<DirectMessageProvider2>().changeRecieverPhotoUrl =
        widget.recieverPhotoUrl;
    //
    context.read<DirectMessageProvider2>().changeDmID = widget.convoID;
    _dmpmStream = context.read<DirectMessageProvider2>().directMessagesContent;
    _storeDetailsOnLocal();
    initAlive();

    // _totalNotificationCounter =
    //     context.read<NotificationProvider>().msgNotificationCounter;
    _getDeviceTokenOnLocal();
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
      // context.read<NotificationProvider>().msgNotificationCounter = newVal;
    });
    //normal notification
    context.read<NotificationProvider>().registerNotification();
    //when app is terminated
    checkForInitialMessage();
    //initialize deviceToken in provider
    context.read<NotificationProvider>().deviceToken = _myDeviceToken;
    _storeDetailsOnLocal();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: Image.network(
                widget.recieverPhotoUrl,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recieverName,
                ),
                Text(
                  widget.recieverYearSec,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: size.height / 10,
            ),
            child: StreamBuilder<List<DirectMessagesContent>>(
              stream: _dmpmStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        DateTime myDateTime =
                            snapshot.data![index].messageContentSent.toDate();
                        String formattedDate =
                            DateFormat('yyyy-MM-dd – KK:mm a (EEE)')
                                .format(myDateTime);
                        //-------------------

                        //--------------------
                        List splitSenderName =
                            snapshot.data![index].senderName.split(' ');
                        return Column(
                          children: [
                            Align(
                              alignment: snapshot.data![index].senderName ==
                                      widget.senderName
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 9, right: 9, top: 3, bottom: 3),
                                child: snapshot.data![index].senderName !=
                                        widget.senderName
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50)),
                                            child: Image.network(
                                              widget.recieverPhotoUrl,
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //     left: 12,
                                              //   ),
                                              //   child: Text(
                                              //     snapshot
                                              //         .data![index].senderName,
                                              //     style: const TextStyle(
                                              //       color: Colors.white,
                                              //     ),
                                              //   ),
                                              // ),
                                              Container(
                                                width: snapshot
                                                            .data![index]
                                                            .messageContent
                                                            .length >
                                                        39
                                                    ? size.width / 1.5
                                                    : null,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: (snapshot.data![index]
                                                              .senderName ==
                                                          widget.senderName
                                                      ? Colors.blue
                                                      : Colors.grey),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                child: Text(
                                                  snapshot.data![index]
                                                      .messageContent,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                formattedDate,
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //     right: 12,
                                              //   ),
                                              //   child: Text(
                                              //     snapshot
                                              //         .data![index].senderName,
                                              //     style: const TextStyle(
                                              //       color: Colors.white,
                                              //     ),
                                              //   ),
                                              // ),
                                              Container(
                                                width: snapshot
                                                            .data![index]
                                                            .messageContent
                                                            .length >
                                                        39
                                                    ? size.width / 1.5
                                                    : null,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: (snapshot.data![index]
                                                              .senderName ==
                                                          widget.senderName
                                                      ? Colors.blue
                                                      : Colors.grey),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                child: Text(
                                                  snapshot.data![index]
                                                      .messageContent,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                formattedDate,
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                          ],
                        );
                      });
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(
                    child: Text('No messages yet'),
                  );
                }
              },
            ),
          ),
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
                  // GFButton(
                  //   onPressed: () {
                  //     _sendAndRetrieveMessage();
                  //   },
                  //   child: Text('test'),
                  // ),
                  Expanded(
                    child: TextFormField(
                      maxLines: 2,
                      controller: messageContentCtrl,
                      onChanged: (value) => context
                          .read<DirectMessageProvider2>()
                          .changeDMContent = value,
                      decoration: const InputDecoration(
                          hintText: "   Write message...",
                          border: InputBorder.none),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        if (messageContentCtrl.text != '') {
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeSenderEmail = widget.senderEmail;
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeSenderName = widget.senderName;

                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeSenderPhotoUrl = widget.senderPhotoUrl;
                          context
                                  .read<DirectMessagesContentProvider2>()
                                  .changeSenderYearSec =
                              _myYearLevel > _myCompletionYear
                                  ? 'Alumnus'
                                  : _myYearSec;
                          context
                                  .read<DirectMessageProvider2>()
                                  .changeSenderYearSec =
                              _myYearLevel > _myCompletionYear
                                  ? 'Alumnus'
                                  : _myYearSec;
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeReceiverEmail = widget.receiverEmail;
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeReceiverName = widget.recieverName;
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeReceiverPhotoUrl = widget.recieverPhotoUrl;
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeReceiverYearSec = widget.recieverYearSec;
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeChatID = widget.convoID;
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeIDS = [
                            widget.senderEmail,
                            widget.receiverEmail
                          ];
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeLatestMessage = messageContentCtrl.text;
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeSenderToken = _myDeviceToken;
                          context
                              .read<DirectMessagesContentProvider2>()
                              .changeReceiverToken = widget.recieverToken;
                          //-------------------------------------
                          context
                              .read<DirectMessageProvider2>()
                              .changeSenderEmail = _myEmail;
                          context
                              .read<DirectMessageProvider2>()
                              .changeSenderName = widget.senderName;

                          context
                              .read<DirectMessageProvider2>()
                              .changeSenderPhotoUrl = widget.senderPhotoUrl;
                          //-----------------------------------
                          // context
                          //     .read<DirectMessagesContentProvider2>()
                          //     .changeSenderEmail = _myEmail;
                          // context
                          //     .read<DirectMessagesContentProvider2>()
                          //     .changeSenderName = widget.senderName;

                          // context
                          //     .read<DirectMessagesContentProvider2>()
                          //     .changeSenderPhotoUrl = widget.senderPhotoUrl;
                          // //
                          // context
                          //         .read<DirectMessageProvider2>()
                          //         .changeSenderYearSec =
                          //     _myYearLevel > _myCompletionYear
                          //         ? 'Alumnus'
                          //         : _myYearSec;
                          // context
                          //         .read<DirectMessagesContentProvider2>()
                          //         .changeSenderYearSec =
                          //     _myYearLevel > _myCompletionYear
                          //         ? 'Alumnus'
                          //         : _myYearSec;
                          // context
                          //     .read<DirectMessageProvider2>()
                          //     .changeRecieverEmail = widget.receiverEmail;
                          // context
                          //     .read<DirectMessageProvider2>()
                          //     .changeRecieverName = widget.recieverName;
                          // context
                          //     .read<DirectMessageProvider2>()
                          //     .changeRecieverPhotoUrl = widget.recieverPhotoUrl;
                          // context
                          //     .read<DirectMessageProvider2>()
                          //     .changeRecieverYearSec = widget.recieverYearSec;
                          // context
                          //     .read<DirectMessagesContentProvider2>()
                          //     .changeReceiverYearSec = widget.recieverYearSec;
                          // context.read<DirectMessageProvider2>().changeDmID =
                          //     widget.convoID;
                          // context
                          //     .read<DirectMessagesContentProvider2>()
                          //     .changeIDS = [
                          //   widget.senderEmail,
                          //   widget.receiverEmail
                          // ];
                          // context
                          //     .read<DirectMessagesContentProvider2>()
                          //     .changeLatestMessage = messageContentCtrl.text;
                          // context
                          //     .read<DirectMessagesContentProvider2>()
                          //     .changeSenderToken = _myDeviceToken;
                          // context
                          //     .read<DirectMessagesContentProvider2>()
                          //     .changeReceiverToken = widget.recieverToken;
                          //----------------------------------
                          context
                              .read<DirectMessageProvider2>()
                              .saveDirectMessageContent(widget.convoID);

                          print('sender: ' + widget.senderEmail);
                          print('receiver: ' + widget.receiverEmail);
                          context
                              .read<DirectMessagesContentProvider2>()
                              .saveUserChat();
                          _sendAndRetrieveMessage();
                          //===============
                          // context
                          //     .read<DirectMessagesContentProvider2>()
                          //     .changeSenderName = 'sdsdsds';
                          // print('fucking click');
                          // print(_myFullName);
                          // print(widget.senderName);
                          // print(context
                          //     .read<DirectMessagesContentProvider2>()
                          //     .senderName);
                        }
                        messageContentCtrl.clear();
                      },
                      child: const Icon(
                        Icons.send,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // final String serverToken =
  //     'AAAApcnCYIw:APA91bHLAKGEAkAu9xl8nd4GC5OVYwR8Uu7jgjMrOSzzKzl81mfRXfYIZmdqmwCWUhO0nFusIJQrM_npC6bnkeEQjEZwFBqukIt4Ci5rrT2fGgw6w4qZUJxecVmIe9zqw5n7nsdlJOwF';
  Future<void> _sendAndRetrieveMessage() async {
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
            'body': messageContentCtrl.text,
            'title': widget.senderName,
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
          'registration_ids': [
            widget.recieverToken,
          ],
        },
      ),
    );
  }
}
