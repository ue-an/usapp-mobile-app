import 'package:cloud_firestore/cloud_firestore.dart';

class DirectMessagesContent {
  final String messageContentID;
  final String messageContent;
  final Timestamp messageContentSent;
  final String senderName;
  final String senderYearSec;
  final String senderPhoto;
  final String recieverName;
  final String recieverYearSec;
  final String recieverPhoto;
  final bool isRead;
  final String recieverToken;
  final String senderToken;

  DirectMessagesContent({
    required this.messageContentID,
    required this.messageContent,
    required this.messageContentSent,
    required this.senderName,
    required this.senderYearSec,
    required this.senderPhoto,
    required this.recieverName,
    required this.recieverYearSec,
    required this.recieverPhoto,
    required this.isRead,
    required this.recieverToken,
    required this.senderToken,
  });

  factory DirectMessagesContent.fromJson(Map<String, dynamic> json) {
    return DirectMessagesContent(
      messageContentID: json['message_content_id'],
      messageContent: json['message_content'],
      messageContentSent: json['message_content_sent'],
      senderName: json['sender_name'],
      senderYearSec: json['sender_yearsection'],
      senderPhoto: json['sender_photo'],
      recieverName: json['reciever_name'],
      recieverYearSec: json['reciever_yearsection'],
      recieverPhoto: json['reciever_photo'],
      isRead: json['is_read'],
      recieverToken: json['reciever_token'],
      senderToken: json['sender_token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message_content_id': messageContentID,
      'message_content': messageContent,
      'message_content_sent': messageContentSent,
      'sender_name': senderName,
      'sender_yearsection': senderYearSec,
      'sender_photo': senderPhoto,
      'reciever_name': recieverName,
      'reciever_yearsection': recieverYearSec,
      'reciever_photo': recieverPhoto,
      'is_read': isRead,
      'reciever_token': recieverToken,
      'sender_token': senderToken,
    };
  }
}
