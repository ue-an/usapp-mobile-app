import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/models/academic_year_dates.dart';
import 'package:usapp_mobile/2.0/models/activity.dart';
import 'package:usapp_mobile/2.0/models/chat.dart';
import 'package:usapp_mobile/2.0/models/course.dart';
import 'package:usapp_mobile/2.0/models/direct_message.dart';
import 'package:usapp_mobile/2.0/models/direct_messages_content.dart';
import 'package:usapp_mobile/2.0/models/notification_count.dart';
import 'package:usapp_mobile/2.0/models/notification.dart';
import 'package:usapp_mobile/2.0/models/replyer.dart';
import 'package:usapp_mobile/2.0/models/report.dart';
import 'package:usapp_mobile/2.0/models/request.dart';
import 'package:usapp_mobile/2.0/models/thread_message.dart';
import 'package:usapp_mobile/2.0/models/thread_reply.dart';
import 'package:usapp_mobile/2.0/models/user_chat.dart';
import 'package:usapp_mobile/2.0/providers2/notfuturedetails_provider2.dart';
import 'package:usapp_mobile/models/account.dart';
import 'package:usapp_mobile/models/student.dart';
import 'package:usapp_mobile/models/thread.dart';
import 'package:usapp_mobile/screens/bottomnav/directmsg_screen.dart';

class FirestoreService2 {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String userEmail;
  //validate email
  verifyEmail({required String studnum, required String email}) async {
    final snapshot1 = await _db.collection('students').doc(studnum).get();
    var userDocument = snapshot1.data();
    var emailfield = userDocument!['email'];
    if (emailfield == email) {
      return true;
    } else {
      return false;
    }
  }

  // validate student number
  verify({required String studnum}) async {
    final snapshot1 = await _db.collection('students').doc(studnum).get();
    if (snapshot1.exists) {
      if (snapshot1.data()!['is_used'] == false) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  //setting student number to 'used'
  useNow({required String studnum}) async {
    try {
      await _db.collection('students').doc(studnum).update({'is_used': true});
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //auth && student accounts
  //signin student account
  logIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('userstatus', email);
      await pref.setString('localstud-email', email);
      // pref.setString('photoURL', '');
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      // return false;
      // print('i\'m here');
      if (e.code == 'invalid-email') {
        print('invalid email');
        return false;
      } else if (e.code == 'user-disabled') {
        print('user-disabled');
        return false;
      } else if (e.code == 'user-not-found') {
        print('user-not-found');
        return false;
      } else if (e.code == 'wrong-password') {
        print('wrong password');
        return false;
      } else {
        print('object');
        return false;
      }
    }
  }

  signOut() async {
    await _firebaseAuth.signOut();
  }

  //create student account/register
  registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // print('registered');
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('userstatus', email);
      // await pref.setString('localstud-email', email);
      var initStudent = getCurrentStudent().first;
      for (var firstStudent in await initStudent) {
        await pref.setString('localstud-firstname', firstStudent.firstName);
        await pref.setString('localstud-minitial', firstStudent.mInitial);
        await pref.setString('localstude-lastname', firstStudent.lastName);
        await pref.setString(
            'localstud-studentNum', firstStudent.studentNumber);
        await pref.setString('localstud-college', firstStudent.college);
        await pref.setString('localstud-course', firstStudent.course);
        await pref.setInt('localstud-yearlevel', firstStudent.yearLvl);
        await pref.setInt('localstud-yearsection', firstStudent.section);
        await pref.setString('localstud-email', firstStudent.email);
        await pref.setString('localstud-photo', firstStudent.photoUrl);
        await pref.setString('localstud-about', firstStudent.about);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      return false;
    }
  }

  //checks if user account is_enabled == true
  getUserAccountEnable(String email) async {
    final snap = await _db
        .collection('students')
        .where('email', isEqualTo: email)
        .where('is_enabled', isEqualTo: true)
        .get();
    if (snap.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //add to firebase storage collections
  setAccount(Account account) async {
    var options = SetOptions(merge: true);
    try {
      await _db
          .collection('accounts')
          .doc(account.email)
          .set(account.toMap(), options);
      print('added to accounts');
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //update photoURL in collection first time
  updatePhotoUrlFirstTime(String studentNumber, String photoUrl) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('students').doc(studentNumber).update(
        {
          'photo_url': photoUrl,
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  updatePhotoUrlFromProfile(String studentNumber, String photoUrl) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('students').doc(studentNumber).update(
        {
          'photo_url': photoUrl,
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //update about in collection first time
  updateAboutFirstTime(String studentNumber, String about) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('students').doc(studentNumber).update(
        {
          'about': about,
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  updateAboutFromProfile(String studentNumber, String about) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('students').doc(studentNumber).update(
        {
          'about': about,
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //====
  Stream<List<StudentNumber>> getCurrentStudent() {
    return _db
        .collection('students')
        .where('email', isEqualTo: _firebaseAuth.currentUser!.email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentNumber.fromJson(doc.data()))
            .toList());
  }

  Future<List<StudentNumber>> waitCurrentStudent() async {
    return await getCurrentStudent().first;
  }

  //====
  Stream<StudentNumber> getFirstCurrentStudentUrl(String studentNumber) {
    return _db
        .collection('students')
        .doc(studentNumber)
        .snapshots()
        .map((snapshot) => StudentNumber.fromJson(snapshot.data()!));
  }

  getCurrentStudentUrl() async {
    var collection = _db.collection('students');
    var querySnapshot = await collection
        .where('email', isEqualTo: _firebaseAuth.currentUser!.email)
        .get();
    return querySnapshot.docs[0]['photo_url'];
  }

  getCurrentUserEmail() async {
    var curUserEmail = await _firebaseAuth.currentUser!.email;
    return curUserEmail;
  }

  //update student photo url
  setPhotoURL(String url) async {
    var collection = _db.collection('students');
    var querySnapshot = await collection
        .where('email', isEqualTo: _firebaseAuth.currentUser!.email)
        .get();
    for (var snapshot in querySnapshot.docs) {
      Map<String, dynamic> data = snapshot.data();
      var collection = _db.collection('students');
      var querySnapshot = await collection
          .doc(data['student_number'])
          .update({'photo_url': url});
      // print(data['is_used']);
    }
  }

  //THREADS
  //upsert
  Future<void> setThread(Thread thread) {
    var options = SetOptions(merge: true);
    return _db
        .collection('threads')
        .doc(thread.id)
        .set(thread.toMap(), options);
  }

  //get
  Stream<List<Thread>> fetchThreadss(String thrCollege) {
    return _db
        .collection('threads')
        // .orderBy('create_date', descending: true)
        .where('college', isEqualTo: thrCollege)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Thread.fromJson(doc.data())).toList());
  }

  Future<List<Thread>> filteredThreads(String thrCollege) async {
    return await fetchThreadss(thrCollege).first;
  }

  Stream<List<Thread>> fetchThreads() {
    return _db
        .collection('threads')
        // .orderBy('create_date', descending: true)
        // .where('college', isEqualTo: thrCollege)
        .where('is_reported', isEqualTo: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Thread.fromJson(doc.data())).toList());
  }

  Future<List<Thread>> waitThreads() async {
    // return await getThreads().first;
    return await fetchThreads().first;
  }

  removeThread(String threadID, bool isRemoved) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('threads').doc(threadID).update(
        {
          'is_deleted_by_owner': isRemoved,
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //get searched items/threads
  Stream<List<Thread>> fetchSearchedThreads(String thrTitle) {
    return _db
        .collection('threads')
        // .orderBy('create_date', descending: true)
        .where('title', isEqualTo: thrTitle)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Thread.fromJson(doc.data())).toList());
  }

  //future
  Future<List<Thread>> getSearchedThreads(String thrTitle) async {
    return await fetchSearchedThreads(thrTitle).first;
  }

  updateThrMsgCount(String thrID) async {
    try {
      await _db.collection('threads').doc(thrID).update(
        {
          'msg_sent': FieldValue.increment(1),
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //
  Stream<List<StudentNumber>> fetchSearchedMembers(String studName) {
    List splitted = studName.split(' ');
    return _db
        .collection('students')
        // .orderBy('create_date', descending: true)
        .where('first_name', isEqualTo: splitted[0])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentNumber.fromJson(doc.data()))
            .toList());
  }

  Future<List<StudentNumber>> getSearchedStudents(String studName) async {
    return await fetchSearchedMembers(studName).first;
  }

  //THREADS MESSAGES
  //upsert
  //add subcollection 'thread_messages'
  Future<void> setThreadMessage(ThreadMessage threadmessage, String threadid) {
    var options = SetOptions(merge: false);
    return _db
        .collection('threads')
        .doc(threadid)
        .collection('thread_messages')
        .doc(threadmessage.thrMessageID)
        // .set(thread.toMap(), options);
        .set(threadmessage.toMap(), options);
  }

  //get
  Stream<List<ThreadMessage>> fetchThreadMessages(String thrID) {
    return _db
        .collection('threads')
        .doc(thrID)
        .collection('thread_messages')
        // .where('thread_id', isEqualTo: thrID)
        .orderBy('thread_message_date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ThreadMessage.fromJson(doc.data()))
            .toList());
  }

  //MEMBERS
  Stream<List<StudentNumber>> fetchMembers() {
    return _db
        .collection('students')
        .where('is_used', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StudentNumber.fromJson(doc.data()))
            .toList());
  }

  //get members (future)
  Future<List<StudentNumber>> waitMembers() async {
    var n = fetchMembers();
    return await fetchMembers().first;
  }

  //DIRECT MESSAGES (collection, not messages itself)
  //upsert
  Future<void> setDMSG(DirectMessage directmessage, String dmID) {
    var options = SetOptions(merge: true);
    return _db
        .collection('direct_messages')
        .doc(dmID)
        .set(directmessage.toMap(), options);
  }

  //DIRECT MESSAGES CONTENTS
  //put
  Future<void> setDMSGContent(
      DirectMessagesContent directMessagesContent, String convoID) {
    var options = SetOptions(merge: true);
    // print('DMS content id: ' + convoID);
    return _db
        .collection('direct_messages')
        .doc(convoID)
        .collection('direct_messages_content')
        .doc(directMessagesContent.messageContentID)
        .set(directMessagesContent.toMap(), options);
  }

  //get
  Stream<List<DirectMessagesContent>> fetchDirectMessagesContent(String dmID) {
    return _db
        .collection('direct_messages')
        .doc(dmID)
        .collection('direct_messages_content')
        // .where('sender_name', isEqualTo: senderName)
        .orderBy('message_content_sent', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DirectMessagesContent.fromJson(doc.data()))
            .toList());
  }

  //WITH EXISTING CONVERSATIONS
  //get
  Stream<List<DirectMessage>> fetchMembersWithConvos() {
    return _db
        .collection('direct_messages')
        .where('users', arrayContains: _firebaseAuth.currentUser!.email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DirectMessage.fromJson(doc.data()))
            .toList());
  }

  //future
  Future<List<DirectMessage>> waitMembersWithConvos() async {
    var n = fetchMembersWithConvos();
    return await fetchMembersWithConvos().first;
  }

  //REPORT
  //upsert
  Future<void> setReport(Report report, String reportID) {
    var options = SetOptions(merge: true);
    return _db.collection('reports').doc(reportID).set(report.toMap(), options);
  }

  //update report properties
  updateReportFields(String reportID, reporterName, reason) async {
    try {
      await _db.collection('reports').doc(reportID).update(
        {
          'reporters': FieldValue.arrayUnion([reporterName]),
          'reasons': FieldValue.arrayUnion([reason]),
          'report_count': FieldValue.increment(1),
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //update thread report emails who clickd
  updateThrReportClicked(String threadID, reporterEmail) async {
    try {
      await _db.collection('threads').doc(threadID).update(
        {
          'reporters': FieldValue.arrayUnion([reporterEmail]),
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //REQUEST DTLS UPD
  //upsert
  Future<void> setRequest(Request request) {
    var options = SetOptions(merge: true);
    return _db
        .collection('requests')
        .doc(request.currEmail)
        .set(request.toMap(), options);
  }

  //get (retrieve)
  Stream<Request> getRequests(String email) {
    return _db
        .collection('requests')
        .doc(email)
        .snapshots()
        .map((snapshot) => Request.fromJson(snapshot.data()!));
  }

  //LIKES
  setLike(String threadID, String likerName) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('threads').doc(threadID).update(
        {
          'likers': FieldValue.arrayUnion([likerName]),
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  removeLike(String threadID, String likerName) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('threads').doc(threadID).update(
        {
          'likers': FieldValue.arrayRemove([likerName]),
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  updateLikerID(String threadID, String likerID) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('threads').doc(threadID).update(
        {
          'likers_ids': FieldValue.arrayUnion([likerID]),
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  removeLikerID(String threadID, String likerID) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('threads').doc(threadID).update(
        {
          'likers_ids': FieldValue.arrayRemove([likerID]),
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //CHAT DMPM
  //upsert
  saveUserChat(UserChat userchat) async {
    var options = SetOptions(merge: true);
    try {
      await _db
          .collection('user_chats')
          .doc(userchat.chatid)
          .set(userchat.toMap(), options);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //update chat
  updateUserChatSender(String chatID, Chat senderChat) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('user_chats').doc(chatID).update(
        {
          'chatters': FieldValue.arrayUnion([senderChat.toMap()]),
        },
      );

      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  updateUserChatReceiver(String chatID, Chat receiverChat) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('user_chats').doc(chatID).update(
        {
          'chatters': FieldValue.arrayUnion([receiverChat.toMap()]),
        },
      );

      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //get chat
  Stream<List<UserChat>> getLastColl() {
    return _db
        .collection('user_chats')
        .where('student_ids', arrayContains: _firebaseAuth.currentUser!.email)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserChat.fromJson(doc.data())).toList());
  }

  updateReadChat(String chatID) {
    return _db.collection('user_chats').doc(chatID).update(
      {
        'is_read': true,
      },
    );
  }

  updateReceiverSenderMail(
      {required String SenderMail, required String ReceiverMail, chatID}) {
    return _db.collection('user_chats').doc(chatID).update({
      'receiver': ReceiverMail,
      'sender': SenderMail,
    });
  }

  //THREAD REPLIES
  //upsert
  setThreadReply(String threadID, ThreadReply threadReply) async {
    var options = SetOptions(merge: false);
    try {
      await _db
          .collection('threads')
          .doc(threadID)
          .collection('thread_replies')
          .doc(threadReply.replyID)
          .set(threadReply.toMap(), options);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //get
  // Future<QuerySnapshot> getThreadReply(
  //     String threadID, String thrMessageID) async {
  //   return await _db
  //       .collection('threads')
  //       .doc(threadID)
  //       .collection('thread_messages')
  //       .doc(thrMessageID)
  //       .collection('thread_replies')
  //       .where('comment_id', isEqualTo: thrMessageID)
  //       .get();
  // .snapshots()
  // .map((snapshot) => snapshot.docs
  //     .map((doc) => ThreadReply.fromJson(doc.data()))
  //     .toList());
  // }

  Stream<List<ThreadReply>> getThreadReplyy(
      String threadID, String thrMessageID) {
    return _db
        .collection('threads')
        .doc(threadID)
        .collection('thread_replies')
        .where('comment_id', isEqualTo: thrMessageID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ThreadReply.fromJson(doc.data()))
            .toList());
  }

  Stream<List<ThreadReply>> getThreadReplyy2(
      String threadID, String thrMessageID) {
    return _db
        .collection('threads')
        .doc(threadID)
        .collection('thread_replies')
        .where('comment_id', isEqualTo: thrMessageID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ThreadReply.fromJson(doc.data()))
            .toList());
  }

  getJustReadThreadReplyy(String threadID, String thrMessageID) async {
    var options = SetOptions(merge: true);
    try {
      await _db
          .collection('threads')
          .doc(threadID)
          .collection('thread_replies')
          .where('comment_id', isEqualTo: thrMessageID)
          .get();
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //DEVICE TOKEN
  updateDeviceToken(
      {required String studnum, required String deviceToken}) async {
    try {
      await _db.collection('students').doc(studnum).update(
        {
          'device_token': deviceToken,
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  setLikerToken(String threadID, String likerToken) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('threads').doc(threadID).update(
        {
          'likers_tokens': FieldValue.arrayUnion([likerToken]),
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  removeLikerToken(String threadID, String likerToken) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('threads').doc(threadID).update(
        {
          'likers_tokens': FieldValue.arrayRemove([likerToken]),
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //FORUM NOTIFICATIONS
  //upsert
  setUsappNotification(UsappNotification notifications) async {
    var options = SetOptions(merge: false);
    try {
      await _db
          .collection('notifications')
          .doc(notifications.notifID)
          .set(notifications.toMap(), options);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  decreaseNotifCount({required String ownerEmail}) async {
    try {
      await _db.collection('notifications_count').doc(ownerEmail).update(
        {
          'notif_count': FieldValue.increment(-1),
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //get
  Stream<List<UsappNotification>> getUsappNotifications() {
    return _db
        .collection('notifications')
        // .where('notif_owner', isEqualTo: mystudentnumber)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UsappNotification.fromJson(doc.data()))
            .toList());
  }

  //ACTIVITIES
  //insert
  setActivity(Activity activity) async {
    try {
      await _db
          .collection('activities')
          .doc(activity.activityID)
          .set(activity.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  //get
  Stream<List<Activity>> getActivities() {
    return _db
        .collection('activities')
        .where('activity_owner', isEqualTo: _firebaseAuth.currentUser!.email)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Activity.fromJson(doc.data())).toList());
  }

  //delete
  removeActivity(String activityID) async {
    try {
      await _db.collection('activities').doc(activityID).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  //ACADEMIC YEAR DATES
  //get
  Stream<List<AcademicYearDates>> getAcademicYearDates() {
    return _db.collection('academic_year').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => AcademicYearDates.fromJson(doc.data()))
            .toList());
  }

  //AUTO UPDATE YEARLEVEL
  updateYearLevel(String studentNumber) async {
    var options = SetOptions(merge: true);
    try {
      await _db.collection('students').doc(studentNumber).update(
        {
          'year_level': FieldValue.increment(1),
        },
      );
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  //GET COURSE
  //get
  Stream<List<Course>> getCourses() {
    return _db.collection('courses').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Course.fromJson(doc.data())).toList());
  }
}
