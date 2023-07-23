import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/providers2/firstread_provider.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/otp_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/studentnumber_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/will_pop_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/pushnotification/notification_provider.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';

class ValidateScreen2 extends StatefulWidget {
  final Function onLoginSelected;
  final Size size;
  const ValidateScreen2(
      {Key? key, required this.onLoginSelected, required this.size})
      : super(key: key);

  @override
  State<ValidateScreen2> createState() => _ValidateScreen2State();
}

class _ValidateScreen2State extends State<ValidateScreen2> {
  final TextEditingController _studentNumCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => context.read<WillPopProvider2>().onWillPop(context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: widget.size.height > 770
              ? 64
              : widget.size.height > 670
                  ? 32
                  : 16,
          horizontal: widget.size.width > 770
              ? 32
              : widget.size.width > 670
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
              height: widget.size.height *
                  (widget.size.height > 770
                      ? 0.4
                      : widget.size.height > 670
                          ? 0.5
                          : 0.6),
              width: 500,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Validate Student Number",
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
                          height: 32,
                        ),
                        // student number formfield
                        TextFormField(
                          maxLength: 10,
                          controller: _studentNumCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) => context
                              .read<StudentNumberProvider2>()
                              .changeStudentNumber = value,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: const BorderSide(
                                color: kPrimaryColor,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: const BorderSide(
                                color: kPrimaryColor,
                                width: 2,
                              ),
                            ),
                            labelText: 'Student Number',
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: kPrimaryColor,
                            ),
                            prefixIcon: const Icon(
                              Icons.assignment_ind,
                              color: kPrimaryColor,
                            ),
                          ),
                          cursorColor: kPrimaryColor,
                          style: const TextStyle(color: kPrimaryColor),
                          onSaved: (newValue) => newValue!.isEmpty
                              ? context
                                  .read<StudentNumberProvider2>()
                                  .changeStudentNumber = ''
                              : context
                                  .read<StudentNumberProvider2>()
                                  .changeStudentNumber = newValue,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Center(
                          child: GFButton(
                            // verifies the validity of student number
                            onPressed: () async {
                              await context
                                  .read<StudentNumberProvider2>()
                                  .verifyStudentNumber();
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              // ======== condition =========
                              if (context
                                      .read<StudentNumberProvider2>()
                                      .verifiedStudentNumber ==
                                  true) {
                                //next validation(email) popup
                                Future.delayed(
                                    const Duration(milliseconds: 2000), () {
                                  Navigator.maybePop(context);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: widget.size.height > 770
                                                ? 64
                                                : widget.size.height > 670
                                                    ? 32
                                                    : 16,
                                            horizontal: widget.size.width > 770
                                                ? 32
                                                : widget.size.width > 670
                                                    ? 16
                                                    : 8,
                                          ),
                                          child: Center(
                                            child: Card(
                                              elevation: 9,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(25),
                                                ),
                                              ),
                                              child: AnimatedContainer(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: kPrimaryColor,
                                                      width: 6,
                                                    )),
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                height: widget.size.height *
                                                    (widget.size.height > 770
                                                        ? 0.7
                                                        : widget.size.height >
                                                                670
                                                            ? 0.5
                                                            : 0.5),
                                                width: 500,
                                                child: Center(
                                                  child: SingleChildScrollView(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Validate Student Email",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors
                                                                  .grey[700],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Container(
                                                            width: 30,
                                                            child:
                                                                const Divider(
                                                              color:
                                                                  kPrimaryColor,
                                                              thickness: 2,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 32,
                                                          ),
                                                          // student email formfield
                                                          TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .emailAddress,
                                                            controller:
                                                                _emailCtrl,
                                                            onChanged: (value) => context
                                                                    .read<
                                                                        StudentNumberProvider2>()
                                                                    .changeStudentEmail =
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
                                                              labelText:
                                                                  'Registered Email',
                                                              labelStyle:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    kPrimaryColor,
                                                              ),
                                                              prefixIcon:
                                                                  const Icon(
                                                                Icons
                                                                    .assignment_ind,
                                                                color:
                                                                    kPrimaryColor,
                                                              ),
                                                            ),
                                                            cursorColor:
                                                                kPrimaryColor,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 32,
                                                          ),
                                                          GFButton(
                                                            // check if the emails are matched
                                                            onPressed:
                                                                () async {
                                                              if (_emailCtrl
                                                                  .text
                                                                  .isNotEmpty) {
                                                                _emailCtrl
                                                                    .clear();
                                                                await context
                                                                    .read<
                                                                        StudentNumberProvider2>()
                                                                    .verifyStudentEmail();
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (context) {
                                                                    return const Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                              // ======== condition =========
                                                              if (context
                                                                      .read<
                                                                          StudentNumberProvider2>()
                                                                      .verifiedStudentEmail ==
                                                                  true) {
                                                                context
                                                                        .read<
                                                                            OtpProvider2>()
                                                                        .changeEmail =
                                                                    _emailCtrl
                                                                        .text;
                                                                context
                                                                        .read<
                                                                            OtpProvider2>()
                                                                        .changeStudentNumber =
                                                                    _studentNumCtrl
                                                                        .text;
                                                                //-------------------
                                                                //
                                                                //
                                                                //
                                                                //
                                                                //-
                                                                context
                                                                        .read<
                                                                            NotificationProvider>()
                                                                        .ownerEmail =
                                                                    _emailCtrl
                                                                        .text;
                                                                //------------------------------
                                                                context
                                                                        .read<
                                                                            FirstReadProvider>()
                                                                        .changeStudentNum =
                                                                    _studentNumCtrl
                                                                        .text;
                                                                //----------------------------
                                                                //
                                                                //----
                                                                Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            1000),
                                                                    () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushReplacementNamed(
                                                                          Routes2
                                                                              .signup2);
                                                                });
                                                              } else {
                                                                _emailCtrl
                                                                    .clear();
                                                                Future.delayed(
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    () {
                                                                  Navigator
                                                                      .maybePop(
                                                                          context);
                                                                  showDialog(
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
                                                                              color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 6,
                                                                            ),
                                                                            Text(
                                                                              'Email Not Found',
                                                                              style: TextStyle(
                                                                                color: context.read<ThemeProvider2>().isDark ? Colors.white : kPrimaryColor,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        content:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              ListBody(
                                                                            children: <Widget>[
                                                                              Text('Email provided does not match in our database for ${_studentNumCtrl.text}'),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          TextButton(
                                                                            child:
                                                                                const Text('Okay'),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                });
                                                              }
                                                            },
                                                            child: const Text(
                                                              'Proceed',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            color:
                                                                kPrimaryColor,
                                                            shape: GFButtonShape
                                                                .pills,
                                                            size: GFSize.LARGE,
                                                            fullWidthButton:
                                                                true,
                                                          ),
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
                                    },
                                  );
                                });
                                // });
                              } else if (_studentNumCtrl.text == '') {
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  _studentNumCtrl.clear();
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
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
                                              'Invalid Input',
                                              style: TextStyle(
                                                color: context
                                                        .read<ThemeProvider2>()
                                                        .isDark
                                                    ? Colors.white
                                                    : kPrimaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                  'Please provide a student number'),
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
                                });
                              } else {
                                Future.delayed(
                                    const Duration(milliseconds: 1000), () {
                                  _studentNumCtrl.clear();
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
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
                                              'Invalid Student Number',
                                              style: TextStyle(
                                                color: context
                                                        .read<ThemeProvider2>()
                                                        .isDark
                                                    ? Colors.white
                                                    : kPrimaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                  'Provided student number does not exist or already have an account.'),
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
                                });
                              }
                            },
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: kPrimaryColor,
                            fullWidthButton: true,
                            size: GFSize.LARGE,
                            shape: GFButtonShape.pills,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.onLoginSelected();
                                });
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    "Log In",
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: kPrimaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
  }
}
