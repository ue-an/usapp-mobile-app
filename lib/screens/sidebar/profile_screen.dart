import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:usapp_mobile/models/account.dart' as user;
import 'package:usapp_mobile/providers/signup_provider.dart';
import 'package:usapp_mobile/providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Stream<QuerySnapshot> _collegeStream =
      FirebaseFirestore.instance.collection('colleges').snapshots();
  final Stream<QuerySnapshot> _courseStream =
      FirebaseFirestore.instance.collection('courses').snapshots();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _fullnameCtrl = TextEditingController();
    final TextEditingController _studnumCtrl = TextEditingController();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    // Future<user.User> curUser = context.read<UserProvider>().getUserDetails();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Profile"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: Colors.lightBlue,
                height: h / 8,
              ),
              SizedBox(
                height: h / 7,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    // color: Colors.lightBlue.withOpacity(0.6),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.lightBlue[300]!,
                        Colors.blue,
                      ],
                    ),
                  ),
                  height: h / 1.5,
                ),
              ),
            ],
          ),
          Column(
            children: [
              // Text(FirebaseAuth.instance.currentUser?.email ?? 'No user'),
              SizedBox(
                height: h / 40,
              ),
              Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage('https://i.pravatar.cc/'),
                          backgroundColor: Colors.transparent,
                        ),
                        GFButton(
                          onPressed: () {},
                          color: Colors.lightBlue,
                          child: const Text("Change photo"),
                          shape: GFButtonShape.pills,
                          size: GFSize.SMALL,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                // future: context.read<UserProvider>().getUserDetails(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          children: [
                            // onChanged: context
                            //     .read<SignupProvider>()
                            //     .changeEmail(_emailCtrl.text),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: w / 12),
                                const Text("Email "),
                              ],
                            ),
                            // Text(snapshot.data!.email),
                            SizedBox(
                              height: h / 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: w / 12),
                                const Text("Full name "),
                              ],
                            ),
                            // Text(snapshot.data!.fullname),
                            SizedBox(
                              height: h / 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: w / 12),
                                const Text("College "),
                              ],
                            ),
                            // Text(snapshot.data!.college.toUpperCase()),
                            SizedBox(
                              height: h / 30,
                            ),
                          ],
                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          //reference format
                          controller: TextEditingController()
                            ..text = context.read<SignupProvider>().username,
                          onChanged: (value) {
                            context
                                .read<SignupProvider>()
                                .validateUsername(value);
                          },
                          validator: (value) {
                            return context
                                .read<SignupProvider>()
                                .validateUsername(value!);
                          },
                          // controller: _usernameCtrl,
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: const BorderSide(
                                width: 2,
                                color: Colors.blue,
                                // color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: const BorderSide(
                                width: 2,
                                color: Colors.blue,
                                // color: Colors.white,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            labelStyle: const TextStyle(
                                // color: Colors.white,
                                // fontWeight: FontWeight.w300,
                                ),
                          ),
                          // onChanged: context
                          //     .read<SignupProvider>()
                          //     .changeEmail(_emailCtrl.text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          //reference format
                          controller: TextEditingController()
                            ..text = context.read<SignupProvider>().username,
                          onChanged: (value) {
                            context
                                .read<SignupProvider>()
                                .validateUsername(value);
                          },
                          validator: (value) {
                            return context
                                .read<SignupProvider>()
                                .validateUsername(value!);
                          },
                          // controller: _usernameCtrl,
                          decoration: InputDecoration(
                            label: const Text('Full name'),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: const BorderSide(
                                width: 2,
                                color: Colors.blue,
                                // color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: const BorderSide(
                                width: 2,
                                color: Colors.blue,
                                // color: Colors.white,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            labelStyle: const TextStyle(
                                // color: Colors.white,
                                // fontWeight: FontWeight.w300,
                                ),
                          ),
                          // onChanged: context
                          //     .read<SignupProvider>()
                          //     .changeEmail(_emailCtrl.text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          //reference format
                          controller: TextEditingController()
                            ..text = context.read<SignupProvider>().username,
                          onChanged: (value) {
                            context
                                .read<SignupProvider>()
                                .validateUsername(value);
                          },
                          validator: (value) {
                            return context
                                .read<SignupProvider>()
                                .validateUsername(value!);
                          },
                          // controller: _usernameCtrl,
                          decoration: InputDecoration(
                            label: const Text('College'),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: const BorderSide(
                                width: 2,
                                color: Colors.blue,
                                // color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: const BorderSide(
                                width: 2,
                                color: Colors.blue,
                                // color: Colors.white,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            labelStyle: const TextStyle(
                                // color: Colors.white,
                                // fontWeight: FontWeight.w300,
                                ),
                          ),
                          // onChanged: context
                          //     .read<SignupProvider>()
                          //     .changeEmail(_emailCtrl.text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GFButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Colors.red,
                              text: 'Cancel',
                            ),
                            GFButton(
                              onPressed: () {},
                              text: 'Submit request',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.edit),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
