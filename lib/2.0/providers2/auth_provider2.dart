import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';

class AuthProvider2 with ChangeNotifier {
  final firestoreService = FirestoreService2();
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  bool _isVerifiedAcct = false;
  bool _isEnabled = true;
  //change password
  String _oldPassword = '';
  late String _newPassword = '';
  late String _reNewPass = '';
  bool _isPasswordChanged = false;
  bool _isError = false;
  bool _oldPassCorrect = false;
  //reset password
  late String _resetNewPassword = '';
  late String _reResetNewPass = '';
  late String _resetEmail = '';
  bool _isPasswordReset = false;

  //get
  String get email => _email;
  String get password => _password;
  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();
  bool get isVerifiedAcct => _isVerifiedAcct;
  bool get isEnabled => _isEnabled;
  //change pass
  String get newPassword => _newPassword;
  String get reNewPass => _reNewPass;
  String get oldPassword => _oldPassword;
  bool get isPasswordChanged => _isPasswordChanged;
  bool get oldPassCorrect => _oldPassCorrect;
  //reset pass
  String get resetNewPass => _resetNewPassword;
  String get reResetNewPass => _reResetNewPass;
  String get resetEmail => _resetEmail;
  bool get isPasswordReset => _isPasswordReset;

  //set
  set email(String email) {
    _email = email;
    notifyListeners();
  }

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  set oldPassword(String oldPassword) {
    _oldPassword = oldPassword;
    notifyListeners();
  }

  set newPassword(String newPassword) {
    _newPassword = newPassword;
    notifyListeners();
  }

  set reNewPass(String reNewPass) {
    _reNewPass = reNewPass;
    notifyListeners();
  }

  set changeIsPassChanged(bool isPassChanged) {
    _isPasswordChanged = isPassChanged;
    notifyListeners();
  }

  set changeResetEmail(String resetEmail) {
    _resetEmail = resetEmail;
    notifyListeners();
  }

  set changeIsPassReset(bool isPassReset) {
    _isPasswordReset = isPassReset;
    notifyListeners();
  }

  //functions
  logInAccount() async {
    if ((_email != null || _email != '') &&
        (_password != null && _password != '')) {
      var res =
          await firestoreService.logIn(email: _email, password: _password);
      _isVerifiedAcct = res;
      print('object');
      notifyListeners();
    }
  }

  signOutAccount() async {
    await firestoreService.signOut();
    _email = '';
    _password = '';
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('userstatus');
    notifyListeners();
  }

  checkUserEnabled() async {
    if ((_email != null || _email != '') &&
        (_password != null || _password != '')) {
      var res = await firestoreService.getUserAccountEnable(_email);
      _isEnabled = res;
      notifyListeners();
    } else {
      _isEnabled = false;
      notifyListeners();
    }
  }

  validateOldPassword() async {
    User user = FirebaseAuth.instance.currentUser!;
    String email = user.email!;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _oldPassword,
      );
      _oldPassCorrect = true;

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      print('wrong wrong');
      notifyListeners();
    }
    notifyListeners();
  }

  changePassword() async {
    User user = FirebaseAuth.instance.currentUser!;
    String email = user.email!;

    //Create field for user to input old password

    //pass the password here
    String password = _oldPassword;
    String newPassword = _newPassword;
    String reNewPass = _reNewPass;

    if (newPassword == reNewPass) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        user.updatePassword(newPassword).then((_) {
          print("Successfully changed password");
          _isPasswordChanged = true;
          changeIsPassChanged = true;
        }).catchError((error) {
          print("Password can't be changed" + error.toString());
          _isPasswordChanged = false;
          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          _isError = true;
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          _isError = true;
        } else if (e.code == 'wrong-password') {
          //when account di faabkes
        }
      }
    }
  }

  resetPassword() async {
    if (_resetNewPassword == _reResetNewPass) {
      try {
        _auth.sendPasswordResetEmail(email: _resetEmail);
        _isPasswordReset = true;
        changeIsPassReset = true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          _isError = true;
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          _isError = true;
        }
      }
    }
  }
}
