import 'package:usapp_mobile/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int pageLen = 3;
  bool isBtnPressed = false;
  String btnNext = "Next";
  String btnPrev = "Back";
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  //first page
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Image.asset('assets/images/welcome.png'),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        const Center(
                          child: Text(
                            'Welcome to UsApp',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 36),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 12,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 75),
                            child: Column(
                              children: [
                                const Text(
                                  'University of Rizal System\'s very own',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                const Text(
                                  'Open community and mobile messaging app',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // SizedBox(
                                //   height: 12,
                                // ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                ),
                                // Text(
                                //   'better communication and learning environment',
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.w300,
                                //       fontSize: 18,
                                //       color: Colors.grey),
                                //   textAlign: TextAlign.center,
                                // ),
                                // SizedBox(
                                //   height: 15,
                                // ),
                                // Text(
                                //   'dedicated to URS Binangonan Students',
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.w300,
                                //       fontSize: 18,
                                //       color: Colors.grey),
                                //   textAlign: TextAlign.center,
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GFButton(
                              onPressed: () {
                                if (_pageController.page!.toInt() ==
                                    pageLen - 1) {
                                  // Navigator.pushNamed(context, Routes.about);
                                } else {
                                  _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeIn);
                                  setState(() {
                                    isBtnPressed = false;
                                  });
                                }
                              },
                              // text: 'Next',
                              child: Row(
                                children: [
                                  Text(
                                    btnNext,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ],
                              ),
                              color: Colors.transparent,
                              elevation: 0,
                              enableFeedback: false,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusElevation: 0,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              blockButton: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //second page
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Image.asset('assets/images/splash-screen.png'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: const [
                            Text(
                              'Better communication and Learning Environment',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18,
                                  color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Dedicated to URS Binangonan Students',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                            color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GFButton(
                              onPressed: () {
                                _pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                                setState(() {
                                  isBtnPressed = false;
                                });
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    btnPrev,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              color: Colors.transparent,
                              elevation: 0,
                              enableFeedback: false,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusElevation: 0,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              blockButton: false,
                            ),
                            GFButton(
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                                setState(() {
                                  isBtnPressed = false;
                                });
                                Navigator.pushNamed(context, Routes.options);
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    'Let\'s get started',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ],
                              ),
                              color: Colors.transparent,
                              elevation: 0,
                              enableFeedback: false,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusElevation: 0,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              blockButton: false,
                            ),
                          ],
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
    );
  }
}
