// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';

class DevelopersScreen2 extends StatefulWidget {
  const DevelopersScreen2({Key? key}) : super(key: key);

  @override
  _DevelopersScreen2State createState() => _DevelopersScreen2State();
}

class _DevelopersScreen2State extends State<DevelopersScreen2> {
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
        // shape: BoxShape.rectangle,
        // borderRadius: BorderRadius.circular(
        //     context.read<SwipeProvider2>().isDrawerOpen ? 40 : 0.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 21,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
      child: Scaffold(
        // backgroundColor: Theme.of(context).backgroundColor,
        backgroundColor: context.read<ThemeProvider2>().isDark
            ? Theme.of(context).backgroundColor
            : kPrimaryColor,
        body: Stack(
          children: [
            Center(
              child: Container(
                child: Image.asset('assets/images/technocratslogo.png'),
                height: MediaQuery.of(context).size.height / 3,
              ),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.75,
                  ),
                  // Content
                  //Sliding Panel
                  Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/av_laptop-sit.png',
                              height: 150,
                              width: 150,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 21,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            // bottom: 15,
                            top: 9,
                          ),
                          //Freakin' real content
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(50),
                                    left: Radius.circular(50),
                                  ),
                                ),
                                height: 2,
                                width: MediaQuery.of(context).size.width / 30,
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Center(
                                child: Text(
                                  'Developers',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: context.read<ThemeProvider2>().isDark
                                        ? Colors.blue
                                        : kPrimaryColor,
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height,
                              // ),
                              (() {
                                List<String> devPics = [
                                  'assets/images/tc_ian02.png',
                                  'assets/images/tc_daryn.png',
                                  'assets/images/tc_alaiza.png',
                                  'assets/images/tc_jenyl.png',
                                  'assets/images/tc_marco.png',
                                ];
                                List<String> devNames = [
                                  'Ian Benedict Aguinaldo',
                                  'Daryn Binaluyo',
                                  'Alaiza Joy Gondraneos',
                                  'Jenyl Maningcay',
                                  'Gabriel Marco Merjudio',
                                ];
                                return ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: devPics.length,
                                    itemBuilder: (context, index) {
                                      return devPics
                                              .indexOf(devPics[index])
                                              .isEven
                                          ? Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(50),
                                                          ),
                                                          child: Image.asset(
                                                            devPics[index],
                                                            height: 40,
                                                            width: 40,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 9,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  devNames[
                                                                          index]
                                                                      .toUpperCase(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                              'BSIT 3-3',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white60,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    // title: Text(''),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          size.width / 20),
                                                  // child: Divider(
                                                  //   thickness: 1,
                                                  // ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      devNames[
                                                                              index]
                                                                          .toUpperCase(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'BSIT 3-3',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white60,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 9,
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(50),
                                                          ),
                                                          child: Image.asset(
                                                            devPics[index],
                                                            height: 40,
                                                            width: 40,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // title: Text(''),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          size.width / 20),
                                                  // child: Divider(
                                                  //   thickness: 1,
                                                  // ),
                                                ),
                                              ],
                                            );
                                    });
                              }()),
                            ],
                          ),
                        ),
                      ),
                    ],
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
