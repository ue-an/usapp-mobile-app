import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:usapp_mobile/2.0/models/replyer.dart';
import 'package:usapp_mobile/2.0/models/thread_reply.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/models/student.dart';
import 'package:uuid/uuid.dart';

class ThreadReplyProvider with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();
  var uuid = Uuid();
  String? _threadID = '';
  String? _justReadThreadID = '';
  String? _replyForumID = '';
  String? _thrMessageID = '';
  String? _justReadthrMessageID = '';
  String? _replyForumCommentID = '';
  String? _replyID;
  String? _content;
  Replyer? _replyer;
  String? _name;
  String? _replyPhoto;
  String? _section;
  String? _studentNumber;
  List? _hasReplies;

  //

  changeThreadID(String threadID) {
    _threadID = threadID;
    // notifyListeners();
  }

  changeReplyForumID(String replyForumID) {
    _replyForumID = replyForumID;
    // notifyListeners();
  }

  changeJustReadThreadID(String justReadThreadID) {
    _justReadThreadID = justReadThreadID;
    // notifyListeners();
  }

  set changethrMessageID(String thrMessageID) {
    _thrMessageID = thrMessageID;
    notifyListeners();
  }

  set changeJustReadThrMessageID(String justReadThrMessageID) {
    _justReadthrMessageID = justReadThrMessageID;
    // notifyListeners();
  }

  set changeReplyForumCommentID(String replyForumCommentID) {
    _replyForumCommentID = replyForumCommentID;
    notifyListeners();
  }

  set changeReplyID(String replyID) {
    _replyID = replyID;
    notifyListeners();
  }

  set changeContent(String content) {
    _content = content;
    notifyListeners();
  }

  set changeReplyer(Replyer replyer) {
    _replyer = replyer;
    notifyListeners();
  }

  set changeStudentNumber(String studentNumber) {
    _studentNumber = studentNumber;
    notifyListeners();
  }

  set changeReplyPhoto(String replyPhoto) {
    _replyPhoto = replyPhoto;
    notifyListeners();
  }

  //
  String? get thrMessageID => _thrMessageID ?? '';
  String? get content => _content;
  Replyer? get replyer => _replyer;
  String? get threadID => _threadID;
  String? get justReadThreadID => _justReadThreadID;
  String? get justReadthrMessageID => _justReadthrMessageID ?? '';
  String? get replyForumID => _replyForumID;
  String? get replyForumCommentID => _replyForumCommentID;
  List? get hasReplies => _hasReplies;
  // Future<QuerySnapshot> get getThreadReply =>
  //     firestoreService2.getThreadReply(_threadID!, _thrMessageID!);
  Stream<List<ThreadReply>> get getThreadReplyy =>
      firestoreService2.getThreadReplyy(_threadID!, _thrMessageID!);

  Stream<List<ThreadReply>> get getThreadReplyy2 => firestoreService2
      .getThreadReplyy2(_justReadThreadID!, _justReadthrMessageID!);
  // Stream<List<ThreadReply>> get getThreadReplyy =>
  //     firestoreService2.getThreadReplyy(
  //       'aguinaldoian024@gmail.com1fd4e1ce-3da8-4209-a2ca-8c4ec3df48cc',
  //       '1011900222_5d3f75ed-cb0b-45c6-b26e-6aad223ca3e2',
  //     );

  //functions
  saveThreadReply() async {
    if (_content!.isNotEmpty || _content != '') {
      DateTime now = DateTime.now();
      var date = Timestamp.fromDate(now);
      var updatedForumReply = ThreadReply(
        photo: '',
        file: '',
        commentID: _replyForumCommentID!,
        content: _content!,
        replyID: _replyForumCommentID! + uuid.v4(),
        replyBy: _replyer!,
        replyDate: date,
      );
      await firestoreService2.setThreadReply(_replyForumID!, updatedForumReply);
      notifyListeners();
    }
  }

  saveImageReply() async {
    DateTime now = DateTime.now();
    var date = Timestamp.fromDate(now);
    var updatedForumReply = ThreadReply(
      photo: _replyPhoto,
      file: '',
      commentID: _replyForumCommentID!,
      content: 'photo',
      replyID: _replyForumCommentID! + uuid.v4(),
      replyBy: _replyer!,
      replyDate: date,
    );
    await firestoreService2.setThreadReply(_replyForumID!, updatedForumReply);
    notifyListeners();
  }

  justReadReplies() async {
    bool res = await firestoreService2.getJustReadThreadReplyy(
        _justReadThreadID!, _justReadthrMessageID!);
    _hasReplies!.add(res);
  }

  // getThreadReply(String commentID) {
  //   firestoreService2.getThreadReplyy(_threadID!, commentID);
  //   notifyListeners();
  // }

  // generateThreadReplyID(String thrTitle, String senderID) {
  //   String replyID = thrTitle + senderID;
  //   _replyID = replyID;
  // }
}
