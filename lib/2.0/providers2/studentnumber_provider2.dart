import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/models/student.dart';

class StudentNumberProvider2 with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();
  late String _studentNumber = '';
  late bool _verifiedStudentNumber = false;
  //
  late String _studentEmail;
  late bool _verifiedStudentEmail = false;

  //get
  String get studentNumber => _studentNumber;
  bool get verifiedStudentNumber => _verifiedStudentNumber;
  Stream<List<StudentNumber>> get members => firestoreService2.fetchMembers();
  //
  String get studentEmail => _studentEmail;
  bool get verifiedStudentEmail => _verifiedStudentEmail;

  //set
  set changeStudentNumber(String studentnumber) {
    _studentNumber = studentnumber;
  }

  //
  set changeStudentEmail(String studentemail) {
    _studentEmail = studentemail;
  }

  //functions
  verifyStudentNumber() async {
    if (_studentNumber != '') {
      var res = await firestoreService2.verify(studnum: _studentNumber);
      _verifiedStudentNumber = res;
      notifyListeners();
    }
  }

  //email verification
  verifyStudentEmail() async {
    if (_studentEmail != null) {
      var res = await firestoreService2.verifyEmail(
          studnum: _studentNumber, email: _studentEmail);
      _verifiedStudentEmail = res;
      notifyListeners();
    }
  }

  //get members list
  List<StudentNumber> _memberList = <StudentNumber>[];
  Future<List<StudentNumber>> fetchData() async {
    _memberList = await firestoreService2.waitMembers();
    notifyListeners();
    return firestoreService2.waitMembers();
  }

  //update yearlevel
  updateYearLevel() async {
    SharedPreferences localPrefs = await SharedPreferences.getInstance();
    //localstud-<info needed>
    String studID = localPrefs.getString('localstud-studentNum')!;
    await firestoreService2.updateYearLevel(studID);
    notifyListeners();
  }

  //change update status
  updateLocalUpdatedStatusAYEND() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is-updated', false);
    await prefs.reload();
    notifyListeners();
  }

  updateLocalUpdatedStatusAYSTART() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is-updated', true);
    await prefs.reload();
    notifyListeners();
  }
}
