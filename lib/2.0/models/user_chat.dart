import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usapp_mobile/2.0/models/chat.dart';

class UserChat {
  final Timestamp date;
  final bool isRead;
  final String latestMessage;
  final String receiver;
  final String sender;
  // final Chat senderModel;
  // final Chat receiverModel;
  final List<Chat> chatters;
  final List<String> ids;
  final String chatid;

  UserChat({
    required this.date,
    // required this.senderModel,
    // required this.receiverModel,
    required this.chatters,
    required this.isRead,
    required this.latestMessage,
    required this.receiver,
    required this.sender,
    required this.ids,
    required this.chatid,
  });

  factory UserChat.fromJson(Map<String, dynamic> json) {
    return UserChat(
      date: json['date'],
      isRead: json['is_read'],
      latestMessage: json['latest_message'],
      receiver: json['receiver'],
      sender: json['sender'],
      ids: List<String>.from(json['student_ids']),
      chatid: json['chat_id'],
      // senderModel: Chat.fromJson(json['sender_model']),
      // receiverModel: Chat.fromJson(json['receiver_model']),
      chatters: List<Chat>.from(json['chatters']?.map((e) => Chat.fromJson(e))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chat_id': chatid,
      'date': date,
      'is_read': isRead,
      'latest_message': latestMessage,
      'receiver': receiver,
      'sender': sender,
      'student_ids': ids,
      'chatters': chatters.map((e) => e.toMap()).toList(),
      // 'sender_model': senderModel.toMap(),
      // 'receiver_model': receiverModel.toMap(),
    };
  }
}
