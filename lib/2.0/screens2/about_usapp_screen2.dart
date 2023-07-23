import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';

class AboutUsappScreen2 extends StatefulWidget {
  const AboutUsappScreen2({Key? key}) : super(key: key);

  @override
  _AboutUsappScreen2State createState() => _AboutUsappScreen2State();
}

class _AboutUsappScreen2State extends State<AboutUsappScreen2> {
  // This key will be used to show the snack bar
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      transform: Matrix4.translationValues(
          context.read<SwipeProvider2>().xOffset,
          context.read<SwipeProvider2>().yOffset,
          0)
        ..scale(context.read<SwipeProvider2>().scaleFactor)
        ..rotateY(context.read<SwipeProvider2>().isDrawerOpen ? -0.5 : 0),
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        // borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 21,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              // color: Colors.grey[800],
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height / 3,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  // Topmost changing icon
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 9),
                          child: IconButton(
                            onPressed: _handleMenuButtonPressed,
                            icon: ValueListenableBuilder<AdvancedDrawerValue>(
                              valueListenable: context
                                  .watch<AdvDrawerController>()
                                  .advDrawerController,
                              builder: (_, value, __) {
                                return AnimatedSwitcher(
                                  duration: Duration(milliseconds: 250),
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Image.asset(
                      'assets/images/av_boy-read.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  // Content
                  //Sliding Panel
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 15,
                        top: 9,
                      ),
                      //Freakin' real content
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              'About UsApp',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'v1.3.4',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * .02,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.height * .02,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'UsApp is a mobile forum application developed by our team Technocrats as a completion requirement for our capstone project. This app is built using Dart language and Flutter framework with Firebase as database.',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.justify,
                                ),
                                const Text(
                                  'Our app is currently limited and available to URS Binangonan students. With the help of this app, students in COA, COB, and CCS can talk to each other and discuss school-related and course-related topics much easier. Students in the Binangonan campus will get to know their schoolmates and start connection without leaving the URS environment.',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.justify,
                                ),
                                const Text(
                                  'In relation to that, UsApp offers useful features to achieve our target aim to help the students. Three of this app\'s main features are:',
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.justify,
                                ),
                                //Forums
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '\n1.) Forums:',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Students can create their own forums where other students can comment and share their ideas about the topic posted. We believe it to be a learning environment for us where we can ask our upperclassmen for advice and tips and bring a welcoming atmosphere for the freshmen as well.\n\nStudents can also like the forums they think is very helpful and report forums they think that violate our app\'s terms and conditions; or even campus regulations.',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                //Personal Chats
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '\n2.) Personal Chats:',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'In Personal Chats section, they can exchange messages between two users. However, to limit the risk and making sure it not to be a place for unwanted actions, no additional features are added except for chat messages only.\n\n In addition, this feature lessen the difficulty of reaching out to students a user would want to inquire further or ask more regarding a forum or topic discussed in the community.',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                //About URS
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '\n3.) About URS:',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'We put a section where students could check details about URS or their respective colleges and courses. Some essential information are chosen including the link for Student Portal.',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    context.read<AdvDrawerController>().advDrawerController.showDrawer();
  }
}
