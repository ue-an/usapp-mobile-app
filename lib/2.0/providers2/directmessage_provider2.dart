import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:usapp_mobile/2.0/models/direct_message.dart';
import 'package:usapp_mobile/2.0/models/direct_messages_content.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/models/student.dart';
import 'package:uuid/uuid.dart';

class DirectMessageProvider2 with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();

  var uuid = Uuid();

  //id
  String? _dmID;
  String? _dmContent;
  List? _dmPhoto;
  List? _yearSecs;
  //sender
  String? _senderID;
  String? _senderEmail;
  String? _senderName;
  String? _senderYearSec;
  String? _senderPhotoUrl;
  String? _senderToken;
  StudentNumber _user = StudentNumber(
    studentNumber: '',
    lastName: '',
    firstName: '',
    mInitial: '',
    college: '',
    course: '',
    email: '',
    isused: false,
    yearLvl: 0,
    section: 0,
    photoUrl: '',
    about: '',
    deviceToken: '',
    isEnabled: false,
  );

  //reciever
  String? _recieverID;
  String? _recieverEmail;
  String? _recieverName;
  String? _recieverYearSec;
  String? _recieverPhotoUrl;
  String? _recieverToken;
  StudentNumber _peer = StudentNumber(
    studentNumber: '',
    lastName: '',
    firstName: '',
    mInitial: '',
    college: '',
    course: '',
    email: '',
    isused: false,
    yearLvl: 0,
    section: 0,
    photoUrl: '',
    about: '',
    deviceToken: '',
    isEnabled: false,
  );

  //get
  String? get dmID => _dmID;
  List? get dmPhoto => _dmPhoto;
  List? get yearSecs => _yearSecs;
  //sender
  String? get senderID => _senderID;
  String? get senderEmail => _senderEmail;
  String? get senderName => _senderName;
  String? get senderYearSec => _senderYearSec;
  String? get senderPhotoUrl => _senderPhotoUrl;
  String? get senderToken => _senderToken;
  StudentNumber? get user => _user;

  //reciever
  String? get recieverID => _recieverID;
  String? get recieverEmail => _recieverEmail;
  String? get recieverName => _recieverName;
  String? get recieverYearSec => _recieverYearSec;
  String? get recieverPhotoUrl => _recieverPhotoUrl;
  String? get recieverToken => _recieverToken;
  StudentNumber? get peer => _peer;

  //streams
  Stream<List<DirectMessagesContent>> get directMessagesContent =>
      firestoreService2.fetchDirectMessagesContent(
        _dmID!,
      );
  Stream<List<DirectMessage>> get membersWithConvos =>
      firestoreService2.fetchMembersWithConvos();

  //set
  //id
  set changeDmID(String dmid) {
    _dmID = dmid;
    notifyListeners();
  }

  set changeDMContent(String dmContent) {
    _dmContent = dmContent;
    notifyListeners();
  }

  //sender
  set changeSenderID(String senderID) {
    _senderID = senderID;
    notifyListeners();
  }

  set changeSenderEmail(String senderEmail) {
    _senderEmail = senderEmail;
    notifyListeners();
  }

  set changeSenderName(String senderName) {
    _senderName = senderName;
    notifyListeners();
  }

  set changeSenderYearSec(String senderYearSec) {
    _senderYearSec = senderYearSec;
    notifyListeners();
  }

  set changeSenderPhotoUrl(String senderPhotoUrl) {
    _senderPhotoUrl = senderPhotoUrl;
    notifyListeners();
  }

  set changeSenderToken(String senderToken) {
    _senderToken = senderToken;
    notifyListeners();
  }

  //reciever
  set changeRecieverID(String recieverID) {
    _recieverID = recieverID;
    notifyListeners();
  }

  set changeRecieverEmail(String recieverEmail) {
    _recieverEmail = recieverEmail;
    notifyListeners();
  }

  set changeRecieverName(String recieverName) {
    _recieverName = recieverName;
    notifyListeners();
  }

  set changeRecieverYearSec(String recieverYearSec) {
    _recieverYearSec = recieverYearSec;
    notifyListeners();
  }

  set changeRecieverPhotoUrl(String recieverPhotoUrl) {
    _recieverPhotoUrl = recieverPhotoUrl;
    notifyListeners();
  }

  set changeRecieverToken(String recieverToken) {
    _recieverToken = recieverToken;
    notifyListeners();
  }

  set changeUser(StudentNumber user) {
    _user = user;
    notifyListeners();
  }

  set changePeer(StudentNumber peer) {
    _peer = peer;
    notifyListeners();
  }

  //functions
  saveDirectMessageCollection() async {
    DateTime now = DateTime.now();
    var date = Timestamp.fromDate(now);
    var putDirectMessage = DirectMessage(
      dmID: _dmID!,
      users: [_senderEmail, _recieverEmail],
      photos: [_senderPhotoUrl, _recieverPhotoUrl],
      names: [_recieverName, _senderName],
      yearSecs: [_senderYearSec, recieverYearSec],
    );
    await firestoreService2.setDMSG(putDirectMessage, _dmID!);
    notifyListeners();
  }

  saveDirectMessageContent(String dmID) async {
    DateTime now = DateTime.now();
    var date = Timestamp.fromDate(now);
    var putDirectMessageContent = DirectMessagesContent(
      messageContentID: dmID + '-' + uuid.v4(),
      messageContent: _dmContent!,
      messageContentSent: date,
      senderName: _senderName!,
      senderYearSec: _senderYearSec!,
      senderPhoto: _senderPhotoUrl!,
      recieverName: _recieverName!,
      recieverYearSec: _recieverYearSec!,
      recieverPhoto: _recieverPhotoUrl!,
      isRead: false,
      recieverToken: _recieverToken!,
      senderToken: _senderToken!,
    );
    await firestoreService2.setDMSGContent(putDirectMessageContent, dmID);
    notifyListeners();
  }

  //------------------------------------------------------

  Future<List<DirectMessage>> fetchData() async {
    notifyListeners();
    return firestoreService2.waitMembersWithConvos();
  }
}
