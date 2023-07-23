import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/models/request.dart';
import 'package:usapp_mobile/2.0/providers2/localdata_provider2.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';

class RequestProvider2 with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();

  late String _currEmail = '';
  late String _currName = '';
  late String _currFname = '';
  late String _currMinitial = '';
  late String _currLname = '';
  late String _currCollege = '';
  late String _currCourse = '';
  late int _currSection = 0;
  late String _reqCollege = '';
  late String _reqCourse = '';
  late String _reqFname = '';
  late String _reqLname = '';
  late String _reqMinitial = '';
  late int _reqSec = 0;
  late bool _validUpdates = false;

  //getter
  bool get validUpdates => _validUpdates;
  String get reqFname => _reqFname;
  String get reqCollege => _reqCollege;
  String get reqCourse => _reqCourse;
  String get reqMinitial => _reqMinitial;
  String get reqLname => _reqLname;
  int get reqSec => _reqSec;

  //setters
  set changeReqCollege(String reqCollege) {
    _reqCollege = reqCollege;
    notifyListeners();
  }

  set changeReqCourse(String reqCourse) {
    _reqCourse = reqCourse;
    notifyListeners();
  }

  set changeReqFname(String reqFname) {
    _reqFname = reqFname;
    notifyListeners();
  }

  set changeReqLname(String reqLname) {
    _reqLname = reqLname;
    notifyListeners();
  }

  set changeReqMinitial(String reqMinitial) {
    _reqMinitial = reqMinitial;
    notifyListeners();
  }

  set changeReqSec(int reqSec) {
    _reqSec = reqSec;
    notifyListeners();
  }

  saveRequest() async {
    SharedPreferences localPrefs = await SharedPreferences.getInstance();
    _currName = localPrefs.getString('localstud-fullname')!;
    _currEmail = localPrefs.getString('localstud-email')!;
    //
    _currFname = localPrefs.getString('localstud-firstname')!;
    _currMinitial = localPrefs.getString('localstud-minitial')!;
    _currLname = localPrefs.getString('localstud-lastname')!;
    _currCollege = localPrefs.getString('localstud-college')!;
    _currCourse = localPrefs.getString('localstud-course')!;
    _currSection = localPrefs.getInt('localstud-section')!;

    var updatedRequest = Request(
      currCollege: _currCollege,
      currEmail: _currEmail,
      currName: _currName,
      reqFname: _reqFname == _currFname ? '' : _reqFname,
      reqLname: _reqLname == _currLname ? '' : _reqLname,
      reqMinitial: _reqMinitial == _currMinitial ? '' : _reqMinitial,
      reqSec: _reqSec == _currSection ? '' : _reqSec.toString(),
      isAccepted: false,
      isSent: true,
    );
    firestoreService2.setRequest(updatedRequest);
    notifyListeners();
  }
}
