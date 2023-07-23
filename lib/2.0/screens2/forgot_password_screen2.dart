import 'package:email_auth/email_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:usapp_mobile/2.0/providers2/auth_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/otp_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/will_pop_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';
import 'package:usapp_mobile/2.0/utils2/routes2.dart';

class ForgotPasswordScreen2 extends StatefulWidget {
  const ForgotPasswordScreen2({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen2> createState() => _ForgotPasswordScreen2State();
}

class _ForgotPasswordScreen2State extends State<ForgotPasswordScreen2> {
  TextEditingController _emailCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AuthProvider2 authProvider2 = AuthProvider2();

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: size.width / 2,
                ),
                Container(
                    height: double.infinity,
                    width: size.width / 2,
                    color: kPrimaryColor),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                    top: size.height / 25,
                    bottom: size.height / 12,
                    right: 32,
                    left: 32),
                child: const Text(
                  "\nUsApp Tayo! \n\nURS Binangonan's own messaging \nand forum application for students.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: size.height / 20,
                  bottom: size.height / 12,
                  right: 32,
                  left: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "UsApp",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  "A capstone project develop by \nURS students for URS students",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "Technocrats 2021",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),

              //Animation 2
              transitionBuilder: (widget, animation) =>
                  ScaleTransition(child: widget, scale: animation),
              child: WillPopScope(
                onWillPop: () =>
                    context.read<WillPopProvider2>().onWillPop(context),
                child: Padding(
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
                        side: BorderSide(
                          color: kPrimaryColor,
                          width: 6,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: AnimatedContainer(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.white,
                        ),
                        duration: const Duration(milliseconds: 200),
                        height: size.height *
                            (size.height > 770
                                ? 0.6
                                : size.height > 670
                                    ? 0.7
                                    : 0.8),
                        width: 500,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "RESET PASSWORD",
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
                                  TextFormField(
                                    // controller: _emailCtrl,
                                    onChanged: (value) =>
                                        authProvider2.changeResetEmail = value,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        borderSide: const BorderSide(
                                          color: kPrimaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        borderSide: const BorderSide(
                                          color: kPrimaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      labelText: 'Email',
                                      labelStyle: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: kPrimaryColor,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.mail_outline,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    cursorColor: kPrimaryColor,
                                    style:
                                        const TextStyle(color: kPrimaryColor),
                                    validator: (email) => email != null &&
                                            !EmailValidator.validate(email)
                                        ? 'Enter a valid email'
                                        : null,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  GFButton(
                                    onPressed: () async {
                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: authProvider2.resetEmail
                                                    .trim());
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            });
                                        Future.delayed(
                                            const Duration(milliseconds: 3000),
                                            () async {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Reset password sent to email'),
                                            duration:
                                                Duration(milliseconds: 2000),
                                          ));
                                          Navigator.of(context).pop();
                                          _emailCtrl.clear();
                                        });
                                      } on FirebaseAuthException catch (e) {
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
                                                              .read<
                                                                  ThemeProvider2>()
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
                                                      Text(
                                                          e.message.toString()),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Close'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      }
                                    },
                                    shape: GFButtonShape.pills,
                                    fullWidthButton: true,
                                    color: kPrimaryColor,
                                    text: 'Send password reset email',
                                    size: GFSize.LARGE,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: kPrimaryColor,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          "Back to login page",
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
