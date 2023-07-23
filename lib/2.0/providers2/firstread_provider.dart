import 'package:flutter/cupertino.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/models/student.dart';

class FirstReadProvider with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();
  String? _studentNumber = '';
  StudentNumber? _firstStudent = StudentNumber(
    studentNumber: '',
    lastName: '',
    firstName: '',
    mInitial: '',
    college: '',
    course: '',
    email: '',
    isused: false,
    yearLvl: 0,
    section: 0,
    photoUrl: '',
    about: '',
    deviceToken: '',
    isEnabled: false,
  );
  //
  set changeStudentNum(String studentNumber) {
    _studentNumber = studentNumber;
    notifyListeners();
  }

  set changeFirstStudent(StudentNumber firstStudent) {
    _firstStudent = firstStudent;
    notifyListeners();
  }

  //
  String? get studentNumber => _studentNumber;
  Stream<StudentNumber> get firstStreamStudent =>
      firestoreService2.getFirstCurrentStudentUrl(_studentNumber!);
  StudentNumber get firstStudent => _firstStudent!;
}
