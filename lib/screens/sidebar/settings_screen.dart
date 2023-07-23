import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      // body: const Center(
      //   child: Text('Settings'),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.toggle_off_outlined,
                    size: 30,
                  ),
                  SizedBox(width: 18),
                  Text(
                    'Dark Mode',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Divider(
                height: 30,
                thickness: 2,
              ),
              Row(
                children: [
                  Icon(
                    Icons.perm_identity,
                    size: 30,
                  ),
                  SizedBox(width: 18),
                  Text(
                    'Account Settings',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Divider(
                height: 45,
                thickness: 2,
              ),
              Row(
                children: [
                  Icon(
                    Icons.volume_up,
                    size: 30,
                  ),
                  SizedBox(width: 18),
                  Text(
                    'Sounds',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Divider(
                height: 30,
                thickness: 2,
              ),
              Row(
                children: [
                  SizedBox(width: 80),
                  Text(
                    'Touch Sound',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 82),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('On'),
                          SizedBox(
                            width: 9,
                          ),
                          Text('Off'),
                        ],
                      ),
                      Icon(
                        Icons.toggle_off_outlined,
                        size: 38,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 20,
                thickness: 2,
              ),
              Row(
                children: [
                  SizedBox(width: 80),
                  Text(
                    'Notification Sound',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: w / 12),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('On'),
                          SizedBox(
                            width: 9,
                          ),
                          Text('Off'),
                        ],
                      ),
                      Icon(
                        Icons.toggle_on_outlined,
                        size: 38,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 45,
                thickness: 2,
              ),
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 30,
                  ),
                  SizedBox(width: 18),
                  Text(
                    'Archived Threads',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Divider(
                height: 45,
                thickness: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
