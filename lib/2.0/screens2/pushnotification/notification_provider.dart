import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/models/notification_count.dart';
import 'package:usapp_mobile/2.0/models/notification.dart';
import 'package:usapp_mobile/2.0/models/push_notification.dart';
import 'package:usapp_mobile/2.0/models/topicforum_screen.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_badge.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:uuid/uuid.dart';

class NotificationProvider with ChangeNotifier {
  var uuid = Uuid();
  FirestoreService2 firestoreService2 = FirestoreService2();
  //initial values
  String _deviceToken = '';
  late int _homeMsgNotifCount = 0;
  late int _myNotifCount = 0;
  bool _isNotifClicked = false;
  List _myNotifNow = [];
  String _myStudentNumber = '';
  //model
  PushNotification? _pushNotification;
  //get
  PushNotification? get pushNotification => _pushNotification;
  int get homeMsgNotifCount => _homeMsgNotifCount;
  int get myNotifCount => _myNotifCount;
  String get myStudentNumber => _myStudentNumber;
  Stream<List<UsappNotification>> get getUsappNoifications =>
      firestoreService2.getUsappNotifications();
  bool get isNotifClicked => _isNotifClicked;
  List get myNotifNow => _myNotifNow;

  //set
  set pushNotification(PushNotification? pushNotification) {
    _pushNotification = pushNotification!;
    notifyListeners();
  }

  set deviceToken(String deviceToken) {
    _deviceToken = deviceToken;
  }

  //================================================
  set homeMsgNotifCount(int homeMsgNotifCount) {
    _homeMsgNotifCount = homeMsgNotifCount;
    // notifyListeners();
  }

  set myNotifCount(int myNotifCount) {
    _myNotifCount = myNotifCount;
  }
  //===================================================

  set changeMyStudentNumber(String myStudentNumber) {
    _myStudentNumber = myStudentNumber;
    notifyListeners();
  }

  set changeIsNotifClicked(bool isNotifClicked) {
    _isNotifClicked = isNotifClicked;
    // notifyListeners();
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');

      //main message
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );
        _pushNotification = notification;
        notifyListeners();

        if (notification != null) {
          showSimpleNotification(
            Text(_pushNotification!.title!),
            leading: NotificationBadge(
                height: 40,
                width: 40,
                fontSize: 12,
                totalNotification: _homeMsgNotifCount),
            subtitle: Text(_pushNotification!.body!),
            duration: const Duration(seconds: 2),
          );
          notifyListeners();
        }
      });
    }
  }

  //NOTIF COUNT
  late String _ownerEmail = '';
  set ownerEmail(String ownerEmail) {
    _ownerEmail = ownerEmail;
    notifyListeners();
  }

  String get ownerEmail => _ownerEmail;

  setNotification({
    required String notifReceiverStudnum,
    required String myStudentnumber,
    required String myEmail,
    required String forumID,
    required String forumTitle,
    required String forumDescription,
    required String forumDate,
    required String authorName,
    required String authorID,
    required String authorSection,
    required String authorToken,
    required List likersTokens,
    required String title,
    required String comment,
  }) async {
    DateTime now = DateTime.now();
    var date = Timestamp.fromDate(now);
    var updatedNotifCount = UsappNotification(
      topicForumScreen: TopicForumScreen(
        forumID: forumID,
        forumTitle: forumTitle,
        forumDescription: forumDescription,
        forumDate: forumDate,
        authorID: authorID,
        authorName: authorName,
        authorSection: authorSection,
        authorToken: authorToken,
        likersTokens: likersTokens,
      ),
      notifID: notifReceiverStudnum +
          '_' +
          myStudentnumber +
          '_' +
          myEmail +
          uuid.v4(),
      notifOwner: notifReceiverStudnum,
      notifTitle: title,
      notifDate: date,
      comment: comment,
    );
    await firestoreService2.setUsappNotification(updatedNotifCount);
    notifyListeners();
  }

  updateNotifCount(String recieverEmail) {
    // firestoreService2.updateNotifCount(ownerEmail: recieverEmail);
    notifyListeners();
  }

  decreaseNotifCount(String senderEmail) {
    firestoreService2.decreaseNotifCount(ownerEmail: senderEmail);
    notifyListeners();
  }

  // checkForInitialMessage() async {
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();
  //   if (initialMessage != null) {
  //     PushNotification notification = PushNotification(
  //       title: initialMessage.notification!.title,
  //       body: initialMessage.notification!.body,
  //       dataTitle: initialMessage.data['title'],
  //       dataBody: initialMessage.data['body'],
  //     );
  //     _totalNotificationCounter++;
  //     _pushNotification = notification;
  //   }
  // }
}
