import 'package:cloud_firestore/cloud_firestore.dart';

class Thread {
  final String id;
  final String title;
  final int msgSent;
  final String studID;
  final Timestamp tSdate;
  final String college;
  final String creatorName;
  final String creatorSection;
  final bool isReported;
  final List reportersEmail;
  final List likers;
  final String description;
  final bool isDeletedByOwner;
  final List likersTokens;
  final String authorToken;
  final List likersIDs;
  //
  const Thread({
    required this.id,
    required this.title,
    required this.msgSent,
    required this.studID,
    required this.college,
    required this.creatorName,
    required this.creatorSection,
    required this.tSdate,
    required this.isReported,
    required this.reportersEmail,
    required this.likers,
    required this.description,
    required this.isDeletedByOwner,
    required this.likersTokens,
    required this.authorToken,
    required this.likersIDs,
  });

  //2.0
  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      authorToken: json['author_token'],
      college: json['college'],
      tSdate: json['create_date'],
      creatorName: json['creator_name'],
      creatorSection: json['creator_section'],
      description: json['description'],
      isDeletedByOwner: json['is_deleted_by_owner'],
      isReported: json['is_reported'],
      likers: json['likers'],
      likersTokens: json['likers_tokens'],
      msgSent: json['msg_sent'],
      reportersEmail: json['reporters'],
      studID: json['thread_creator'],
      id: json['thread_id'],
      title: json['title'],
      likersIDs: json['likers_ids'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'create_date': date,
      'msg_sent': msgSent,
      'thread_creator': studID,
      'thread_id': id,
      'title': title,
      'creator_name': creatorName,
      'college': college,
      'creator_section': creatorSection,
      'create_date': tSdate,
      'is_reported': isReported,
      'reporters': reportersEmail,
      'description': description,
      'likers': likers,
      'is_deleted_by_owner': isDeletedByOwner,
      'likers_tokens': likersTokens,
      'author_token': authorToken,
      'likers_ids': likersIDs,
    };
  }
}
