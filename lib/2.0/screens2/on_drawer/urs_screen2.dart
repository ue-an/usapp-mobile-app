import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/src/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usapp_mobile/2.0/providers2/advdrawer_controller.dart';
import 'package:usapp_mobile/2.0/screens2/on_drawer/ursscreen2_components/ursscreen_body2.dart';
import 'package:usapp_mobile/2.0/screens2/swipe/swipe_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';

class URSScreen2 extends StatefulWidget {
  const URSScreen2({Key? key}) : super(key: key);

  @override
  _URSScreen2State createState() => _URSScreen2State();
}

class _URSScreen2State extends State<URSScreen2> {
  @override
  Widget build(BuildContext context) {
    _launchURL() async {
      const url = 'http://110.93.74.78/StudentEnrollment';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

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
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: Image.asset(
                    'assets/images/av_girl-read.png',
                    height: 200,
                    width: 200,
                  ),
                ),
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
                    height: MediaQuery.of(context).size.height / 6,
                  ),
                  // Content
                  // Sliding panel
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'University of Rizal System',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "URS Vision",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'The leading University in human resource development, knowledge and technology generation and environmental stewardship',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "URS Mission",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'The University of Rizal System is committed to nurture and produce upright and competent graduates and empowered community through relevant and sustainable higher professional and technical instruction, research, extension and production services.',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "URS Core Values",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'R - Responsiveness\nI - Integrity\nS - Services\nE Excellence\nS - Social Responsibility',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "Student Portal",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: ElevatedButton(
                                    onPressed: () {
                                      _launchURL();
                                    },
                                    child: Text(
                                      'Go to Portal',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'College of Computer Studies',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "College Goals",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'College of Computer Studies commits itself in the pursuit of excellence, provides Information Technology methodologies in the advancement of students’ innovativeness, creativity, and competencies as they foster their values in the service of men.',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "Bachelor of Science in Information Technology",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    // fontSize: 12,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Program Objectives\n',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '• Develop their utmost professional competence in all applications of Information Technology in response to the demands of modern time.\n\n• Realize the essential contribution of IT in business economics and related industries.\n\n• Adhere themselves in the sense of professional values and ethics as they respond and advance themselves in the demands of the present time.',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "Bachelor of Science in Information System",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Program Objectives\n',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '• Develop their utmost professional competence in all applications of Information Systems in response to the demands of modern time.\n\n• Apprehend the fundamental contribution of IS in web-market and related industries.\n\n• Instill in them the significance of research and community services as tools for human advancement and empowerment. Develop their utmost professional competence in all applications of Information Technology in response to the demands of modern time.',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'College of Accountancy',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "College Goals",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'To realize the vision and live up to the mission of the University, the College of Accountancy has the following goals:\n\n1. To provide accessible excellent education through dynamic accounting curricula.\n\n2. To engage in intellectual pursuits that expand the existing body of knowledge in the field of accounting through a productive and relevant research program.\n\n3. To establish linkages and partnership with businesses, communities and development organizations for the development of more responsive accounting programs.\n\n4. To promote a culture of excellence among faculty members and students.\n\n5. To instill in the students the highest sense of integrity, service and social responsibility.',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "Bachelor of Science in Accountancy",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    // fontSize: 12,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Goal of the Program\n',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Provide accessible excellent education through dynamic accounting curricula. Engage in intellectual pursuits that expand the existing body of knowledge in the field of accounting through a productive and relevant research program. Establish linkages and partnership with businesses, communities and development organizations for the development of more responsive accounting programs. Promote a culture of excellence among faculty members and students. Instill in the students the highest sense of integrity, service and social responsibility.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'College of Business',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "Bachelor of Science in Business",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    // fontSize: 12,
                                    ),
                              ),
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Major in: ',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Card(
                                        child: ExpansionTile(
                                          title: Text(
                                            "Human Resource DevelopmentManagement (HRDM)",
                                            style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                // fontSize: 12,
                                                ),
                                          ),
                                          children: <Widget>[
                                            ListTile(
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Goal of the Program\n',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'The Human Resource Development Management Program prepares the graduate for a career in the Human Resources Development of any organization, handling the many diverse human capital requirements of the organization, including recruitment, staffing, training and career development.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Card(
                                        child: ExpansionTile(
                                          title: Text(
                                            "Marketing Management (MM)",
                                            style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                // fontSize: 12,
                                                ),
                                          ),
                                          children: <Widget>[
                                            ListTile(
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Goal of the Program\n',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'The Marketing Management Program prepares the graduate for careers in marketing, market research, advertising and public relations. The curriculum provides the graduate with both technical skills and competencies required in the field, but also the flexible mindset that is necessary to stay competitive in a constantly changing business environment.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Card(
                                        child: ExpansionTile(
                                          title: Text(
                                            "Financial Management (FM)",
                                            style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                // fontSize: 12,
                                                ),
                                          ),
                                          children: <Widget>[
                                            ListTile(
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Goal of the Program\n',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'The Financial Management program prepares the graduate for various careers in financial management as well as in related fields, including but not limited to, corporate finance, investment management, banking, credit, trust operations, insurance, foreign currency markets, money markets, capital markets, and other financial securities markets. The curriculum provides the graduate with knowledge on financial institutions and technical skills based on established financial theories, methodologies, and various analytical tools. It also promotes an outlook that is based primarily on ethics, market integrity, regulations, good governance, and competitive global perspective, necessary for effective financial decision making.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    )
                                                  ],
                                                ),
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Card(
                            child: ExpansionTile(
                              title: Text(
                                "Bachelor of Science in Office Administration",
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    // fontSize: 12,
                                    ),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Program Goal\n',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Assume supervisory and/or managerial responsibilities within their organization. Pursue graduate studies in business and management. Manage a business.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
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
