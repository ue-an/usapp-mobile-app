import 'package:restart_app/restart_app.dart';
import 'package:usapp_mobile/providers/login_provider.dart';
import 'package:usapp_mobile/services/authentication/auth_state.dart';
import 'package:usapp_mobile/utils/auth_dialog.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;

  Widget _authScreen(BuildContext context, LoginProvider loginProvider) {
    if (loginProvider.state.authStatus == AuthStatus.error) {
      Future.delayed(Duration.zero, () async {
        AuthDialog.show(context, loginProvider.state.authError);
      });
    }
    return Stack(
      children: [
        SingleChildScrollView(
          reverse: true,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        // color: Colors.white,
                        color: Colors.blue,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightBlue[400],
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          // Colors.cyan,
                          Colors.white70,
                          Colors.white60,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "LOG IN",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[400],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: TextFormField(
                              style: TextStyle(color: Colors.lightBlue[900]),
                              // controller: _emailCtrl,
                              // controller: TextEditingController()
                              //   ..text = loginProvider.email,
                              onChanged: (value) => loginProvider.email = value,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                    color: Colors.lightBlue,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                    color: Colors.lightBlue,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: TextFormField(
                              style: TextStyle(color: Colors.lightBlue[900]),
                              // controller: _passCtrl,
                              // controller: TextEditingController()
                              //   ..text = loginProvider.password,
                              onChanged: (value) =>
                                  loginProvider.password = value,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                    color: Colors.lightBlue,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: const BorderSide(
                                    color: Colors.lightBlue,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: IconButton(
                                  icon: _isObscure
                                      ? const Icon(
                                          Icons.visibility,
                                          color: Colors.lightBlue,
                                        )
                                      : const Icon(
                                          Icons.visibility_off,
                                          color: Colors.lightBlue,
                                        ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _isObscure,
                              validator: (val) => val!.length < 6
                                  ? 'Password too short.'
                                  : null,
                              // onSaved: (val) => _password = val!,
                              // obscureText: _obscureText,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GFButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot Password",
                                  // style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                          GFButton(
                            elevation: 5,
                            color: Colors.white,
                            borderSide: BorderSide(
                                color: Colors.lightBlue[400]!, width: 2),
                            onPressed: () async {
                              // context.read<LoginProvider>().loginUser();
                              // FlutterRestart.restartApp();
                              loginProvider.loginUser();
                            },
                            child: Text(
                              "LOG IN",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue[600]!,
                              ),
                            ),
                            shape: GFButtonShape.pills,
                            // color: Colors.white,
                            fullWidthButton: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: const [
                              // Text(context.watch<StudentnumberProvider>().showName()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
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
        ),
        Consumer<LoginProvider>(
            builder: (context, loginProvider, child) =>
                _authScreen(context, loginProvider)),
      ]),
    );
  }
}
