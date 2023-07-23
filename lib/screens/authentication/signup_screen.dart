import 'package:getwidget/getwidget.dart';
import 'package:usapp_mobile/providers/signup_provider.dart';
import 'package:usapp_mobile/providers/studnumber_provider.dart';
import 'package:usapp_mobile/services/authentication/auth_state.dart';
import 'package:usapp_mobile/utils/auth_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    super.initState();
    _collegeValue;
    _courseValue;
    _yearSecValue;
  }

  final TextEditingController _fullnameCtrl = TextEditingController();
  final TextEditingController _studnumCtrl = TextEditingController();

  //for page&&textformfields
  String? _collegeValue;
  String? _courseValue;
  String? _yearSecValue;

  final bool _isObscure = true;
  int pageLen = 3;
  bool isBtnPressed = false;
  String btnNext = "Next";
  String btnPrev = "Back";
  final PageController _pageController = PageController();

  //dropdown streams
  final Stream<QuerySnapshot> _collegeStream =
      FirebaseFirestore.instance.collection('colleges').snapshots();
  final Stream<QuerySnapshot> _courseStream =
      FirebaseFirestore.instance.collection('courses').snapshots();

  //screen body widget
  Widget _authScreen(BuildContext context, SignupProvider signupProvider) {
    if (context.read<StudentnumberProvider>().state.authStatus ==
        AuthStatus.unverified) {
      Future.delayed(Duration.zero, () async {
        AuthDialog.show(
            context, context.read<StudentnumberProvider>().state.authError);
      });
    }
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // SizedBox(
        //     height: h / 4,
        //     child: Image.asset('assets/images/UsAppLogoWelcome.png')),
        // SizedBox(height: h / 9999),
        SizedBox(
          height: h / 36,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.lightBlue,
                  Colors.blue,
                ],
              ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey,
              //     blurRadius: 9,
              //     offset: Offset(0, 0),
              //   ),
              // ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 9, left: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // color: Colors.blue,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Column(
                    children: [
                      FutureBuilder(
                        // future: context
                        //     .watch<StudentnumberProvider>()
                        //     .showStudnum(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const Text('Error');
                            } else if (snapshot.hasData) {
                              _studnumCtrl.text = snapshot.data!;
                              context
                                  .read<SignupProvider>()
                                  .validateStudnumber(_studnumCtrl.text);

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Student Number:',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(snapshot.data!.toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          // color: Colors.blue,
                                          color: Colors.white,
                                          fontSize: 16)),
                                ],
                              );
                            } else {
                              return const Text('Empty data');
                            }
                          } else {
                            return Text('State: ${snapshot.connectionState}');
                          }
                        },
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      FutureBuilder(
                        // future: context
                        //     .watch<StudentnumberProvider>()
                        //     .showStudname(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const Text('Error');
                            } else if (snapshot.hasData) {
                              _fullnameCtrl.text = snapshot.data!;
                              context
                                  .read<SignupProvider>()
                                  .validateFullname(_fullnameCtrl.text);

                              return Row(
                                children: [
                                  const Text(
                                    'Welcome',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(snapshot.data!.toUpperCase() + '!',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          // color: Colors.blue,
                                          color: Colors.white,
                                          fontSize: 16)),
                                ],
                              );
                            } else {
                              return const Text('Empty data');
                            }
                          } else {
                            return Text('State: ${snapshot.connectionState}');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: w / 30,
              left: 12,
              right: 12,
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.lightBlue,
                    Colors.blue,
                  ],
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 6,
                //     offset: Offset(0, 9),
                //   ),
                // ],
              ),
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              // color: Colors.lightBlue,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  //first page
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: TextFormField(
                            //reference format
                            controller: TextEditingController()
                              ..text = signupProvider.college,
                            onChanged: (value) {
                              signupProvider.validateCollege(value);
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return signupProvider.validateCollege(value!);
                            },
                            // controller: _collegeCtrl,
                            decoration: InputDecoration(
                              // labelText: '',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: _collegeStream,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      List<DropdownMenuItem> currentItems = [];
                                      for (int i = 0;
                                          i < snapshot.data!.docs.length;
                                          i++) {
                                        DocumentSnapshot snap =
                                            snapshot.data!.docs[i];
                                        currentItems.add(DropdownMenuItem(
                                          child: Text(snap
                                              .get('college_name')
                                              .toString()
                                              .toUpperCase()),
                                          value: '${snap.get('college_name')}',
                                        ));
                                      }
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          DropdownButton<dynamic>(
                                            iconEnabledColor: Colors.white,
                                            underline: const Text(''),
                                            hint: const Text(
                                                'Choose College                                                '),
                                            onChanged: (selectedValue) {
                                              setState(() {
                                                _collegeValue = selectedValue;
                                              });
                                              signupProvider.validateCollege(
                                                  selectedValue);
                                            },
                                            items: currentItems,
                                            value: _collegeValue,
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            //reference format
                            controller: TextEditingController()
                              ..text = signupProvider.course,
                            onChanged: (value) {
                              signupProvider.validateCourse(value);
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return signupProvider.validateCourse(value!);
                            },
                            // controller: _courseCtrl,
                            decoration: InputDecoration(
                              labelText: 'Course',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 20),
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: _courseStream,
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      List<DropdownMenuItem> currentItems = [];
                                      for (int i = 0;
                                          i < snapshot.data!.docs.length;
                                          i++) {
                                        DocumentSnapshot snap =
                                            snapshot.data!.docs[i];
                                        currentItems.add(DropdownMenuItem(
                                          child: Text(
                                            snap
                                                .get('course_name')
                                                .toString()
                                                .toUpperCase(),
                                          ),
                                          value: '${snap.get('course_name')}',
                                        ));
                                      }
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          DropdownButton<dynamic>(
                                            iconEnabledColor: Colors.white,
                                            underline: const Text(''),
                                            hint: const Text(
                                                'Choose Course                                                '),
                                            onChanged: (value) {
                                              if (mounted) {
                                                setState(() {
                                                  _courseValue = value;
                                                });
                                              }
                                              signupProvider
                                                  .validateCourse(value);
                                            },
                                            items: currentItems,
                                            value: _courseValue,
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ),
                            // onChanged: context
                            //     .read<SignupProvider>()
                            //     .changeCourse(_courseCtrl.text),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GFButton(
                              onPressed: () {
                                if (_pageController.page!.toInt() ==
                                    pageLen - 1) {
                                  // Navigator.pushNamed(context, Routes.about);
                                } else {
                                  _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 450),
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
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(
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
                      ],
                    ),
                  ),
                  //second page
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            //reference format
                            controller: TextEditingController()
                              ..text = signupProvider.email,
                            onChanged: (value) {
                              signupProvider.validateEmail(value);
                            },
                            validator: (value) {
                              return signupProvider.validateEmail(value!);
                            },
                            // controller: _emailCtrl,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              hintStyle: const TextStyle(
                                  // color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                            // onChanged: context
                            //     .read<SignupProvider>()
                            //     .changeEmail(_emailCtrl.text),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            //reference format
                            controller: TextEditingController()
                              ..text = signupProvider.password,
                            onChanged: (value) {
                              signupProvider.validatePassword(value);
                            },
                            validator: (value) {
                              return signupProvider.validatePassword(value!);
                            },
                            // controller: _passCtrl,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              hintStyle: const TextStyle(
                                // color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            obscureText: _isObscure,
                            // obscureText: _obscureText,
                            // onChanged: (value) => context
                            //     .read<SignupProvider>()
                            //     .validateEmail(_emailCtrl.text),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            //reference format
                            controller: TextEditingController()
                              ..text = signupProvider.confirmedPassword,
                            onChanged: (value) {
                              signupProvider.validatePasswordMatch(value);
                            },
                            validator: (value) {
                              return signupProvider
                                  .validatePasswordMatch(value!);
                            },
                            // controller: _repassCtrl,
                            decoration: InputDecoration(
                              hintText: 'Repeat Password',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: const BorderSide(
                                  width: 2,
                                  // color: Colors.blue,
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              hintStyle: const TextStyle(
                                // color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            obscureText: _isObscure,
                            // obscureText: _obscureText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // SizedBox(
                        //   height: 40,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
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
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: w / 80,
                                  ),
                                  Text(
                                    btnPrev,
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                // primary: Colors.blue,
                                primary: Colors.transparent,
                                elevation: 0,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                                setState(() {
                                  isBtnPressed = false;
                                  context.read<SignupProvider>().registerUser();
                                });
                                //should be a wrapper > checks the user state
                                if (context
                                        .read<SignupProvider>()
                                        .state
                                        .authStatus ==
                                    AuthStatus.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        context
                                            .read<SignupProvider>()
                                            .state
                                            .authError,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Create Account",
                              ),
                              style: ElevatedButton.styleFrom(
                                // primary: Colors.blue,
                                primary: Colors.transparent,
                                elevation: 0,
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up to UsApp')),
      body: Consumer<SignupProvider>(
          builder: (context, signupProvider, child) =>
              _authScreen(context, signupProvider)),
    );
  }
}
