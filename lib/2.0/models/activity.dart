import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usapp_mobile/2.0/models/topicforum_screen.dart';

class Activity {
  Timestamp date;
  TopicForumScreen topicForumScreen;
  String title;
  String owner;
  String activityID;
  String comment;

  Activity({
    required this.date,
    required this.topicForumScreen,
    required this.title,
    required this.owner,
    required this.activityID,
    required this.comment,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      date: json['date'],
      topicForumScreen: TopicForumScreen.fromJson(json['forum_details']),
      title: json['title'],
      owner: json['activity_owner'],
      activityID: json['activity_id'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'forum_details': topicForumScreen.toMap(),
      'title': title,
      'activity_owner': owner,
      'activity_id': activityID,
      'comment': comment,
    };
  }
}
