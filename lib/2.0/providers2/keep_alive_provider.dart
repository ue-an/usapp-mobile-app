import 'package:flutter/cupertino.dart';

class KeepAliveProvider2 with ChangeNotifier {
  bool _isDrawerAlive = false;
  bool _isProfileAlive = false;
  bool _isMembersAlive = false;
  bool _isDmpmAlive = false;
  bool _isDmPmScreenAlive = false;

  set isDrawerAlive(bool isDrawerAlive) {
    _isDrawerAlive = isDrawerAlive;
    // notifyListeners();
  }

  set isProfileAlive(bool isProfileAlive) {
    _isProfileAlive = isProfileAlive;
  }

  set isMembersAlive(bool isMembersAlive) {
    _isMembersAlive = isMembersAlive;
  }

  set isDmpmAlive(bool isDmpmAlive) {
    _isDmpmAlive = isDmpmAlive;
  }

  set isDmPmScreenAlive(bool isDmPmScreenAlive) {
    _isDmPmScreenAlive = isDmPmScreenAlive;
  }

  bool get isDrawerAlive => _isDrawerAlive;
  bool get isProfileAlive => _isProfileAlive;
  bool get isMembersAlive => _isMembersAlive;
  bool get isDmpmAlive => _isDmpmAlive;
  bool get isDmPmScreenAlive => _isDmPmScreenAlive;
}
