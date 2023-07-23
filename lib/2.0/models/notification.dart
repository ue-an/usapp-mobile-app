import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usapp_mobile/2.0/models/topicforum_screen.dart';

class UsappNotification {
  Timestamp notifDate;
  TopicForumScreen topicForumScreen;
  String notifTitle;
  String notifOwner;
  String notifID;
  String comment;

  UsappNotification({
    required this.notifDate,
    required this.topicForumScreen,
    required this.notifTitle,
    required this.notifOwner,
    required this.notifID,
    required this.comment,
  });

  factory UsappNotification.fromJson(Map<String, dynamic> json) {
    return UsappNotification(
      topicForumScreen: TopicForumScreen.fromJson(json['forum_details']),
      notifDate: json['notif_date'],
      notifID: json['notif_id'],
      notifOwner: json['notif_owner'],
      notifTitle: json['notif_title'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'forum_details': topicForumScreen.toMap(),
      'notif_date': notifDate,
      'notif_id': notifID,
      'notif_owner': notifOwner,
      'notif_title': notifTitle,
      'comment': comment,
    };
  }
}
