import 'package:flutter/material.dart';

class DevelopersScreen extends StatelessWidget {
  const DevelopersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UsApp Developers"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image.asset('assets/images/technocratslogo_04.1.png'),
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width - 10,
            child: Column(
              children: [
                const SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Techno",
                      style: TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "crats",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("Ian Aguinaldo"),
                const Text("Daryn Binaluyo"),
                const Text("Alaiza Gondraneos"),
                const Text("Jenyl Maningcay"),
                const Text("Marco Merjudio"),
                const SizedBox(
                  height: 30,
                ),
                const Text("since 2021"),
              ],
            ),
          ),
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(15.0),
      //   child: Column(
      //     children: [
      //       Expanded(
      //         child: Container(
      //             child: Image.asset('assets/images/technocratslogo_03png')),
      //       ),
      //       Container(
      //         height: MediaQuery.of(context).size.height / 2,
      //         width: MediaQuery.of(context).size.width - 30,
      //         child: Column(
      //           children: [
      //             Text("Technocrats"),
      //             Text("since 2021"),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
