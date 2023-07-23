import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/providers2/theme/theme_provider2.dart';
import 'package:usapp_mobile/2.0/providers2/will_pop_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/authentication/login_screen2.dart';
import 'package:usapp_mobile/2.0/screens2/authentication/validate_screen2.dart';
import 'package:usapp_mobile/2.0/utils2/constants.dart';

class StartPage2 extends StatefulWidget {
  const StartPage2({Key? key}) : super(key: key);

  @override
  _StartPage2State createState() => _StartPage2State();
}

class _StartPage2State extends State<StartPage2> {
  Option selectedOption = Option.logIn;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  // color: kContentColorDarkTheme,
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
                child: Text(
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
                // mainAxisAlignment: MainAxisAlignment.center,
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
              child: selectedOption == Option.logIn
                  ? WillPopScope(
                      onWillPop: () =>
                          context.read<WillPopProvider2>().onWillPop(context),
                      child: LoginScreen2(
                          size: size,
                          onSignUpSelected: () {
                            setState(() {
                              selectedOption = Option.signUp;
                            });
                          }),
                    )
                  : WillPopScope(
                      onWillPop: () =>
                          context.read<WillPopProvider2>().onWillPop(context),
                      child: ValidateScreen2(
                          size: size,
                          onLoginSelected: () {
                            setState(() {
                              selectedOption = Option.logIn;
                            });
                          }),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
