import 'package:restart_app/restart_app.dart';
import 'package:usapp_mobile/services/authentication/user_service.dart';
import 'package:usapp_mobile/services/authentication/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService;
  // final CollectionReference _ref =
  //     FirebaseFirestore.instance.collection('users');

  AuthService(this._firebaseAuth, this._userService);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<AuthState> logIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthState(AuthStatus.authed, "");
    } on FirebaseAuthException catch (e) {
      return AuthState(AuthStatus.error, e.message.toString());
    }
  }

  Future<AuthState> signUp({
    required String studnum,
    required String fullname,
    required String email,
    required String username,
    required String password,
    required String course,
    required String college,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // _userService.createUser(
      //   studnum,
      //   fullname,
      //   email,
      //   username,
      //   course,
      //   college,
      // );
      // FlutterRestart.restartApp();
      // Restart.restartApp(webOrigin: 'MyApp');
      return AuthState(AuthStatus.authed, "");
    } on FirebaseAuthException catch (e) {
      return AuthState(AuthStatus.error, e.message.toString());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
