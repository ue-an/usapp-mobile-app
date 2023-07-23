import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataProvider2 with ChangeNotifier {
  String? _fname;
  String? get fname => _fname;
  //Student User Details
  storeLocalFullname(String fname, String lname) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setString(
        'localstud-fullname', fname + ' ' + lname);
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalLastName(String lname) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setString('localstud-lastname', lname);
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalFirstName(String fname) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setString('localstud-firstname', fname);
    _fname = fname;
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalMinitial(String mInitial) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setString('localstud-minitial', mInitial);
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalCourse(String course) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setString('localstud-course', course);
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalCollege(String college) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setString('localstud-college', college);
    // await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalYearLevel(int yearLevel) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setInt('localstud-yearlevel', yearLevel);
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalSection(int section) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setInt('localstud-section', section);
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalEmail(String email) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setString('localstud-email', email);
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalStudentNumber(String studentNum) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setString('localstud-studentNum', studentNum);
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalStudentPhoto(String studentPhoto) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setString('localstud-photo', studentPhoto);
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  storeLocalStudentAbout(String studentAbout) async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.setString('localstud-about', studentAbout);
    await studentDetailsPrefs.reload();
    notifyListeners();
  }

  //Threads Details
  storeThrTitle(String thrTitle) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('localstud-thrTitle', thrTitle);
    // prefs.reload();
    notifyListeners();
  }

  storeThrID(String thrID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('localstud-thrID', thrID);
    notifyListeners();
  }

  storeThrCreator(String thrCreator) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('localstud-thrCreator', thrCreator);
    notifyListeners();
  }

  //Direct Messages
  storeDmID(String dmID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('localstud-dmID', dmID);
    notifyListeners();
  }

  //Direct Messages Content
  storeDmContentID(String dmContentID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('localstud-dmContentID', dmContentID);
    notifyListeners();
  }

  //DEVICE TOKEN
  storeDeviceToken(String deviceToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('device-token', deviceToken);
    notifyListeners();
  }

  //COURSE COMPLETION YEARS
  storeCourseCompletionYear(int completeYear) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('completion-year', completeYear);
    notifyListeners();
  }

  //UPDATED STATUS
  storeUpdatedStatus(bool updatedStatus) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is-updated', updatedStatus);
    notifyListeners();
  }

  //ACCOUNT STATUS
  storeUpdatedAcctStatus(bool updatedAcctStatus) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is-enabled', updatedAcctStatus);
    notifyListeners();
  }

  //getters
  //Student User Details

  Future<String?> getLocalFullName() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-fullname');
  }

  Future<String?> getLocalLastName() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-lastname');
  }

  Future<String?> getLocalFirstName() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-firstname');
  }

  Future<String?> getLocalMinitial() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-minitial');
  }

  Future<String?> getLocalStudentNumber() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-studentNum');
  }

  Future<String?> getLocalCollege() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    // await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-college');
  }

  Future<String?> getLocalCourse() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-course');
  }

  Future<int?> getLocalYearLevel() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getInt('localstud-yearlevel');
  }

  Future<int?> getLocalSection() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getInt('localstud-section');
  }

  Future<String?> getLocalEmail() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-email');
  }

  //
  Future<String?> getLocalThrID() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-thrID');
  }

  Future<String?> getLocalThrTitle() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-thrTitle');
  }

  Future<String?> getLocalThrCreator() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-thrCreator');
  }

  Future<String?> getLocalStudentPhoto() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-photo');
  }

  Future<String?> getLocalAbout() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-about');
  }

  //Direct Messages
  Future<String?> getLocalDmID() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-dmID');
  }

  //Direct Message Content
  Future<String?> getLocalDmContentID() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    notifyListeners();
    return studentDetailsPrefs.getString('localstud-dmContentID');
  }

  //DEVICE TOKEN
  Future<String?> getDeviceToken() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    notifyListeners();
    return studentDetailsPrefs.getString('device-token');
  }

  //COURSE COMPLETION YEARS
  Future<int> getLocalCompletionYear() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getInt('completion-year')!;
  }

  //UPDATED STATUS
  Future<bool> getLocalUpdatedStatus() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getBool('is-updated')!;
  }

  //GET USERSTATUS
  Future<String> getLocalUserStatus() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getString('userstatus')!;
  }

  //GET ACCOUNT STATUS
  Future<bool> getLocalAcctStatus() async {
    SharedPreferences studentDetailsPrefs =
        await SharedPreferences.getInstance();
    await studentDetailsPrefs.reload();
    notifyListeners();
    return studentDetailsPrefs.getBool('is-enabled')!;
  }
}
