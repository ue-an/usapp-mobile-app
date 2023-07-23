import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:usapp_mobile/2.0/models/chat.dart';
import 'package:usapp_mobile/2.0/models/direct_messages_content.dart';
import 'package:usapp_mobile/2.0/models/user_chat.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:uuid/uuid.dart';

class DirectMessagesContentProvider2 with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();
  var uuid = Uuid();
  late String _senderName = '';
  late String _senderPhotoUrl = '';
  late String _senderYearSec = '';
  late String _receiverName = '';
  late String _receiverPhotoUrl = '';
  late String _receiverYearSec = '';
  late String _latestMessage = '';
  late String _receiverEmail = '';
  late List<String> _ids = [];
  late String _chatid = '';
  late String _senderEmail = '';
  late String _senderToken = '';
  late String _receiverToken = '';
  //
  //id
  String? _dmID;
  String? _dmContent;
  List? _dmPhoto;
  List? _yearSecs;

  //set
  set changeSenderName(String senderName) {
    _senderName = senderName;
    notifyListeners();
  }

  set changeSenderPhotoUrl(String senderPhotoUrl) {
    _senderPhotoUrl = senderPhotoUrl;
    notifyListeners();
  }

  set changeSenderYearSec(String senderYearSec) {
    _senderYearSec = senderYearSec;
    notifyListeners();
  }

  set changeReceiverName(String receiverName) {
    _receiverName = receiverName;
    notifyListeners();
  }

  set changeReceiverPhotoUrl(String receiverPhotoUrl) {
    _receiverPhotoUrl = receiverPhotoUrl;
    notifyListeners();
  }

  set changeReceiverYearSec(String receiverYearSec) {
    _receiverYearSec = receiverYearSec;
    notifyListeners();
  }

  set changeLatestMessage(String latestMessage) {
    _latestMessage = latestMessage;
    notifyListeners();
  }

  set changeReceiverEmail(String receiverEmail) {
    _receiverEmail = receiverEmail;
    notifyListeners();
  }

  set changeIDS(List<String> ids) {
    _ids = ids;
    notifyListeners();
  }

  set changeChatID(String chatid) {
    _chatid = chatid;
    notifyListeners();
  }

  set changeSenderEmail(String senderEmail) {
    _senderEmail = senderEmail;
    notifyListeners();
  }

  set changeSenderToken(String senderToken) {
    _senderToken = senderToken;
    notifyListeners();
  }

  set changeReceiverToken(String receiverToken) {
    _receiverToken = receiverToken;
    notifyListeners();
  }

  //get
  String get senderName => _senderName;
  String get senderPhotoUrl => _senderPhotoUrl;
  String get senderYerSec => _senderYearSec;
  String get receiverName => _receiverName;
  String get receiverPhotoUrl => _receiverPhotoUrl;
  String get receiverYearSec => _receiverYearSec;
  String get latestMessage => _latestMessage;
  String get receiverEmail => _receiverEmail;
  List<String> get ids => _ids;
  String get chatid => _chatid;
  String get senderEmail => _senderEmail;
  String get senderToken => _senderToken;
  String get receiverToken => _receiverToken;

  //function
  saveUserChat() async {
    DateTime now = DateTime.now();
    var date = Timestamp.fromDate(now);
    var createdUserChat = UserChat(
        date: date,
        chatters: [
          Chat(
            name: _senderName,
            photo: _senderPhotoUrl,
            section: _senderYearSec,
            token: _senderToken,
          ),
          Chat(
            name: _receiverName,
            photo: _receiverPhotoUrl,
            section: _receiverYearSec,
            token: _receiverToken,
          )
        ],
        isRead: false,
        latestMessage: _latestMessage,
        receiver: _receiverEmail,
        sender: _senderEmail,
        ids: _ids,
        chatid: _chatid);
    bool res = await firestoreService2.saveUserChat(createdUserChat);
    notifyListeners();
    return res;
  }

  updateChat() {
    firestoreService2.updateReadChat(_chatid);
    notifyListeners();
  }

  updateReceiverSenderMail(
      {required String receiverMail, required String senderMail}) {
    firestoreService2.updateReceiverSenderMail(
      SenderMail: senderMail,
      ReceiverMail: receiverMail,
      chatID: _chatid,
    );
    notifyListeners();
  }

  updateUserChatSender() async {
    await firestoreService2.updateUserChatSender(
      _chatid,
      Chat(
        name: _senderName,
        photo: _senderPhotoUrl,
        section: _senderYearSec,
        token: _senderToken,
      ),
    );
    notifyListeners();
  }

  // saveDirectMessageContent(String dmID) async {
  //   DateTime now = DateTime.now();
  //   var date = Timestamp.fromDate(now);
  //   var putDirectMessageContent = DirectMessagesContent(
  //     messageContentID: dmID + '-' + uuid.v4(),
  //     messageContent: _dmContent!,
  //     messageContentSent: date,
  //     senderName: _senderName,
  //     senderYearSec: _senderYearSec,
  //     senderPhoto: _senderPhotoUrl,
  //     recieverName: _receiverName,
  //     recieverYearSec: _receiverYearSec,
  //     recieverPhoto: _receiverPhotoUrl,
  //     isRead: false,
  //     recieverToken: _receiverToken,
  //     senderToken: _senderToken,
  //   );
  //   await firestoreService2.setDMSGContent(putDirectMessageContent, dmID);
  //   notifyListeners();
  // }
}
