import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/src/provider.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/screens2/directmessages_screen2.dart';

class ViewProfileScreen2 extends StatefulWidget {
  String userEmail;
  String userName;
  String userSection;
  String userPhoto;
  String userAbout;
  String userCollege;
  ViewProfileScreen2({
    Key? key,
    required this.userEmail,
    required this.userName,
    required this.userSection,
    required this.userPhoto,
    required this.userCollege,
    required this.userAbout,
  }) : super(key: key);

  @override
  State<ViewProfileScreen2> createState() => _ViewProfileScreen2State();
}

class _ViewProfileScreen2State extends State<ViewProfileScreen2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 180,
            ),
            Center(
              child: Container(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(60)),
                  child: Image.network(
                    widget.userPhoto,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: Text(
                widget.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Center(
              child: Text(
                widget.userSection,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Text(
                widget.userCollege,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Divider(
              indent: size.width / 4,
              endIndent: size.width / 4,
              thickness: 2,
              color: Colors.white,
            ),
            const SizedBox(
              height: 21,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width / 12),
              child: Center(
                child: Text(
                  widget.userAbout,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 6,
            ),
          ],
        ),
      ),
    );
  }
}
