enum AuthStatus { loading, error, authed, unuathed, verified, unverified }

class AuthState {
  final AuthStatus authStatus;
  final String authError;
  AuthState(this.authStatus, this.authError);
}
