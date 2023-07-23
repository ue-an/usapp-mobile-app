import 'package:flutter/material.dart';

class EmptyBlockMembers extends StatelessWidget {
  const EmptyBlockMembers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          color: Colors.white,
          width: size.width - 45,
          height: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          width: size.width - 45,
          height: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          width: size.width - 45,
          height: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          width: size.width - 45,
          height: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          width: size.width - 45,
          height: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          width: size.width - 45,
          height: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          width: size.width - 45,
          height: 80,
        ),
      ],
    );
  }
}
