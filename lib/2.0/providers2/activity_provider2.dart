import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/models/activity.dart';
import 'package:usapp_mobile/2.0/models/topicforum_screen.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:uuid/uuid.dart';

class ActivityProvider2 with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();

  // late String forumID = '';
  // late String forumTitle = '';
  // late String forumDescription = '';
  // late String forumDate = '';
  // late String authorID = '';
  // late String authorName = '';
  // late String authorSection = '';
  // late String authorToken = '';
  // late List<String> likersTokens = [];
  // late String? title = '';
  late String? _activityID = '';
  Stream<List<Activity>> get getActivities => firestoreService2.getActivities();
  var uuid = Uuid();
  createActivity(
    String forumID,
    String forumTitle,
    String forumDescription,
    String forumDate,
    String authorID,
    String authorName,
    String authorSection,
    String authorToken,
    List likersTokens,
    String? title,
    String? owner,
    String? comment,
  ) async {
    SharedPreferences localPrefs = await SharedPreferences.getInstance();
    String email = localPrefs.getString('localstud-email')!;
    DateTime now = DateTime.now();
    var date = Timestamp.fromDate(now);
    _activityID = email + '_' + uuid.v4();
    var createdActivity = Activity(
      activityID: email + '_' + uuid.v4(),
      date: date,
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
      title: title!,
      owner: owner!,
      comment: comment!,
    );
    await firestoreService2.setActivity(createdActivity);
    notifyListeners();
  }

  deleteActivity() async {
    await firestoreService2.removeActivity(_activityID!);
  }
}
