import 'package:cloud_firestore/cloud_firestore.dart';

class ThreadMessage {
  final String thrMessageID;
  final String thrMessageSender;
  final Timestamp thrMessageDate;
  final String thrMessageContent;
  //--------------
  final String thrSenderPhoto;
  final String thrSenderName;
  final String thrSenderYearSection;
  final String thrSenderToken;
  final String threadMessagePhoto;

  ThreadMessage({
    required this.thrMessageID,
    required this.thrMessageSender,
    required this.thrMessageDate,
    required this.thrMessageContent,
    //-------
    required this.thrSenderPhoto,
    required this.thrSenderName,
    required this.thrSenderYearSection,
    required this.thrSenderToken,
    required this.threadMessagePhoto,
  });

  factory ThreadMessage.fromJson(Map<String, dynamic> json) {
    return ThreadMessage(
      thrSenderToken: json['sender_token'],
      thrMessageContent: json['thread_message_content'],
      thrMessageDate: json['thread_message_date'],
      thrMessageID: json['thread_message_id'],
      thrMessageSender: json['thread_message_sender_id'],
      thrSenderName: json['thread_sender_name'],
      thrSenderPhoto: json['thread_sender_photo'],
      thrSenderYearSection: json['thread_sender_year_section'],
      threadMessagePhoto: json['thread_message_photo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender_token': thrSenderToken,
      'thread_message_content': thrMessageContent,
      'thread_message_date': thrMessageDate,
      'thread_message_id': thrMessageID,
      'thread_message_sender_id': thrMessageSender,
      'thread_sender_name': thrSenderName,
      'thread_sender_photo': thrSenderPhoto,
      'thread_sender_year_section': thrSenderYearSection,
      'thread_message_photo': threadMessagePhoto,
    };
  }
}
