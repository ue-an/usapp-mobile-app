import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/models/account.dart';

class OtpProvider2 with ChangeNotifier {
  final _firestoreService = FirestoreService2();
  bool _submitValid = false;
  bool _isVerified = false;
  late String _email = '';
  late String _password = '';
  late String _repass = '';
  late String _studentNumber;
  late String _otpCtrl = '';
  late String _description = 'Add description or about you..';
  //account creation
  bool _acctSaved = false;
  bool _acctAddedToCollection = false;
  bool _studentNumberIsUsed = false;
  bool _resetAcctSaved = false;
  bool _isPhotoSetFirstTime = false;

  //get
  bool get submitValid => _submitValid;
  bool get isVerified => _isVerified;
  String get email => _email;
  String get password => _password;
  String get repass => _repass;
  String get studentNumber => _studentNumber;
  String get otpCtrl => _otpCtrl;
  String get description => _description;
  //acct creation getters
  bool get acctSaved => _acctSaved;
  bool get acctAddedToCollection => _acctAddedToCollection;
  bool get resetAcctSaved => _resetAcctSaved;
  bool get isPhotoSetFirstTime => _isPhotoSetFirstTime;

  //set
  set changeSubmitValid(bool submitValid) {
    _submitValid = submitValid;
    notifyListeners();
  }

  set changeIsVerified(bool isVerified) {
    _isVerified = isVerified;
    notifyListeners();
  }

  set changeEmail(String email) {
    _email = email;
    notifyListeners();
  }

  set changePassword(String password) {
    _password = password;
    notifyListeners();
  }

  set changeRepass(String repass) {
    _repass = repass;
    notifyListeners();
  }

  set changeStudentNumber(String studentNumber) {
    _studentNumber = studentNumber;
    notifyListeners();
  }

  set changeOTP(String otpCtrl) {
    _otpCtrl = otpCtrl;
    notifyListeners();
  }

  set changeDescription(String description) {
    _description = description;
    notifyListeners();
  }

  //functions
  //set photoUrl in firebase collection(students) first time
  setPhotoUrlFirstTime(String photoUrl) async {
    var res = await _firestoreService.updatePhotoUrlFirstTime(
        _studentNumber, photoUrl);
    _isPhotoSetFirstTime = res;
    notifyListeners();
    return res;
  }

  //set about/description first time
  setAboutFirstTime() async {
    await _firestoreService.updateAboutFirstTime(studentNumber, description);
    notifyListeners();
  }

  //edit/update about from profile
  setAboutFromProfile(String studentNumber) async {
    await _firestoreService.updateAboutFromProfile(studentNumber, description);
    notifyListeners();
  }

  //use student number to create account
  useStudentNumber() async {
    var res = await _firestoreService.useNow(studnum: _studentNumber);
    _studentNumberIsUsed = res;
    print('use studnum');
    notifyListeners();
  }

  //to firebase authentication
  saveAccount() async {
    if (_email != null &&
        _password != null &&
        _repass != null &&
        _studentNumber != null) {
      var res = await _firestoreService.registerWithEmailPassword(
          email: _email, password: _password);
      _acctSaved = res;
      notifyListeners();
    }
  }

  //to my collection "accounts"
  accountToCollection() async {
    var account = Account(
        studNum: _studentNumber, email: _email, created: DateTime.now());
    print(account.studNum);
    print(account.email);
    print(account.created);
    var res = await _firestoreService.setAccount(account);
    _acctAddedToCollection = res;
    notifyListeners();
  }

  //OTP functions
  late EmailAuth _emailAuth = EmailAuth(
      sessionName: "UsApp: URS Messaging and Forum App Student Account");
  set changeEmailAuth(EmailAuth emailAuth) {
    _emailAuth = emailAuth;
    notifyListeners();
  }

  sendOTP(String emailID) async {
    bool res = await _emailAuth.sendOtp(recipientMail: emailID, otpLength: 5);
    if (res == true) {
      print("OTP Sent");
      _submitValid = res;
      _email = emailID;
      print(_email);
      notifyListeners();
      return res;
    } else {
      notifyListeners();
      return false;
    }
  }

  void verifyOTP() {
    bool res = _emailAuth.validateOtp(recipientMail: _email, userOtp: _otpCtrl);
    if (res == true) {
      print("OTP Verified");
      _isVerified = res;
      notifyListeners();
    } else {
      print("OTP Not Verified");
      _isVerified = res = false;
      notifyListeners();
    }
  }
}
