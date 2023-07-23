import 'package:usapp_mobile/services/authentication/auth_state.dart';
import 'package:usapp_mobile/services/authentication/studnumber_repo.dart';
import 'package:usapp_mobile/utils/auth_dialog.dart';
import 'package:usapp_mobile/utils/routes.dart';
import 'package:usapp_mobile/utils/val_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentnumberProvider with ChangeNotifier {
  String _studnum = '';
  final StudnumberRepo _studnumberRepo;
  AuthState _state = AuthState(AuthStatus.loading, '');

  StudentnumberProvider(this._studnumberRepo);

  String get studnum => _studnum;
  AuthState get state => _state;

  set changeStudnum(String studnum) {
    _studnum = studnum;
    notifyListeners();
  }

  validateIdnumber(BuildContext context, String idnumber) async {
    try {
      _state = await _studnumberRepo.verify(idnumber);
      if (_state.authStatus == AuthStatus.verified) {
        if (await _studnumberRepo.compareStudReg(idnumber) == true) {
          Navigator.pushNamed(context, Routes.signup);
        }
      } else {
        // Navigator.pushNamed(context, Routes.signup);
        Future.delayed(Duration.zero, () async {
          ValDialog.show(
              context, context.read<StudentnumberProvider>().state.authError);
        });
      }
      notifyListeners();
    } catch (e) {
      AuthDialog.show(context, "Please provide a Student Number");
    }
  }

  // Future<String> showStudname() async {
  //   final student = await _studnumberRepo.displayStudname(_studnum);
  //   return student.fullname;
  // }

  // Future<String> showStudnum() async {
  //   final student = await _studnumberRepo.displayStudname(_studnum);
  //   return student.studNum;
  // }
}
