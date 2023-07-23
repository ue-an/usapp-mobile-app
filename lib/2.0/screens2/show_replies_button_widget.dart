import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:usapp_mobile/2.0/models/replyer.dart';
import 'package:usapp_mobile/2.0/models/thread_reply.dart';
import 'package:usapp_mobile/2.0/providers2/activity_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/threadreply_provider.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/upload_image/upload_image_provider.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_provider.dart';
import 'package:usapp_mobile/2.0/screens2/threadroom_screen2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ShowRepliesButtonWidget extends StatefulWidget {
  String commentID;
  String myFullName;
  String myEmail;
  String myDeviceToken;
  String myStudentNumber;
  String mySection;
  String commentContent;
  String commenterToken;
  List<String> othersNames;
  String threadID;
  String threadTitle;
  String threadDescription;
  String formattedDate;
  String threadCreatorID;
  String creatorSection;
  String creatorName;
  List likersTokens;
  String authorToken;

  ShowRepliesButtonWidget({
    Key? key,
    required this.commentID,
    required this.commentContent,
    required this.commenterToken,
    required this.myDeviceToken,
    required this.myEmail,
    required this.myFullName,
    required this.myStudentNumber,
    required this.mySection,
    required this.othersNames,
    required this.threadID,
    required this.threadTitle,
    required this.threadDescription,
    required this.formattedDate,
    required this.threadCreatorID,
    required this.creatorSection,
    required this.creatorName,
    required this.likersTokens,
    required this.authorToken,
  }) : super(key: key);

  @override
  State<ShowRepliesButtonWidget> createState() =>
      _ShowRepliesButtonWidgetState();
}

class _ShowRepliesButtonWidgetState extends State<ShowRepliesButtonWidget>
    with AutomaticKeepAliveClientMixin<ShowRepliesButtonWidget> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;

  FirestoreService2 firestoreService2 = FirestoreService2();
  late Stream<List<ThreadReply>> _streamThreadReply =
      context.read<ThreadReplyProvider>().getThreadReplyy2;

  final replyCtrl = TextEditingController();

  @override
  void initState() {
    setState(() {
      _isVisited = true;
    });
    // _streamThreadReply = context.read<ThreadReplyProvider>().getThreadReplyy2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<ThreadReply>>(
      stream: _streamThreadReply,
      builder: (context, replySnap) {
        // if (replySnap.connectionState == ConnectionState.waiting) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        if (replySnap.hasData) {
          replySnap.data!.sort((a, b) => a.replyDate.compareTo(b.replyDate));
          return replySnap.data!.isNotEmpty
              ? const Text(
                  'Show Replies',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              : const Text('No Replies',
                  style: TextStyle(
                    color: Colors.grey,
                  ));
        } else {
          return const Text(
            'HEY NO REPLIES',
            style: TextStyle(
              color: Colors.grey,
            ),
          );
        }
      },
    );
  }
}
