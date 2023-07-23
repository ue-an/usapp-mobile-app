import 'package:usapp_mobile/utils/routes.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              // Colors.blue,
              // Colors.cyan,
              Colors.lightBlue[300]!,
              Colors.blue[200]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              // Expanded(child: Image.asset('assets/images/logokuno.png')),
              Expanded(
                  child: Image.asset('assets/images/UsAppLogoWelcome.png')),
              // Expanded(child: Container()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: const Size(120, 40),
                                elevation: 2.0,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.studentReg,
                                );
                              },
                              child: const Text(
                                'SIgn Up',
                                style: TextStyle(
                                  // color: Color(0xFF389EAA),
                                  color: Colors.blue,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              style: ElevatedButton.styleFrom(
                                // primary: const Color(0xFF389EAA),
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: const Size(120, 40),
                                elevation: 2.0,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.login,
                                );
                              },
                              child: const Text(
                                'Log In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
      ),
    );
  }
}
