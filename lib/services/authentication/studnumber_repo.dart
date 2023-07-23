import 'package:usapp_mobile/services/authentication/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usapp_mobile/models/student.dart' as model;

class StudnumberRepo {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('student_numbers');

  Future<AuthState> verify(String studnum) async {
    final snapshot1 = await _ref.doc(studnum).get();

    if (snapshot1.exists) {
      if (!(snapshot1.data()!['is_used'] as bool)) {
        return AuthState(AuthStatus.verified, '');
      } else {
        return AuthState(AuthStatus.error, 'Student number already taken');
      }
    } else {
      return AuthState(AuthStatus.unverified, 'Student number doesn\'t exist');
    }
  }

  Future<bool> compareStudReg(String studnum) async {
    final snapshot1 = await _ref.where('idNumber', isEqualTo: studnum).get();

    if (snapshot1.size != 0) {
      return true;
    }
    return false;
  }

  // Future<model.StudentNumber> displayStudname(String studnum) async {
  //   final snapshot1 = await _ref.where('idNumber', isEqualTo: studnum).get();

  //   if (snapshot1.size != 0) {
  //     final doc1 = snapshot1.docs[0];
  //     return model.StudentNumber(
  //       studNum: doc1['idNumber'],
  //       fullname: doc1['name'],
  //     );
  //   }
  //   return model.StudentNumber(
  //     studNum: '',
  //     fullname: '',
  //   );
  // }
}
