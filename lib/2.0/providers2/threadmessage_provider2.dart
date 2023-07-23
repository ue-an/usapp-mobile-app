import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/models/thread_message.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:uuid/uuid.dart';

class ThreadMessageProvider2 with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var uuid = Uuid();

  String? _thrMessageContent;
  String? _threadID;
  late List _likersTokens = [];
  String? _authorToken;
  String? _commentPhoto;

  //getter
  String? get thrMessageContent => _thrMessageContent;
  String? get threadID => _threadID;
  List get likersTokens => _likersTokens;
  Stream<List<ThreadMessage>> get threadMessages =>
      firestoreService2.fetchThreadMessages(_threadID!);
  String? get authorToken => _authorToken;
  // Stream get threadMessages =>
  //     firestoreService2.fetchThreadMessages(_threadID!);

  //set
  set changeThrMessageContent(String thrMessageContent) {
    _thrMessageContent = thrMessageContent;
    notifyListeners();
  }

  set changeThrID(String threadID) {
    _threadID = threadID;
    notifyListeners();
  }

  set changeLikersTokens(List likersTokens) {
    _likersTokens = likersTokens;
    notifyListeners();
  }

  set changeAuthorToken(String authorToken) {
    _authorToken = authorToken;
    notifyListeners();
  }

  set changeCommentPhoto(String commentPhoto) {
    _commentPhoto = commentPhoto;
    notifyListeners();
  }

  //functions
  saveThreadMessage(String threadid) async {
    // _threadID = threadid;
    if (_thrMessageContent != null) {
      DateTime now = DateTime.now();
      var date = Timestamp.fromDate(now);
      SharedPreferences localPrefs = await SharedPreferences.getInstance();
      //localstud-<info needed>
      String studID = localPrefs.getString('localstud-studentNum')!;
      String senderName = localPrefs.getString('localstud-fullname')!;
      String senderPhoto = localPrefs.getString('localstud-photo')!;
      String senderCourse = localPrefs.getString('localstud-course')!;
      int senderYearLevel = localPrefs.getInt('localstud-yearlevel')!;
      int senderSection = localPrefs.getInt('localstud-section')!;
      int completionYear = localPrefs.getInt('completion-year')!;
      String senderToken = localPrefs.getString('device-token')!;
      var putThreadMessage = ThreadMessage(
        thrMessageID: studID + '_' + uuid.v4(),
        thrMessageSender: studID,
        thrMessageDate: date,
        thrMessageContent: _thrMessageContent!,
        thrSenderPhoto: senderPhoto,
        thrSenderName: senderName,
        thrSenderYearSection: senderYearLevel > completionYear
            ? 'Alumnus'
            : senderCourse +
                ' ' +
                senderYearLevel.toString() +
                '-' +
                senderSection.toString(),
        thrSenderToken: senderToken,
        threadMessagePhoto: '',
      );
      firestoreService2.setThreadMessage(putThreadMessage, threadid);
      notifyListeners();
    }
  }

  saveCommentPhoto(String threadid, String commentPhoto) async {
    // _threadID = threadid;
    DateTime now = DateTime.now();
    var date = Timestamp.fromDate(now);
    SharedPreferences localPrefs = await SharedPreferences.getInstance();
    //localstud-<info needed>
    String studID = localPrefs.getString('localstud-studentNum')!;
    String senderName = localPrefs.getString('localstud-fullname')!;
    String senderPhoto = localPrefs.getString('localstud-photo')!;
    String senderCourse = localPrefs.getString('localstud-course')!;
    int senderYearLevel = localPrefs.getInt('localstud-yearlevel')!;
    int senderSection = localPrefs.getInt('localstud-section')!;
    int completionYear = localPrefs.getInt('completion-year')!;
    String senderToken = localPrefs.getString('device-token')!;
    var putThreadMessage = ThreadMessage(
      thrMessageID: studID + '_' + uuid.v4(),
      thrMessageSender: studID,
      thrMessageDate: date,
      thrMessageContent: 'photo',
      thrSenderPhoto: senderPhoto,
      thrSenderName: senderName,
      thrSenderYearSection: senderYearLevel > completionYear
          ? 'Alumnus'
          : senderCourse +
              ' ' +
              senderYearLevel.toString() +
              '-' +
              senderSection.toString(),
      thrSenderToken: senderToken,
      threadMessagePhoto: commentPhoto,
    );
    firestoreService2.setThreadMessage(putThreadMessage, threadid);
    notifyListeners();
  }

  updateThreadMsgCount(String thrID) {
    firestoreService2.updateThrMsgCount(thrID);
    notifyListeners();
  }
}
