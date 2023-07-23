import 'package:usapp_mobile/models/account.dart';
import 'package:usapp_mobile/providers/user_provider.dart';

class UserService {
  final UserProvider _userProvider;

  UserService(this._userProvider);

  // void createUser(
  //   String studnum,
  //   String fullname,
  //   String email,
  //   String username,
  //   String course,
  //   String college,
  // ) async {
  //   await _userProvider.saveUser(
  //     User(
  //       email: email,
  //       studNum: studnum,
  //       fullname: fullname,
  //       course: course,
  //       college: college,
  //     ),
  //   );
  // }

  String _createUsername(String username, String email) {
    var defUsername = email.split('@')[0];
    if (username.length <= 7) {
      return defUsername;
    }
    return username;
  }
}
