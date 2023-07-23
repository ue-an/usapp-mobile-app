// import 'package:flutter/material.dart';
// import 'package:provider/src/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:usapp_mobile/2.0/screens2/drawer_screen2.dart';
// import 'package:usapp_mobile/2.0/screens2/home_screen2.dart';
// import 'package:usapp_mobile/2.0/screens2/on_drawer/developers_screen.dart';
// import 'package:usapp_mobile/2.0/screens2/on_drawer/invite_screen2.dart';
// import 'package:usapp_mobile/2.0/screens2/on_drawer/members_screen2.dart';
// import 'package:usapp_mobile/2.0/screens2/on_drawer/profile_screen2.dart';
// import 'package:usapp_mobile/2.0/screens2/on_drawer/upload_image/upload_image_provider.dart';
// import 'package:usapp_mobile/2.0/screens2/on_drawer/upload_image/upload_img_firebase.dart';
// import 'package:usapp_mobile/2.0/screens2/on_drawer/urs_screen2.dart';
// import 'package:usapp_mobile/2.0/screens2/swipe/drawerpage_provider2.dart';
// import 'package:usapp_mobile/2.0/screens2/swipe/page1.dart';
// import 'package:usapp_mobile/2.0/screens2/swipe/swipe_page2.dart';
// import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';

// class MyPage2 extends StatefulWidget {
//   const MyPage2({
//     Key? key,
//   }) : super(key: key);
//   @override
//   State<MyPage2> createState() => _MyPage2State();
// }

// class _MyPage2State extends State<MyPage2> {
//   @override
//   void initState() {
//     super.initState();
//     // launchCount = 0;
//     incLaunchCount();
//   }

//   Future incLaunchCount() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int curLaunchCount = prefs.getInt('counter')!;
//     prefs.setInt('counter', curLaunchCount + 1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           DrawerScreen2(),
//           // SwipePage2(),
//           GestureDetector(
//             onPanUpdate: (details) {
//               if (details.delta.dx > 0) {
//                 setState(() {
//                   // xOffset =
//                   context.read<SwipeProvider2>().changeXoffset = 250;
//                   // yOffset =
//                   context.read<SwipeProvider2>().changeYoffset = 100;
//                   // scaleFactor =
//                   context.read<SwipeProvider2>().changeScaleFactor = .8;
//                   //isDrawerOpen
//                   context.read<SwipeProvider2>().changeIsDrawerOpen = true;
//                 });

//                 print('swiped right');
//                 print(context.read<SwipeProvider2>().isDrawerOpen);
//               }

//               // Swiping in left direction.
//               if (details.delta.dx < 0) {
//                 setState(() {
//                   // xOffset =
//                   context.read<SwipeProvider2>().changeXoffset = 0;
//                   // yOffset =
//                   context.read<SwipeProvider2>().changeYoffset = 0;
//                   // scaleFactor =
//                   context.read<SwipeProvider2>().changeScaleFactor = 1;
//                   // isDrawerOpen =
//                   context.read<SwipeProvider2>().changeIsDrawerOpen = false;
//                   // context.read<SwipeProvider2>().resetOffsets();
//                 });
//                 print('swiped left');
//                 print(context.read<SwipeProvider2>().isDrawerOpen);
//               }
//             },
//             child: (() {
//               switch (context.watch<DrawerPageProvider2>().drawerPageSelected) {
//                 case 0:
//                 // return HomeScreen2();
//                 case 1:
//                   return MembersScreen2();
//                 case 2:
//                   return InviteScreen2();
//                 case 3:
//                   return URSScreen2();
//                 case 4:
//                   return DevelopersScreen2();
//                 case 5:
//                   return ProfileScreen2();
//                 // return UploadIMGtoFirebase();

//                 default:
//                   return Row(
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width / 2,
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width / 2,
//                         color: Colors.red,
//                       ),
//                     ],
//                   );
//               }
//             }()),
//           ),
//         ],
//       ),
//       // body: SwipePage2(),
//     );
//   }
// }
