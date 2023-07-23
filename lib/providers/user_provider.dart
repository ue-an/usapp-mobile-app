import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usapp_mobile/models/account.dart' as model;

import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('users');
  // Future<void> saveUser(model.User user) async {
  //   return await _ref.doc(user.email).set(user.toMap());
  // }

  // Future<model.User> getUserDetails() async {
  //   final curEmail = FirebaseAuth.instance.currentUser!.email;
  //   final snapshot1 = await _ref.doc(curEmail).get();

  //   if (snapshot1.exists) {
  //     return model.User(
  //       studNum: snapshot1['stud_number'],
  //       fullname: snapshot1['fullname'],
  //       email: snapshot1['email'],
  //       course: snapshot1['course'],
  //       college: snapshot1['college'],
  //     );
  //   }
  //   return model.User(
  //     studNum: '',
  //     fullname: '',
  //     email: '',
  //     course: '',
  //     college: '',
  //   );
  // }

  // Stream<List<model.User>> getUser() {
  //   final curEmail = FirebaseAuth.instance.currentUser!.email;
  //   return FirebaseFirestore.instance.collection('users').snapshots().map(
  //       (snapshot) => snapshot.docs
  //           .map((doc) => model.User.fromJson(doc.data()))
  //           .toList());
  // }
}
