import 'package:flutter/material.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UsApp App'),
      ),
      body: const Center(
        child: Text('Invite'),
      ),
    );
  }
}
