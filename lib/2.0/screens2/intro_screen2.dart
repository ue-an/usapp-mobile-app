import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';

class IntroScreen2 extends StatefulWidget {
  const IntroScreen2({Key? key}) : super(key: key);

  @override
  State<IntroScreen2> createState() => _IntroScreen2State();
}

class _IntroScreen2State extends State<IntroScreen2> {
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          child: Image.asset('assets/images/welcome.png'),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Welcome to UsApp',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 75),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'University of Rizal System\'s',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const Text(
                                'Community forum and mobile messaging app',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // SizedBox(
                              //   height: 12,
                              // ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 15,
                              ),
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
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeIn);
                                setState(() {
                                  isBtnPressed = false;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  btnNext,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
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
                  //second page
                  ListView(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          child:
                              Image.asset('assets/images/UsAppLogoWelcome.png'),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text(
                                'TERMS AND CONDITIONS',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'These terms and conditions (“Agreement”) set forth the general terms and conditions of your use of the “UsApp” mobile application (“Mobile Application” or “Service”) and any of its related products and services (collectively, “Services”). This Agreement is legally binding between you (“User”, “you” or “your”) and this Mobile Application developer (“Operator”, “we”, “us” or “our”). If you are entering into this agreement on behalf of a business or other legal entity, you represent that you have the authority to bind such entity to this agreement, in which case the terms “User”, “you” or “your” shall refer to such entity. If you do not have such authority, or if you do not agree with the terms of this agreement, you must not accept this agreement and may not access and use the Mobile Application and Services. By accessing and using the Mobile Application and Services, you acknowledge that you have read, understood, and agree to be bound by the terms of this Agreement. You acknowledge that this Agreement is a contract between you and the Operator, even though it is electronic and is not physically signed by you, and it governs your use of the Mobile Application and Services. This terms and conditions policy was created with the help of the terms and conditions generator.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //=======================
                              Text(
                                'ACCOUNTS AND MEMBERSHIP',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'You must be a bonafide student of University of Rizal System Binangonan Campus to use the Mobile Application and Services. By using the Mobile Application and Services and by agreeing to this agreement. If you create an account in the Mobile Application, you are responsible for maintaining the security of your account and you are fully responsible for all activities that occur under the account and any other actions taken in connection with it. We may monitor and review new accounts before you may sign in and start using the Services. Providing false contact information of any kind may result in the termination of your account. You must immediately notify us of any unauthorized uses of your account or any other breaches of security. We will not be liable for any acts or omissions by you, including any damages of any kind incurred as a result of such acts or omissions. We may suspend, disable, or delete your account (or any part thereof) if we determine that you have violated any provision of this Agreement or that your conduct or content would tend to damage our reputation and goodwill. If we delete your account for the foregoing reasons, you may not re-register for our Services. We may block your email address and Internet protocol address to prevent further registration.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //==========================
                              Text(
                                'USER CONTENT',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'We do not own any data, information or material (collectively, “Content”) that you submit in the Mobile Application in the course of using the Service. You shall have sole responsibility for the accuracy, quality, integrity, legality, reliability, appropriateness, and intellectual property ownership or right to use of all submitted Content. We may, but have no obligation to, monitor and review the Content in the Mobile Application submitted or created using our Services by you. You grant us permission to access, copy, distribute, store, transmit, reformat, display and perform the Content of your user account solely as required for the purpose of providing the Services to you. Without limiting any of those representations or warranties, we have the right, though not the obligation, to, in our own sole discretion, refuse or remove any Content that, in our reasonable opinion, violates any of our policies or is in any way harmful or objectionable. Unless specifically permitted by you, your use of the Mobile Application and Services does not grant us the license to use, reproduce, adapt, modify, publish or distribute the Content created by you or stored in your user account for commercial, marketing or any similar purpose.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //==========================
                              Text(
                                'ADULT CONTENT',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Please be aware that there may be certain adult or mature content available in the Mobile Application. Where there is mature or adult content, individuals who are less than 18 years of age or are not permitted to access such content under the laws of any applicable jurisdiction may not access such content. If we learn that anyone under the age of 18 seeks to conduct a transaction through the Services, we will require verified parental consent, in accordance with the Children’s Online Privacy Protection Act of 1998 (“COPPA”). Certain areas of the Mobile Application and Services may not be available to children under 18 under any circumstances.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //==========================
                              Text(
                                'BACKUPS',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'We perform regular backups of the Content and will do our best to ensure completeness and accuracy of these backups. In the event of the hardware failure or data loss we will restore backups automatically to minimize the impact and downtime.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //==========================
                              Text(
                                'LINKS TO OTHER RESOURCES',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Although the Mobile Application and Services may link to other resources (such as websites, mobile applications, etc.), we are not, directly or indirectly, implying any approval, association, sponsorship, endorsement, or affiliation with any linked resource, unless specifically stated herein. Some of the links in the Mobile Application may be “affiliate links”. This means if you click on the link and purchase an item, the Operator will receive an affiliate commission. We are not responsible for examining or evaluating, and we do not warrant the offerings of, any businesses or individuals or the content of their resources. We do not assume any responsibility or liability for the actions, products, services, and content of any other third parties. You should carefully review the legal statements and other conditions of use of any resource which you access through a link in the Mobile Application. Your linking to any other off-site resources is at your own risk.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //==========================
                              Text(
                                'PROHIBITED USES',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'In addition to other terms as set forth in the Agreement, you are prohibited from using the Mobile Application and Services or Content: (a) for any unlawful purpose; (b) to solicit others to perform or participate in any unlawful acts; (c) to violate any international, federal, provincial or state regulations, rules, laws, or local ordinances; (d) to infringe upon or violate our intellectual property rights or the intellectual property rights of others; (e) to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability; (f) to submit false or misleading information; (g) to upload or transmit viruses or any other type of malicious code that will or may be used in any way that will affect the functionality or operation of the Mobile Application and Services, third party products and services, or the Internet; (h) to spam, phish, pharm, pretext, spider, crawl, or scrape; (i) for any obscene or immoral purpose; or (j) to interfere with or circumvent the security features of the Mobile Application and Services, third party products and services, or the Internet. We reserve the right to terminate your use of the Mobile Application and Services for violating any of the prohibited uses.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //==========================
                              Text(
                                'CHANGES AND AMENDMENTS',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'We reserve the right to modify this Agreement or its terms related to the Mobile Application and Services at any time at our discretion. When we do, we will post a notification in the Mobile Application. We may also provide notice to you in other ways at our discretion, such as through the contact information you have provided. An updated version of this Agreement will be effective immediately upon the posting of the revised Agreement unless otherwise specified. Your continued use of the Mobile Application and Services after the effective date of the revised Agreement (or such other act specified at that time) will constitute your consent to those changes.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //==========================
                              Text(
                                'ACCEPTANCE OF THESE TERMS',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'You acknowledge that you have read this Agreement and agree to all its terms and conditions. By accessing and using the Mobile Application and Services you agree to be bound by this Agreement. If you do not agree to abide by the terms of this Agreement, you are not authorized to access or use the Mobile Application and Services.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //==========================
                              Text(
                                'CONTACTING US',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'If you have any questions, concerns, or complaints regarding this Agreement, we encourage you to contact us using the details below:\nbinangonan.registrar@urs.edu.ph',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //==========================
                            ],
                          ),
                        ),
                      ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  btnPrev,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
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
                              if (_pageController.page!.toInt() ==
                                  pageLen - 1) {
                                // Navigator.pushNamed(context, Routes.about);
                              } else {
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeIn);
                                setState(() {
                                  isBtnPressed = false;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  'I Agree',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.check,
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
                  //third page
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          child:
                              Image.asset('assets/images/av_phone-stand.png'),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: const [
                            Text(
                              'Better communication and Learning Environment',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      const Text(
                        'Dedicated to URS Binangonan Students',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height / 4,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // GFButton(
                            //   onPressed: () {
                            //     _pageController.previousPage(
                            //         duration: const Duration(milliseconds: 500),
                            //         curve: Curves.easeIn);
                            //     setState(() {
                            //       isBtnPressed = false;
                            //     });
                            //   },
                            //   child: Row(
                            //     children: [
                            //       const Icon(
                            //         Icons.arrow_back_ios,
                            //         color: Colors.white,
                            //         size: 18,
                            //       ),
                            //       const SizedBox(width: 12),
                            //       Text(
                            //         btnPrev,
                            //         style: const TextStyle(
                            //           color: Colors.white,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            //   color: Colors.transparent,
                            //   elevation: 0,
                            //   enableFeedback: false,
                            //   focusColor: Colors.transparent,
                            //   highlightColor: Colors.transparent,
                            //   focusElevation: 0,
                            //   hoverElevation: 0,
                            //   highlightElevation: 0,
                            //   blockButton: false,
                            // ),
                            GFButton(
                              onPressed: () async {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                                setState(() {
                                  isBtnPressed = false;
                                });

                                Navigator.pushReplacementNamed(
                                    context, Routes2.startpage2);
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    'Let\'s get started',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
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
