import 'package:flutter/material.dart';

class EmptyBlock extends StatelessWidget {
  const EmptyBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        top: size.height / 10,
      ),
      // padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: size.width - 45,
            height: 200,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            width: size.width - 45,
            height: 200,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            width: size.width - 45,
            height: 190,
          ),
        ],
      ),
      // child: Row(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Container(
      //       width: 54,
      //       height: 46,
      //       color: Colors.white,
      //     ),
      //     const SizedBox(width: 12),
      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Container(
      //             width: double.infinity,
      //             height: 8,
      //             color: Colors.white,
      //           ),
      //           const SizedBox(height: 6),
      //           Container(
      //             width: MediaQuery.of(context).size.width * 0.5,
      //             height: 8,
      //             color: Colors.white,
      //           ),
      //           const SizedBox(height: 6),
      //           Container(
      //             width: MediaQuery.of(context).size.width * 0.25,
      //             height: 8,
      //             color: Colors.white,
      //           ),
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
