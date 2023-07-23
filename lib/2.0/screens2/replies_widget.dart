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

class RepliesWidget extends StatefulWidget {
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

  RepliesWidget({
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
  State<RepliesWidget> createState() => _RepliesWidgetState();
}

class _RepliesWidgetState extends State<RepliesWidget>
    with AutomaticKeepAliveClientMixin<RepliesWidget> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;

  FirestoreService2 firestoreService2 = FirestoreService2();
  late Stream<List<ThreadReply>> _streamThreadReply =
      context.read<ThreadReplyProvider>().getThreadReplyy;
  final replyCtrl = TextEditingController();

  _launchURL(String replyUrl) async {
    final url = replyUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    setState(() {
      _isVisited = true;
    });
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
          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: replySnap.data!.length,
            itemBuilder: (context, index) {
              ThreadReply reply;
              reply = replySnap.data![index];
              Replyer replyer = reply.replyBy;
              DateTime myDateTime = reply.replyDate.toDate();
              String formattedDate = timeago.format(
                myDateTime,
                locale: 'en_short',
              );
              print(reply.toMap());
              return IntrinsicHeight(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.width * .1,
                      ),
                      child: const VerticalDivider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // padding: EdgeInsets.only(
                        //   left: size.width * .1,
                        // ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                replyer.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                replyer.section,
                                style: const TextStyle(
                                  color: Colors.white30,
                                  fontSize: 9,
                                ),
                              ),
                              Container(
                                // padding: EdgeInsets.only(
                                //   left: size.width * .02,
                                // ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   reply.content,
                                    //   style: const TextStyle(
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                    reply.photo != ''
                                        ? Image.network(
                                            reply.photo!,
                                            // height: size.height,
                                            width: size.width,
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                // top: 5.0,
                                                // bottom: 16.0,
                                                ),
                                            child: MarkdownBody(
                                              data: _replaceMentions(
                                                reply.content,
                                              ).replaceAll('\n', '\\\n'),
                                              onTapLink: (
                                                String link,
                                                String? href,
                                                String title,
                                              ) {
                                                // print('Link clicked with $link');
                                                _launchURL('$link');
                                              },
                                              builders: {
                                                "coloredBox":
                                                    ColoredBoxMarkdownElementBuilder(
                                                        context,
                                                        widget.othersNames,
                                                        widget.myFullName),
                                              },
                                              inlineSyntaxes: [
                                                ColoredBoxInlineSyntax(),
                                              ],
                                              styleSheet:
                                                  MarkdownStyleSheet.fromTheme(
                                                Theme.of(context).copyWith(
                                                  textTheme: Theme.of(context)
                                                      .textTheme
                                                      .apply(
                                                        bodyColor: Colors.white,
                                                        fontSizeFactor: 1,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    Text(
                                      'Replied • ' + formattedDate,
                                      style: const TextStyle(
                                        color: Colors.white30,
                                        fontSize: 9,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: size.width * .15,
                                      ),
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              //CHANGE REPLY VALUES BEFORE TO FIREBASE
                                              context
                                                  .read<ThreadReplyProvider>()
                                                  .changeReplyer = Replyer(
                                                name: widget.myFullName,
                                                section: widget.mySection,
                                                studentNumber:
                                                    widget.myStudentNumber,
                                                token: widget.myDeviceToken,
                                              );
                                              context
                                                  .read<ThreadReplyProvider>()
                                                  .changeReplyForumID(
                                                      widget.threadID);
                                              context
                                                      .read<ThreadReplyProvider>()
                                                      .changeReplyForumCommentID =
                                                  widget.commentID;
                                              //REPLY TEXTAREA
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) {
                                                  return AnimatedPadding(
                                                    duration: const Duration(
                                                        milliseconds: 150),
                                                    curve: Curves.easeOut,
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .27,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: 12,
                                                          left: 12,
                                                          right: 12,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Reply',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20.0,
                                                            ),
                                                            //REPLY TEXTFIELD
                                                            TextFormField(
                                                              minLines: 2,
                                                              maxLines: 4,
                                                              // maxLength: 600,
                                                              // controller: replyCtrl,
                                                              // labelText:
                                                              //     'Write a reply',
                                                              initialValue: replySnap
                                                                          .data![
                                                                              index]
                                                                          .replyBy
                                                                          .name !=
                                                                      widget
                                                                          .myFullName
                                                                  ? '@' +
                                                                      replySnap
                                                                          .data![
                                                                              index]
                                                                          .replyBy
                                                                          .name +
                                                                      ' '
                                                                  : '',
                                                              onChanged: (value) => context
                                                                  .read<
                                                                      ThreadReplyProvider>()
                                                                  .changeContent = value,
                                                              decoration:
                                                                  InputDecoration(
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              24.0),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: context
                                                                            .read<
                                                                                ThemeProvider2>()
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : kPrimaryColor,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              24.0),
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: context
                                                                            .read<
                                                                                ThemeProvider2>()
                                                                            .isDark
                                                                        ? Colors
                                                                            .lightBlue
                                                                        : kPrimaryColor,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                                labelStyle:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  // color: kPrimaryColor,
                                                                  color: context
                                                                          .read<
                                                                              ThemeProvider2>()
                                                                          .isDark
                                                                      ? Colors
                                                                          .white
                                                                      : kPrimaryColor,
                                                                ),
                                                                prefixIcon: Icon(
                                                                    Icons.reply,
                                                                    color: context
                                                                            .read<
                                                                                ThemeProvider2>()
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : kPrimaryColor),
                                                              ),
                                                            ),
                                                            //REPLY BUTTONS
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                //PHOTO REPLY BUTTON
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    //pick photo from phone storage
                                                                    final results =
                                                                        await FilePicker
                                                                            .platform
                                                                            .pickFiles(
                                                                      allowMultiple:
                                                                          false,
                                                                      type: FileType
                                                                          .custom,
                                                                      allowedExtensions: [
                                                                        'png',
                                                                        'jpg'
                                                                      ],
                                                                    );
                                                                    //set photo as reply
                                                                    if (results !=
                                                                        null) {
                                                                      //get the file path and filename (photo)
                                                                      final path = results
                                                                          .files
                                                                          .single
                                                                          .path;
                                                                      final fileName = results
                                                                          .files
                                                                          .single
                                                                          .name;
                                                                      //store in firebase storage
                                                                      //save image to firebase storage
                                                                      context
                                                                          .read<
                                                                              UploadImageProvider>()
                                                                          .changeStorageFilePath = File(path!);
                                                                      await context
                                                                          .read<
                                                                              UploadImageProvider>()
                                                                          .uploadReplyPhoto(
                                                                              path,
                                                                              fileName)
                                                                          .then((value) =>
                                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                                const SnackBar(
                                                                                  content: Text('Reply sent successfully'),
                                                                                  duration: Duration(milliseconds: 1500),
                                                                                ),
                                                                              ));

                                                                      //my forum
                                                                      if (widget
                                                                              .commenterToken ==
                                                                          widget
                                                                              .myDeviceToken) {
                                                                        //create activity
                                                                        await context
                                                                            .read<ActivityProvider2>()
                                                                            .createActivity(
                                                                              widget.threadID,
                                                                              widget.threadTitle,
                                                                              widget.threadDescription,
                                                                              widget.formattedDate,
                                                                              widget.threadCreatorID,
                                                                              widget.creatorName,
                                                                              widget.creatorSection,
                                                                              widget.authorToken,
                                                                              widget.likersTokens.cast<String>(),
                                                                              replySnap.data![index].replyBy.studentNumber == widget.myStudentNumber ? 'You replied to your comment' : 'You replied to ' + replySnap.data![index].replyBy.name + ':',
                                                                              widget.myEmail,
                                                                              replySnap.data![index].content,
                                                                            );
                                                                      } else {
                                                                        //create activity
                                                                        await context
                                                                            .read<ActivityProvider2>()
                                                                            .createActivity(
                                                                              widget.threadID,
                                                                              widget.threadTitle,
                                                                              widget.threadDescription,
                                                                              widget.formattedDate,
                                                                              widget.threadCreatorID,
                                                                              widget.creatorName,
                                                                              widget.creatorSection,
                                                                              widget.authorToken,
                                                                              widget.likersTokens.cast<String>(),
                                                                              replySnap.data![index].replyBy.studentNumber == widget.myStudentNumber ? 'You replied to your comment' : 'You replied to ' + replySnap.data![index].replyBy.name + ':',
                                                                              widget.myEmail,
                                                                              replySnap.data![index].content,
                                                                            );
                                                                      }

                                                                      //get photoUrl from firebase storage after uploading it
                                                                      final replyPhotoURL = await context
                                                                          .read<
                                                                              UploadImageProvider>()
                                                                          .getDownloadURLFromReplies(
                                                                              fileName);

                                                                      //change replyPhoto data in provider
                                                                      context
                                                                          .read<
                                                                              ThreadReplyProvider>()
                                                                          .changeReplyPhoto = replyPhotoURL;
                                                                      //save to replies collection
                                                                      await context
                                                                          .read<
                                                                              ThreadReplyProvider>()
                                                                          .saveImageReply();
                                                                      //send banner notification
                                                                      replySnap.data![index].replyBy.studentNumber ==
                                                                              widget
                                                                                  .myStudentNumber
                                                                          ? null
                                                                          : await _sendAndRetrieveReply(replySnap
                                                                              .data![index]
                                                                              .replyBy
                                                                              .token);

                                                                      //create notification
                                                                      replySnap.data![index].replyBy.studentNumber ==
                                                                              widget
                                                                                  .myStudentNumber
                                                                          ? null
                                                                          : await context
                                                                              .read<NotificationProvider>()
                                                                              .setNotification(
                                                                                notifReceiverStudnum: replySnap.data![index].replyBy.studentNumber,
                                                                                myStudentnumber: widget.myStudentNumber,
                                                                                myEmail: widget.myEmail,
                                                                                forumID: widget.threadID,
                                                                                forumDescription: widget.threadDescription,
                                                                                forumDate: widget.formattedDate,
                                                                                forumTitle: widget.threadTitle,
                                                                                authorName: widget.creatorName,
                                                                                authorSection: widget.creatorSection,
                                                                                authorID: widget.threadCreatorID,
                                                                                authorToken: widget.authorToken,
                                                                                likersTokens: widget.likersTokens,
                                                                                title: widget.myFullName + ' replied to your comment',
                                                                                comment: replySnap.data![index].content,
                                                                              );
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              seconds: 2),
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Text('Reply sent successfully!'),
                                                                          duration:
                                                                              Duration(milliseconds: 1500),
                                                                        ),
                                                                      );
                                                                      context
                                                                          .read<
                                                                              ThreadReplyProvider>()
                                                                          .changeContent = '';
                                                                      replyCtrl
                                                                          .clear();
                                                                    }
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .add_photo_alternate_outlined,
                                                                    color: context
                                                                            .read<
                                                                                ThemeProvider2>()
                                                                            .isDark
                                                                        ? Colors
                                                                            .white
                                                                        : kPrimaryColor,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      size.width /
                                                                          21,
                                                                ),
                                                                //TEXT REPLY BUTTON
                                                                GFButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (context.read<ThreadReplyProvider>().content !=
                                                                            null &&
                                                                        context.read<ThreadReplyProvider>().content !=
                                                                            '') {
                                                                      //save to replies collection
                                                                      await context
                                                                          .read<
                                                                              ThreadReplyProvider>()
                                                                          .saveThreadReply();
                                                                      //send banner notification
                                                                      replySnap.data![index].replyBy.studentNumber ==
                                                                              widget
                                                                                  .myStudentNumber
                                                                          ? null
                                                                          : await _sendAndRetrieveReply(replySnap
                                                                              .data![index]
                                                                              .replyBy
                                                                              .token);
                                                                      //my forum
                                                                      if (widget
                                                                              .commenterToken ==
                                                                          widget
                                                                              .myDeviceToken) {
                                                                        //create activity
                                                                        await context
                                                                            .read<ActivityProvider2>()
                                                                            .createActivity(
                                                                              widget.threadID,
                                                                              widget.threadTitle,
                                                                              widget.threadDescription,
                                                                              widget.formattedDate,
                                                                              widget.threadCreatorID,
                                                                              widget.creatorName,
                                                                              widget.creatorSection,
                                                                              widget.authorToken,
                                                                              widget.likersTokens.cast<String>(),
                                                                              replySnap.data![index].replyBy.studentNumber == widget.myStudentNumber ? 'You replied to your comment' : 'You replied to ' + replySnap.data![index].replyBy.name + ':',
                                                                              widget.myEmail,
                                                                              replySnap.data![index].content,
                                                                            );
                                                                      } else {
                                                                        // //send reply banner notif on forum author
                                                                        // widget.authorToken !=
                                                                        //         widget
                                                                        //             .myDeviceToken
                                                                        //     ? _sendAndRetrieveReplyAuthor
                                                                        //     : null;
                                                                        //create activity
                                                                        await context
                                                                            .read<ActivityProvider2>()
                                                                            .createActivity(
                                                                              widget.threadID,
                                                                              widget.threadTitle,
                                                                              widget.threadDescription,
                                                                              widget.formattedDate,
                                                                              widget.threadCreatorID,
                                                                              widget.creatorName,
                                                                              widget.creatorSection,
                                                                              widget.authorToken,
                                                                              widget.likersTokens.cast<String>(),
                                                                              replySnap.data![index].replyBy.studentNumber == widget.myStudentNumber ? 'You replied to your comment' : 'You replied to ' + replySnap.data![index].replyBy.name + ':',
                                                                              widget.myEmail,
                                                                              replySnap.data![index].content,
                                                                            );
                                                                      }
                                                                      //create notification
                                                                      replySnap.data![index].replyBy.studentNumber ==
                                                                              widget
                                                                                  .myStudentNumber
                                                                          ? null
                                                                          : await context
                                                                              .read<NotificationProvider>()
                                                                              .setNotification(
                                                                                notifReceiverStudnum: replySnap.data![index].replyBy.studentNumber,
                                                                                myStudentnumber: widget.myStudentNumber,
                                                                                myEmail: widget.myEmail,
                                                                                forumID: widget.threadID,
                                                                                forumDescription: widget.threadDescription,
                                                                                forumDate: widget.formattedDate,
                                                                                forumTitle: widget.threadTitle,
                                                                                authorName: widget.creatorName,
                                                                                authorSection: widget.creatorSection,
                                                                                authorID: widget.threadCreatorID,
                                                                                authorToken: widget.authorToken,
                                                                                likersTokens: widget.likersTokens,
                                                                                title: widget.myFullName + ' replied to your comment',
                                                                                comment: replySnap.data![index].content,
                                                                              );
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Text('Reply sent successfully!'),
                                                                          duration:
                                                                              Duration(milliseconds: 1500),
                                                                        ),
                                                                      );
                                                                      FocusManager
                                                                          .instance
                                                                          .primaryFocus
                                                                          ?.unfocus();
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              seconds: 1),
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });

                                                                      context
                                                                          .read<
                                                                              ThreadReplyProvider>()
                                                                          .changeContent = '';
                                                                      replyCtrl
                                                                          .clear();
                                                                    }
                                                                  },
                                                                  child: const Text(
                                                                      'Reply'),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 3,
                                              ),
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.reply,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    'Reply',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      color: Colors.white30,
                                      // endIndent: size.width * .13,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          // return const Center(
          //   child: CircularProgressIndicator(),
          // );
          return Container();
        }
      },
    );
  }

  ///Wrapping mentioned users with brackets to identify them easily
  String _replaceMentions(String text) {
    widget.othersNames.map((u) => u).toSet().forEach((userName) {
      text = text.replaceAll('@$userName', '[@$userName]');
    });
    return text;
  }

  Future<void> _sendAndRetrieveReply(String commentToken) async {
    // Go to Firebase console -> Project settings -> Cloud Messaging -> copy Server key
    // the Server key will start "AAAAMEjC64Y..."
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    const serverKey =
        'AAAApcnCYIw:APA91bHLAKGEAkAu9xl8nd4GC5OVYwR8Uu7jgjMrOSzzKzl81mfRXfYIZmdqmwCWUhO0nFusIJQrM_npC6bnkeEQjEZwFBqukIt4Ci5rrT2fGgw6w4qZUJxecVmIe9zqw5n7nsdlJOwF';
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': context.read<ThreadReplyProvider>().content == ''
                ? 'sent a photo'
                : context.read<ThreadReplyProvider>().content,
            'title': 'Someone replied on your comment:',
            // 'image':
            //     'https://yt3.ggpht.com/ytc/AAUvwnjuH8xEOYQyRAE2NMrVieRw0GBbcJ9l5wLPpvgHDQ=s88-c-k-c0x00ffffff-no-rj'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          // FCM Token lists.
          'registration_ids': [commentToken],
        },
      ),
    );
  }

  Future<void> _sendAndRetrieveReplyAuthor() async {
    // Go to Firebase console -> Project settings -> Cloud Messaging -> copy Server key
    // the Server key will start "AAAAMEjC64Y..."
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    const serverKey =
        'AAAApcnCYIw:APA91bHLAKGEAkAu9xl8nd4GC5OVYwR8Uu7jgjMrOSzzKzl81mfRXfYIZmdqmwCWUhO0nFusIJQrM_npC6bnkeEQjEZwFBqukIt4Ci5rrT2fGgw6w4qZUJxecVmIe9zqw5n7nsdlJOwF';
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': context.read<ThreadReplyProvider>().content == ''
                ? 'sent a photo'
                : context.read<ThreadReplyProvider>().content,
            'title': widget.authorToken == widget.myDeviceToken
                ? 'Your reply:'
                : 'Someone replied in your forum:',
            // 'image':
            //     'https://yt3.ggpht.com/ytc/AAUvwnjuH8xEOYQyRAE2NMrVieRw0GBbcJ9l5wLPpvgHDQ=s88-c-k-c0x00ffffff-no-rj'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          // FCM Token lists.
          'registration_ids': [widget.authorToken],
        },
      ),
    );
  }
}
