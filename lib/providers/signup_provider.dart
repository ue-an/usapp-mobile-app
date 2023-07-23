import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usapp_mobile/services/authentication/auth_service.dart';
import 'package:usapp_mobile/services/authentication/auth_state.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  final AuthService _authService;

  SignupProvider({required AuthService authService})
      : _authService = authService;
  //for first-level

  String _email = '';
  String _password = '';
  String _confirmedPassword = '';
  String _username = '';
  //
  String _fullname = '';
  String _studnum = '';
  String _course = '';
  String _college = '';
  dynamic _state = AuthState(AuthStatus.unuathed, "");

  AuthState get state => _state;

  void resetState() {
    _state = AuthState(AuthStatus.unuathed, "");
  }

  //first-level authentication

  String get studnum => _studnum;
  String get fullname => _fullname;

  //functions
  // String? validateStudNum(String studnum) {
  //   _studnum = studnum;
  //   if (studnum == _ref.where('idNumber', isEqualTo: studnum.toString())) {
  //     return studnum;
  //   }
  // }

  //second-level
  String get college => _college;
  String get course => _course;
  String get email => _email;
  String get password => _password;
  String get confirmedPassword => _confirmedPassword;
  String get username => _username;

  //functions
  String validateStudnumber(String studnum) {
    _studnum = studnum;
    return '';
  }

  String validateFullname(String fullname) {
    _fullname = fullname;
    return '';
  }

  String validateCollege(String college) {
    _college = college;
    return '';
  }

  String validateCourse(String course) {
    _course = course;
    return '';
  }

  String validateUsername(String username) {
    _username = username;
    if (username.length <= 21) {
      if (username.toLowerCase() == 'administrator' ||
          username.toLowerCase() == 'admin' ||
          username.toLowerCase() == 'moderator') {
        return 'invalid username';
      } else {
        return '';
      }
    } else {
      return 'Username is too long';
    }
  }

  String validateEmail(String email) {
    _email = email;
    if (EmailValidator.validate(email)) {
      return '';
    }

    return "Please enter a valid email.";
  }

  String validatePassword(String password) {
    _password = password;
    if (password.length > 5) {
      return '';
    }
    return "Password must be at least 6 characters long.";
  }

  String validatePasswordMatch(String confirmedPassword) {
    _confirmedPassword = confirmedPassword;
    if (_password == confirmedPassword) {
      return '';
    }
    return "Passwords must match.";
  }

  void registerUser() async {
    if (!EmailValidator.validate(email)) {
      _state = AuthState(AuthStatus.error, "Please enter a valid email.");
      notifyListeners();
      return;
    }

    if (password != confirmedPassword) {
      _state = AuthState(AuthStatus.error, "Passwords need to match.");
      notifyListeners();
      return;
    }

    _state = AuthState(AuthStatus.loading, "");
    notifyListeners();

    _state = await _authService.signUp(
      username: _username,
      email: _email,
      password: _password,
      studnum: _studnum,
      fullname: _fullname,
      course: _course,
      college: _college,
    );
    final _ref = FirebaseFirestore.instance;
    await _ref
        .collection('student_numbers')
        .doc(studnum)
        .update({'is_used': true});
  }
}
