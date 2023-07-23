import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';

class InviteScreen2 extends StatefulWidget {
  const InviteScreen2({Key? key}) : super(key: key);

  @override
  _InviteScreen2State createState() => _InviteScreen2State();
}

class _InviteScreen2State extends State<InviteScreen2> {
  _launchURL() async {
    const url =
        'https://drive.google.com/drive/folders/1CLKn6aD9duqDkmkeUuxjVjucBl7odMrs?usp=sharing';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // This key will be used to show the snack bar
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(
        text:
            'https://drive.google.com/drive/folders/1CLKn6aD9duqDkmkeUuxjVjucBl7odMrs?usp=sharing'));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  @override
  Widget build(BuildContext context) {
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
                          Center(
                            child: Text(
                              'Share UsApp',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height,
                          // ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "Download App",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _launchURL();
                                        },
                                        child: Text(
                                          'Go to Download Page',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _copyToClipboard();
                                            },
                                            icon: Icon(Icons.copy),
                                          ),
                                          Text(
                                            'https://drive.google.com/drive/folders/\n1CLKn6aD9duqDkmkeUuxjVjucBl7odMrs?\nusp=sharing',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
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
