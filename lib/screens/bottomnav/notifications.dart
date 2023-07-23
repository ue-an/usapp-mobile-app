import 'package:flutter/material.dart';
import 'package:usapp_mobile/utils/routes.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notfications',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                for (var i = 0; i < 6; i++)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.threads);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                SizedBox(
                                  width: 9,
                                ),
                                // Text(
                                //   'Uncle Sam Smith' + i.toString(),
                                //   style: const TextStyle(
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.w400),
                                // ),
                                Text(
                                  'Someone answered to your thread',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            Divider(),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
