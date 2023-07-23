import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String name;
  String section;
  String photo;
  Timestamp dateJoined;
  String studentNumber;
  String email;
  Account({
    required this.name,
    required this.section,
    required this.dateJoined,
    required this.photo,
    required this.email,
    required this.studentNumber,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json['name'],
      section: json['section'],
      dateJoined: json['created'],
      photo: json['photo'],
      email: json['email'],
      studentNumber: json['student_number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'section': section,
      'created': dateJoined,
      'photo': photo,
      'email': email,
      'student_number': studentNumber,
    };
  }
}
