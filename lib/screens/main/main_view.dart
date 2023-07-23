import 'package:getwidget/getwidget.dart';
import 'package:usapp_mobile/providers/user_provider.dart';
import 'package:usapp_mobile/screens/bottomnav/messages_screen.dart';
import 'package:usapp_mobile/screens/bottomnav/notifications.dart';
import 'package:usapp_mobile/screens/main/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usapp_mobile/providers/login_provider.dart';
import 'package:usapp_mobile/services/authentication/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:usapp_mobile/utils/routes.dart';
import 'package:usapp_mobile/models/account.dart' as User;

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  static final List<Widget> _widgetOptions = [
    // Center(child: Text('Draft')),
    // Container(),
    const MessagesScreen(),
    const HomeScreen(),
    const NotificationsScreen(),
  ];

  int _selectedIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: Stack(
            children: [
              Container(
                height: h / 6,
                // color: Colors.lightBlue,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.lightBlue[300]!,
                      Colors.blue,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 9),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage('https://i.pravatar.cc/'),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 6,
                            ),
                            FutureBuilder(
                              // future:
                              //     context.read<UserProvider>().getUserDetails(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return const Text('Error');
                                  } else if (snapshot.hasData) {
                                    return Column(
                                      children: [
                                        // Text(snapshot.data!.fullname),
                                        // Text(snapshot.data!.college.toUpperCase()),
                                      ],
                                    );
                                  } else {
                                    return const Text('Empty data');
                                  }
                                } else {
                                  return Text(
                                      'State: ${snapshot.connectionState}');
                                }
                              },
                            ),
                            Text(FirebaseAuth.instance.currentUser!.email!),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GFButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.members);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.group,
                                    // color: Colors.blue,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 21,
                                  ),
                                  Text(
                                    'Members',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            // textColor: Colors.white,
                            shape: GFButtonShape.square,
                            type: GFButtonType.transparent,
                            size: 60,
                            splashColor: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GFButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.invite);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Icon(
                                    Icons.mail,
                                    // color: Colors.blue,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 21,
                                  ),
                                  Text(
                                    'Invite',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            // textColor: Colors.white,
                            shape: GFButtonShape.square,
                            type: GFButtonType.transparent,
                            size: 60,
                            splashColor: Colors.lightBlue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GFButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.developers);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.info,
                                    // color: Colors.blue,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 21,
                                  ),
                                  Text(
                                    'Developers',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            // textColor: Colors.white,
                            shape: GFButtonShape.square,
                            type: GFButtonType.transparent,
                            size: 60,
                            splashColor: Colors.lightBlue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GFButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.about);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.account_balance,
                                    // color: Colors.blue,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 21,
                                  ),
                                  Text(
                                    'About URS',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            // textColor: Colors.white,
                            shape: GFButtonShape.square,
                            type: GFButtonType.transparent,
                            size: 60,
                            splashColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GFButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.settings);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.settings,
                                    // color: Colors.blue,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 21,
                                  ),
                                  Text(
                                    'Settings',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            // textColor: Colors.white,
                            shape: GFButtonShape.square,
                            type: GFButtonType.transparent,
                            size: 60,
                            splashColor: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GFButton(
                            onPressed: () {
                              // Navigator.of(context).pushNamed(Routes.about);
                              context.read<AuthService>().signOut();
                              context.read<LoginProvider>().resetState();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.logout,
                                    // color: Colors.blue,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 21,
                                  ),
                                  Text(
                                    'Logout',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            // textColor: Colors.white,
                            shape: GFButtonShape.square,
                            fullWidthButton: false,
                            type: GFButtonType.transparent,
                            size: 60,
                            splashColor: Colors.blueAccent,
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
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: const Text('UsApp'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.profile);
              },
              icon: const Icon(Icons.account_circle))
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.markunread),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Threads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTap,
      ),
    );
  }
}
