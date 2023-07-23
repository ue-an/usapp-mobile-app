import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/providers2/firstread_provider.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/otp_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/studentnumber_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';
import 'package:usapp_mobile/models/student.dart';

class SignupScreen2 extends StatefulWidget {
  const SignupScreen2({Key? key}) : super(key: key);

  @override
  State<SignupScreen2> createState() => _SignupScreen2State();
}

class _SignupScreen2State extends State<SignupScreen2>
    with AutomaticKeepAliveClientMixin<SignupScreen2> {
  bool _isVisited = false;
  @override
  bool get wantKeepAlive => _isVisited;
  late Stream<StudentNumber> _firstStreamStudent;
  TextEditingController _otpCtrl = TextEditingController();

  //Send OTP Process
  @override
  void initState() {
    _firstStreamStudent = context.read<FirstReadProvider>().firstStreamStudent;
    super.initState();
    context.read<OtpProvider2>().changeEmailAuth = EmailAuth(
        sessionName: "UsApp: URS Messaging and Forum App Student Account");
    setState(() {
      _isVisited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    //================
    return StreamBuilder<StudentNumber>(
      stream: _firstStreamStudent,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('inside firstStream');
          print(context.read<StudentNumberProvider2>().studentNumber);
          print(context.read<StudentNumberProvider2>().studentEmail);

          (() async {
            //store to local from signup
            await context
                .read<LocalDataProvider2>()
                .storeLocalCourse(snapshot.data!.course);
            await context
                .read<LocalDataProvider2>()
                .storeLocalEmail(snapshot.data!.email);
            await context
                .read<LocalDataProvider2>()
                .storeLocalFirstName(snapshot.data!.firstName);
            await context
                .read<LocalDataProvider2>()
                .storeLocalLastName(snapshot.data!.lastName);
            await context.read<LocalDataProvider2>().storeLocalFullname(
                snapshot.data!.firstName, snapshot.data!.lastName);
            await context
                .read<LocalDataProvider2>()
                .storeLocalStudentNumber(snapshot.data!.studentNumber);
            await context
                .read<LocalDataProvider2>()
                .storeLocalYearLevel(snapshot.data!.yearLvl);
            await context
                .read<LocalDataProvider2>()
                .storeLocalSection(snapshot.data!.section);
          }());

          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height > 770
                    ? 64
                    : size.height > 670
                        ? 32
                        : 16,
                horizontal: size.width > 770
                    ? 32
                    : size.width > 670
                        ? 16
                        : 8,
              ),
              child: Center(
                child: Card(
                  elevation: 9,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 6,
                        )),
                    duration: const Duration(milliseconds: 200),
                    height: size.height *
                        (size.height > 770
                            ? 0.3
                            : size.height > 670
                                ? 0.3
                                : 0.3),
                    width: 500,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "CONFIRM EMAIL",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              Container(
                                width: 30,
                                child: const Divider(
                                  color: kPrimaryColor,
                                  thickness: 2,
                                ),
                              ),

                              const SizedBox(
                                height: 6,
                              ),
                              //=======
                              Text(
                                context
                                    .read<StudentNumberProvider2>()
                                    .studentEmail,
                                style: const TextStyle(
                                  color: kPrimaryColor,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              GFButton(
                                onPressed: () async {
                                  await context
                                      .read<LocalDataProvider2>()
                                      .storeLocalCollege(
                                          snapshot.data!.college);
                                  context
                                      .read<FirstReadProvider>()
                                      .changeFirstStudent = snapshot.data!;
                                  context
                                      .read<LocalDataProvider2>()
                                      .storeLocalFullname(
                                          context
                                              .read<FirstReadProvider>()
                                              .firstStudent
                                              .firstName,
                                          context
                                              .read<FirstReadProvider>()
                                              .firstStudent
                                              .lastName);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );

                                  await context.read<OtpProvider2>().sendOTP(
                                      context
                                          .read<StudentNumberProvider2>()
                                          .studentEmail);

                                  if (context
                                          .read<OtpProvider2>()
                                          .submitValid ==
                                      true) {
                                    Navigator.maybePop(context);
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.warning,
                                                color: context
                                                        .read<ThemeProvider2>()
                                                        .isDark
                                                    ? Colors.white
                                                    : kPrimaryColor,
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                'Input Code',
                                                style: TextStyle(
                                                  color: context
                                                          .read<
                                                              ThemeProvider2>()
                                                          .isDark
                                                      ? Colors.white
                                                      : kPrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Column(
                                                  children: [
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      maxLength: 6,
                                                      onChanged: (value) =>
                                                          context
                                                                  .read<
                                                                      OtpProvider2>()
                                                                  .changeOTP =
                                                              value.trim(),
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color:
                                                                kPrimaryColor,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      24.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color:
                                                                kPrimaryColor,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        labelText: 'OTP',
                                                        labelStyle:
                                                            const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: kPrimaryColor,
                                                        ),
                                                        prefixIcon: const Icon(
                                                          Icons.lock_outline,
                                                          color: kPrimaryColor,
                                                        ),
                                                      ),
                                                      cursorColor:
                                                          kPrimaryColor,
                                                      style: const TextStyle(
                                                          color: kPrimaryColor),
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: kPrimaryColor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(25),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: kPrimaryColor
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 4,
                                                            blurRadius: 7,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: GFButton(
                                                        onPressed: () async {
                                                          context
                                                              .read<
                                                                  OtpProvider2>()
                                                              .verifyOTP();
                                                          context
                                                                      .read<
                                                                          OtpProvider2>()
                                                                      .isVerified ==
                                                                  true
                                                              // ? Navigator.pushNamed(
                                                              //     context, Routes2.create2)
                                                              ? Navigator
                                                                  .pushReplacementNamed(
                                                                      context,
                                                                      Routes2
                                                                          .create2)
                                                              : showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.warning,
                                                                            color: context.read<ThemeProvider2>().isDark
                                                                                ? Colors.white
                                                                                : kPrimaryColor,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                6,
                                                                          ),
                                                                          Text(
                                                                            'Authentication Error',
                                                                            style:
                                                                                TextStyle(
                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      content:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            ListBody(
                                                                          children: const [
                                                                            Text('OTP Code does not match'),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          child:
                                                                              const Text('Cancel'),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                        },
                                                        child: const Text(
                                                          'Verify Code',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        color: kPrimaryColor,
                                                        fullWidthButton: true,
                                                        size: GFSize.LARGE,
                                                        shape:
                                                            GFButtonShape.pills,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Close'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    // print('here hey');
                                  } else {
                                    // showDialog(
                                    //   context: context,
                                    //   barrierDismissible: false,
                                    //   builder: (context) {
                                    //     return Center(
                                    //       child: CircularProgressIndicator(),
                                    //     );
                                    //   },
                                    // );
                                    print('here');
                                  }
                                },
                                child: const Text(
                                  'Send OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                color: kPrimaryColor,
                                shape: GFButtonShape.pills,
                                size: GFSize.LARGE,
                                fullWidthButton: true,
                              ),
                              const SizedBox(
                                height: 32,
                              ),

                              // actionButton("Create Account"),

                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
