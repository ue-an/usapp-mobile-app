// import 'package:flutter/material.dart';
// import 'package:provider/src/provider.dart';
// import 'package:usapp_mobile/2.0/screens2/on_drawer/urs_screen2.dart';
// import 'package:usapp_mobile/2.0/screens2/swipe/page1.dart';
// import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';

// class SwipePage2 extends StatefulWidget {
//   const SwipePage2({Key? key}) : super(key: key);

//   @override
//   State<SwipePage2> createState() => _SwipePage2State();
// }

// class _SwipePage2State extends State<SwipePage2> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onPanUpdate: (details) {
//         if (details.delta.dx > 0) {
//           setState(() {
//             // xOffset =
//             context.read<SwipeProvider2>().changeXoffset = 350;
//             // yOffset =
//             context.read<SwipeProvider2>().changeYoffset = 100;
//             // scaleFactor =
//             context.read<SwipeProvider2>().changeScaleFactor = .8;
//             //isDrawerOpen
//             context.read<SwipeProvider2>().changeIsDrawerOpen = true;
//           });

//           print('swiped right');
//           print(context.read<SwipeProvider2>().isDrawerOpen);
//         }

//         // Swiping in left direction.
//         if (details.delta.dx < 0) {
//           setState(() {
//             // xOffset =
//             context.read<SwipeProvider2>().changeXoffset = 0;
//             // yOffset =
//             context.read<SwipeProvider2>().changeYoffset = 0;
//             // scaleFactor =
//             context.read<SwipeProvider2>().changeScaleFactor = 1;
//             // isDrawerOpen =
//             context.read<SwipeProvider2>().changeIsDrawerOpen = false;
//           });
//           print('swiped left');
//           print(context.read<SwipeProvider2>().isDrawerOpen);
//         }
//       },
//       child: URSScreen2(),
//     );
//     // return Container();
//   }
// }
