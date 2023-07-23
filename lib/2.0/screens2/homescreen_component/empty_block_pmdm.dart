import 'package:flutter/material.dart';

class EmptyBlockPmDm extends StatelessWidget {
  const EmptyBlockPmDm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        top: size.height / 60,
      ),
      // padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: size.width - 45,
            height: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            width: size.width - 45,
            height: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            width: size.width - 45,
            height: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            width: size.width - 45,
            height: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            width: size.width - 45,
            height: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            width: size.width - 45,
            height: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            width: size.width - 45,
            height: 80,
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Container(
          //   color: Colors.white,
          //   width: size.width - 45,
          //   height: 80,
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Container(
          //   color: Colors.white,
          //   width: size.width - 45,
          //   height: 80,
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Container(
          //   color: Colors.white,
          //   width: size.width - 45,
          //   height: 80,
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}
