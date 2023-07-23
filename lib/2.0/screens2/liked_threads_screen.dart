import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/thread_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/homescreen_component/empty_block.dart';
import 'package:usapp_mobile/2.0/screens2/threadroom_screen2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/models/thread.dart';

class LikedThreadsScreen2 extends StatefulWidget {
  const LikedThreadsScreen2({Key? key}) : super(key: key);

  @override
  State<LikedThreadsScreen2> createState() => _LikedThreadsScreen2State();
}

class _LikedThreadsScreen2State extends State<LikedThreadsScreen2>
    with AutomaticKeepAliveClientMixin<LikedThreadsScreen2> {
  @override
  bool get wantKeepAlive => true;
  FirestoreService2 firestoreService2 = FirestoreService2();
  late Stream<List<Thread>> _streamThread;
  late String _myEmail = '';
  late String _myFullname = '';

  void _getDetailsOnLocal() async {
    String? myEmail = await context.read<LocalDataProvider2>().getLocalEmail();
    String? myFullName =
        await context.read<LocalDataProvider2>().getLocalFullName();
    print(myFullName);
    setState(() {
      _myEmail = myEmail!;
      _myFullname = myFullName!;
    });
  }

  @override
  void initState() {
    _streamThread = firestoreService2.fetchThreads();
    _getDetailsOnLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<Thread>>(
      stream: _streamThread,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          snapshot.data!.sort((a, b) => b.tSdate.compareTo(a.tSdate));
          return Scaffold(
            appBar: AppBar(
              title: const Text('Liked Forums'),
            ),
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    // top: size.height / 3,
                    left: 14,
                    right: 14,
                  ),
                  // height: size.height,
                  width: size.width,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      DateTime myDateTime =
                          snapshot.data![index].tSdate.toDate();
                      String formattedDate =
                          DateFormat('yyyy-MM-dd – KK:mm a (EEE)')
                              .format(myDateTime);
                      if (snapshot.data![index].likers.contains(_myEmail)) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ThreadRoomScreen2(
                                      threadID: snapshot.data![index].id,
                                      threadTitle: snapshot.data![index].title,
                                      threadDescription:
                                          snapshot.data![index].description,
                                      creatorName:
                                          snapshot.data![index].creatorName,
                                      creatorSection:
                                          snapshot.data![index].creatorSection,
                                      formattedDate: formattedDate,
                                      threadCreatorID:
                                          snapshot.data![index].studID,
                                      likersTokens: snapshot
                                          .data![index].likersTokens
                                          .cast<String>(),
                                      authorToken:
                                          snapshot.data![index].authorToken,
                                    )));
                          },
                          child: GFCard(
                            // margin: EdgeInsets.only(
                            //   top: 5,
                            //   bottom: 5,
                            // ),
                            showImage: true,
                            title: GFListTile(
                              avatar: const GFAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/ic_ccs-logo.png'),
                              ),
                              title: Text(
                                snapshot.data![index].title.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subTitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index].creatorName +
                                        ', ' +
                                        snapshot.data![index].creatorSection,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            content: Text(snapshot.data![index].description),
                            buttonBar: GFButtonBar(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data![index].likers.length
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        ),
                                        snapshot.data![index].likers.length > 1
                                            ? Text(' Likes')
                                            : Text(' Like'),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data![index].msgSent
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.green),
                                        ),
                                        snapshot.data![index].likers.length > 1
                                            ? Text(' Comments')
                                            : Text(' Comment'),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data![index].reportersEmail
                                              .length
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        snapshot.data![index].reportersEmail
                                                    .length >
                                                1
                                            ? const Text(' Reports')
                                            : const Text(' Report'),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return GFShimmer(
            child: const Center(
              child: EmptyBlock(),
            ),
            showGradient: true,
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.centerLeft,
              stops: const <double>[0, 0.3, 0.6, 0.9, 1],
              colors: [
                Colors.grey.withOpacity(0.1),
                Colors.grey.withOpacity(0.3),
                Colors.grey.withOpacity(0.5),
                Colors.grey.withOpacity(0.7),
                Colors.grey.withOpacity(0.9),
              ],
            ),
          );
        }
      },
    );
  }
}
