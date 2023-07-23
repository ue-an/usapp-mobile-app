import 'package:flutter/material.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: const Center(
        child: Text('Members'),
      ),
    );
    //   body: Column(
    //                 children: [
    //                   FutureBuilder(
    //                     future: context
    //                         .watch<StudentnumberProvider>()
    //                         .showStudnum(),
    //                     builder: (BuildContext context,
    //                         AsyncSnapshot<String> snapshot) {
    //                       if (snapshot.connectionState ==
    //                           ConnectionState.waiting) {
    //                         return const CircularProgressIndicator();
    //                       } else if (snapshot.connectionState ==
    //                           ConnectionState.done) {
    //                         if (snapshot.hasError) {
    //                           return const Text('Error');
    //                         } else if (snapshot.hasData) {
    //                           _studnumCtrl.text = snapshot.data!;
    //                           context
    //                               .read<SignupProvider>()
    //                               .validateStudnumber(_studnumCtrl.text);

    //                           return Row(
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             children: [
    //                               const Text(
    //                                 'Student Number:',
    //                                 style: TextStyle(
    //                                   color: Colors.white,
    //                                 ),
    //                               ),
    //                               const SizedBox(
    //                                 width: 6,
    //                               ),
    //                               Text(snapshot.data!.toUpperCase(),
    //                                   style: const TextStyle(
    //                                       fontWeight: FontWeight.w500,
    //                                       // color: Colors.blue,
    //                                       color: Colors.white,
    //                                       fontSize: 16)),
    //                             ],
    //                           );
    //                         } else {
    //                           return const Text('Empty data');
    //                         }
    //                       } else {
    //                         return Text('State: ${snapshot.connectionState}');
    //                       }
    //                     },
    //                   ),
    //                   const SizedBox(
    //                     height: 9,
    //                   ),
    //                   FutureBuilder(
    //                     future: context
    //                         .watch<StudentnumberProvider>()
    //                         .showStudname(),
    //                     builder: (BuildContext context,
    //                         AsyncSnapshot<String> snapshot) {
    //                       if (snapshot.connectionState ==
    //                           ConnectionState.waiting) {
    //                         return const CircularProgressIndicator();
    //                       } else if (snapshot.connectionState ==
    //                           ConnectionState.done) {
    //                         if (snapshot.hasError) {
    //                           return const Text('Error');
    //                         } else if (snapshot.hasData) {
    //                           _fullnameCtrl.text = snapshot.data!;
    //                           context
    //                               .read<SignupProvider>()
    //                               .validateFullname(_fullnameCtrl.text);

    //                           return Row(
    //                             children: [
    //                               const Text(
    //                                 'Welcome',
    //                                 style: TextStyle(
    //                                   color: Colors.white,
    //                                 ),
    //                               ),
    //                               const SizedBox(
    //                                 width: 3,
    //                               ),
    //                               Text(snapshot.data!.toUpperCase() + '!',
    //                                   style: const TextStyle(
    //                                       fontWeight: FontWeight.w500,
    //                                       // color: Colors.blue,
    //                                       color: Colors.white,
    //                                       fontSize: 16)),
    //                             ],
    //                           );
    //                         } else {
    //                           return const Text('Empty data');
    //                         }
    //                       } else {
    //                         return Text('State: ${snapshot.connectionState}');
    //                       }
    //                     },
    //                   ),
    //                 ],
    //               ),
    // );
  }
}
