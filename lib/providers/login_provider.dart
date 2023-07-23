import 'package:firebase_auth/firebase_auth.dart';
import 'package:usapp_mobile/services/authentication/auth_service.dart';
import 'package:usapp_mobile/services/authentication/auth_state.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final AuthService _authService;

  LoginProvider({required AuthService authService})
      : _authService = authService;

  String _email = "";
  String _password = "";
  AuthState _state = AuthState(AuthStatus.unuathed, "");
  // final userProvider = UserProvider();

  AuthState get state {
    return _state;
  }

  // String get email => _email;
  // String get password => _password;

  // Stream<List<User>> get users => userProvider.getUser();

  // String changeEmail(String email) {
  //   _email = email;
  //   return '';
  // }

  // String changePassword(String password) {
  //   _password = password;
  //   return '';
  // }

  set email(String email) {
    _email = email;
  }

  set password(String password) {
    _password = password;
  }

  void resetState() {
    _state = AuthState(AuthStatus.unuathed, "");
  }

  void loginUser() async {
    // final snapshot =
    //     await FirebaseFirestore.instance.collection('users').doc(_email).get();

    // if (snapshot.exists) {
    _state = await _authService.logIn(email: _email, password: _password);
    if (_state.authStatus == AuthStatus.authed) {
      _email = "";
      _password = "";
      notifyListeners();
    }
    // }
    // else {
    //   AuthDialog.show(context, "Email does not exist");
    //   notifyListeners();
    // }

    notifyListeners();
  }
}
