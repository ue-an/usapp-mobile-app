// import 'package:flutter/material.dart';
// import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
// import 'package:provider/src/provider.dart';
// import 'package:usapp_mobile/2.0/models/direct_message.dart';
// import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
// import 'package:usapp_mobile/2.0/providers2/directmessage_provider2.dart';
// import 'package:usapp_mobile/2.0/providers2/keep_alive_provider.dart';
// import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
// import 'package:usapp_mobile/2.0/utils2/constants.dart';
// import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';

// class DirectMessageListScreen extends StatefulWidget {
//   const DirectMessageListScreen({Key? key}) : super(key: key);

//   @override
//   _DirectMessageListScreenState createState() =>
//       _DirectMessageListScreenState();
// }

// class _DirectMessageListScreenState extends State<DirectMessageListScreen>
// // with AutomaticKeepAliveClientMixin<DirectMessageListScreen>
// {
//   // @override
//   // bool get wantKeepAlive => true;
//   String? _myEmail = '';
//   String? _myPhoto = '';
//   String? _myName = '';
//   late String? _dmID = '';
//   late List _names = ['', ''];
//   late List _photos = ['', ''];
//   late List _usersEmails = ['', ''];
//   late List _sections = ['', ''];
//   late String? _refCollege = '';
//   late Stream<List<DirectMessage>> _directMessageStream;
//   FirestoreService2 firestoreService2 = FirestoreService2();
//   GlobalKey<RefreshIndicatorState> _refreshIndicatorKey2 =
//       GlobalKey<RefreshIndicatorState>();

//   @override
//   void initState() {
//     // initEmail();
//     _directMessageStream = firestoreService2.fetchMembersWithConvos();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     context.read<KeepAliveProvider2>().isDmpmAlive = true;
//     Size size = MediaQuery.of(context).size;
//     return StreamBuilder<List<DirectMessage>>(
//       stream: _directMessageStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           // initEmail();
//           // _getFromSharedPrefs();
//           // _refreshData2();
//           List<DirectMessage> directMessages = snapshot.data!;
//           return RefreshIndicator(
//               onRefresh: _refreshData2,
//               key: _refreshIndicatorKey2,
//               child: ListView(
//                 padding: EdgeInsets.all(8.0),
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(top: size.height / 3),
//                         child: ListView.builder(
//                             physics: AlwaysScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             // reverse: true,
//                             itemCount: directMessages.length,
//                             itemBuilder: (context, index) {
//                               DirectMessage directMessage =
//                                   directMessages[index];
//                               // List dm = directMessage.dmID.split('_');
//                               // directMessage.dmID[index]
//                               if (directMessage.users[index] == _myEmail) {
//                                 return Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         // directMessage.photos[index] != _photos
//                                         //     ? Center(
//                                         //         child: Text(
//                                         //             directMessage.photos[index]),
//                                         //       )
//                                         //     : Center(child: Text(_myPhoto!)),
//                                         SizedBox(
//                                           width: 9,
//                                         ),
//                                         directMessage.names[index] != _myName
//                                             ? Center(
//                                                 child: Text(_names[index]),
//                                               )
//                                             : Center(child: Text(_myName!)),
//                                       ],
//                                     ),
//                                     Center(
//                                       child: Text(_dmID!),
//                                     )
//                                   ],
//                                 );

//                                 // return Center(
//                                 //   child: Text(_dmID!),
//                                 // );
//                               } else {
//                                 return Center(
//                                   child: Text('ssdsd'),
//                                 );
//                               }
//                               // return Center(
//                               //   child: Text('DATATATTA'),
//                               // );
//                             }),
//                       ),
//                       // Topmost changing icon
//                       SafeArea(
//                         child: Container(
//                           margin:
//                               EdgeInsets.only(bottom: kDefaultPadding * 2.5),
//                           // It will cover 20% of our total height
//                           height: size.height / 3,
//                           child: Stack(
//                             children: <Widget>[
//                               //Curved colored container at the back
//                               Container(
//                                 padding: EdgeInsets.only(
//                                   left: kDefaultPadding,
//                                   right: kDefaultPadding,
//                                   // bottom: 36 + kDefaultPadding,
//                                 ),
//                                 height: size.height / 3 - 90,
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context).backgroundColor,
//                                   borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(36),
//                                     bottomRight: Radius.circular(36),
//                                   ),
//                                 ),
//                                 //Content of header
//                                 child: Row(
//                                   children: <Widget>[
//                                     //header of threads screen(home/main)
//                                     //retrieves the college of current user from localpref
//                                     FutureBuilder(
//                                       future: context
//                                           .read<LocalDataProvider2>()
//                                           .getLocalFullName(),
//                                       // future: localDataProvider2.getLocalFullName(),
//                                       builder: (context,
//                                           AsyncSnapshot<String?> snapshot) {
//                                         if (snapshot.hasData) {
//                                           return Row(
//                                             children: [
//                                               SizedBox(
//                                                 width: size.width / 4.5 -
//                                                     (snapshot.data!.length),
//                                               ),
//                                               Text(
//                                                 snapshot.data! +
//                                                     '\'s ' +
//                                                     '\nPrivate/Direct Messages',
//                                                 // 'Personal Messages',
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           );
//                                         }

//                                         return Center(
//                                           child: Text('No Messages'),
//                                         );
//                                       },
//                                     ),
//                                     Spacer(),
//                                     // Image.asset("assets/images/logo.png")
//                                   ],
//                                 ),
//                               ),
//                               SafeArea(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 9),
//                                   child: IconButton(
//                                     onPressed: _handleMenuButtonPressed,
//                                     icon: ValueListenableBuilder<
//                                         AdvancedDrawerValue>(
//                                       valueListenable: context
//                                           .watch<AdvDrawerController>()
//                                           .advDrawerController,
//                                       builder: (_, value, __) {
//                                         return AnimatedSwitcher(
//                                           duration: Duration(milliseconds: 250),
//                                           child: Icon(
//                                             value.visible
//                                                 ? Icons.arrow_back_ios
//                                                 : Icons.menu,
//                                             color: Colors.white,
//                                             key: ValueKey<bool>(value.visible),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ));
//         } else {
//           return Center(
//               child: Container(
//             child: Text('no data'),
//           ));
//         }
//       },
//     );
//   }

//   void _handleMenuButtonPressed() {
//     // NOTICE: Manage Advanced Drawer state through the Controller.
//     // _advancedDrawerController.value = AdvancedDrawerValue.visible();
//     context.read<AdvDrawerController>().advDrawerController.showDrawer();
//   }

//   Future<void> _refreshData2() async {
//     // final email = await context.read<LocalDataProvider2>().getLocalEmail();
//     final data = await context.read<DirectMessageProvider2>().fetchData();
//     //-------------------------------------------------------------------------------------
//     String? email2 = await context.read<LocalDataProvider2>().getLocalEmail();
//     String? photo = await context.read<LocalDataProvider2>().getLocalPhotoUrl();
//     String? name = await context.read<LocalDataProvider2>().getLocalFullName();
//     String? refCollege =
//         await context.read<LocalDataProvider2>().getLocalCollege();
//     for (var datus in data) {
//       setState(() {
//         _dmID = datus.dmID;
//         _names = datus.names;
//         _photos = datus.photos;
//         _usersEmails = datus.users;
//         _sections = datus.yearSecs;
//         //---------------------------
//         _myEmail = email2;
//         _myPhoto = photo;
//         _myName = name;
//         _refCollege = refCollege;
//       });
//     }
//   }

//   // Future<void> _getFromSharedPrefs() async {
//   //   String? email = await context.read<LocalDataProvider2>().getLocalEmail();
//   //   String? photo = await context.read<LocalDataProvider2>().getLocalPhotoUrl();
//   //   String? name = await context.read<LocalDataProvider2>().getLocalFullName();
//   //   String? refCollege =
//   //       await context.read<LocalDataProvider2>().getLocalCollege();
//   //   setState(() {
//   //     _myEmail = email;
//   //     _myPhoto = photo;
//   //     _myName = name;
//   //     _refCollege = refCollege;
//   //   });
//   // }
// }
