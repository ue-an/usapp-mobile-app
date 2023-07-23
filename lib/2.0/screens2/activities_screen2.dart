import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/models/activity.dart';
import 'package:usapp_mobile/2.0/models/topicforum_screen.dart';
import 'package:usapp_mobile/2.0/providers2/activity_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/threadroom_screen2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';

class ActivitiesScreen2 extends StatefulWidget {
  const ActivitiesScreen2({Key? key}) : super(key: key);

  @override
  State<ActivitiesScreen2> createState() => _ActivitiesScreen2State();
}

class _ActivitiesScreen2State extends State<ActivitiesScreen2>
    with AutomaticKeepAliveClientMixin<ActivitiesScreen2> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;
  late Stream<List<Activity>> _streamActivity;
  late String _myEmail = '';
  void _storeDetailsOnLocal() async {
    String? myEmail = await context.read<LocalDataProvider2>().getLocalEmail();
    setState(() {
      _myEmail = myEmail!;
    });
  }

  @override
  void initState() {
    _storeDetailsOnLocal();
    setState(() {
      _isVisited = true;
    });
    _streamActivity = context.read<ActivityProvider2>().getActivities;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<List<Activity>>(
              stream: _streamActivity,
              builder: (context, activitySnap) {
                if (activitySnap.hasData) {
                  activitySnap.data!.sort((a, b) => b.date.compareTo(a.date));
                  List<TopicForumScreen> topicForumScreenList = [];
                  activitySnap.data!.forEach((activity) {
                    if (activity.owner == _myEmail) {
                      topicForumScreenList.add(activity.topicForumScreen);
                    }
                  });
                  List<Activity> activityData = [];
                  activitySnap.data!.forEach((activity) {
                    if (activity.owner == _myEmail) {
                      activityData.add(activity);
                    }
                  });

                  return Container(
                    margin: EdgeInsets.only(top: size.height / 9),
                    child: ListView.builder(
                      itemCount: topicForumScreenList.length,
                      itemBuilder: (context, index) {
                        DateTime myDateTime = activityData[index].date.toDate();
                        String formattedDate = timeago.format(
                          myDateTime,
                          locale: 'en_short',
                        );
                        return activityData[index].title ==
                                    'You posted a forum' ||
                                activityData[index].title ==
                                    'You deleted your forum' ||
                                activityData[index].title ==
                                    'You updated your profile description' ||
                                activityData[index].title ==
                                    'You updated your profile photo' ||
                                activityData[index].title ==
                                    'You updated your password'
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * .05,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            activityData[index].title,
                                            style: const TextStyle(
                                              color: kMiddleColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: size.width / 1.3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    activityData[index]
                                                                .comment ==
                                                            ''
                                                        ? Container()
                                                        : Text(
                                                            activityData[index]
                                                                .comment,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            softWrap: true,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .white60,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              // Text(
                                              //   formattedDate2,
                                              //   style: const TextStyle(
                                              //       color: Colors.white),
                                              // ),
                                              Text(
                                                formattedDate == 'now'
                                                    ? formattedDate
                                                    : formattedDate + '\n ago',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: size.width * .05,
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: context.read<ThemeProvider2>().isDark
                                        ? Colors.grey[800]
                                        : kPrimaryColor,
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ThreadRoomScreen2(
                                            threadID: activityData[index]
                                                .topicForumScreen
                                                .forumID,
                                            threadTitle: activityData[index]
                                                .topicForumScreen
                                                .forumTitle,
                                            threadDescription:
                                                activityData[index]
                                                    .topicForumScreen
                                                    .forumDescription,
                                            creatorName: activityData[index]
                                                .topicForumScreen
                                                .authorName,
                                            creatorSection: activityData[index]
                                                .topicForumScreen
                                                .authorSection,
                                            formattedDate: activityData[index]
                                                .topicForumScreen
                                                .forumDate,
                                            threadCreatorID: activityData[index]
                                                .topicForumScreen
                                                .authorID,
                                            likersTokens: activityData[index]
                                                .topicForumScreen
                                                .likersTokens
                                                .cast<String>(),
                                            authorToken: activityData[index]
                                                .topicForumScreen
                                                .authorToken,
                                          )));
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * .05,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              activityData[index].title,
                                              style: const TextStyle(
                                                color: kMiddleColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // Text(
                                            //   topicForumScreenList[index].forumTitle +
                                            //       topicForumScreenList[index].forumTitle,
                                            //   style: TextStyle(
                                            //     color: Colors.white,
                                            //   ),
                                            // ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: size.width / 1.3,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        topicForumScreenList[
                                                                index]
                                                            .forumTitle
                                                            .toUpperCase(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      activityData[index]
                                                                  .comment ==
                                                              ''
                                                          ? Container()
                                                          : Text(
                                                              activityData[
                                                                      index]
                                                                  .comment,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              softWrap: true,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white60,
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                // Text(
                                                //   formattedDate2,
                                                //   style: const TextStyle(
                                                //       color: Colors.white),
                                                // ),
                                                Text(
                                                  formattedDate == 'now'
                                                      ? formattedDate
                                                      : formattedDate +
                                                          '\n ago',
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Spacer(),
                                        // Text(
                                        //   formattedDate == 'now'
                                        //       ? formattedDate
                                        //       : formattedDate + '\n ago',
                                        //   style: TextStyle(
                                        //     color: Colors.white70,
                                        //     fontSize: 12,
                                        //   ),
                                        // ),
                                        SizedBox(
                                          width: size.width * .05,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                      color:
                                          context.read<ThemeProvider2>().isDark
                                              ? Colors.grey[800]
                                              : kPrimaryColor,
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Container(
            // It will cover 20% of our total height
            padding: const EdgeInsets.only(
                // bottom: 12,
                ),
            height: size.height / 2.5 - (size.height / 3.5),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      IconButton(
                        onPressed: _handleMenuButtonPressed,
                        icon: ValueListenableBuilder<AdvancedDrawerValue>(
                          valueListenable: context
                              .watch<AdvDrawerController>()
                              .advDrawerController,
                          builder: (_, value, __) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Icon(
                                value.visible
                                    ? Icons.arrow_back_ios
                                    : Icons.menu,
                                color: Colors.white,
                                key: ValueKey<bool>(value.visible),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: const [
                          Text(
                            'Activities',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    context.read<AdvDrawerController>().advDrawerController.showDrawer();
  }
}
