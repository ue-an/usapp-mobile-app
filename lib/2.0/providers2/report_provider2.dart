import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/models/report.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';

class ReportProvider with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //to report collection
  bool _isApproved = false;
  String? _reason;
  String? _reporter;
  String? _thrCreatorID;
  String? _thrCreatorName;
  String? _threadID;
  String? _threadTitle;
  int _reportCount = 0;

  //getter
  bool get isApproved => _isApproved;
  String? get reason => _reason;
  String? get reporter => _reporter;
  String? get thrCreatorID => _thrCreatorID;
  String? get thrCreatorName => _thrCreatorName;
  String? get threadID => _threadID;
  String? get threadTitle => _threadTitle;
  int get reportCount => _reportCount;

  //set
  set changeIsApproved(bool isApproved) {
    _isApproved = isApproved;
  }

  set changeReason(String reason) {
    _reason = reason;
  }

  set changeReporter(String reporter) {
    _reporter = reporter;
    notifyListeners();
  }

  set changeThrCreatorID(String thrCreatorID) {
    _thrCreatorID = thrCreatorID;
    notifyListeners();
  }

  set changeThrCreatorName(String thrCreatorName) {
    _thrCreatorName = thrCreatorName;
    notifyListeners();
  }

  set changeThreadID(String threadID) {
    _threadID = threadID;
    notifyListeners();
  }

  set changeThreadTitle(String threadTitle) {
    _threadTitle = threadTitle;
    notifyListeners();
  }

  set changeReportCount(int reportCount) {
    _reportCount = reportCount;
    notifyListeners();
  }

  //functions
  saveReport() async {
    if (_reason != null) {
      DateTime now = DateTime.now();
      var date = Timestamp.fromDate(now);
      SharedPreferences localPrefs = await SharedPreferences.getInstance();
      String reporterName = localPrefs.getString('localstud-fullname')!;
      var updateReport = Report(
        isAppoved: _isApproved,
        reasons: [reason],
        reportDate: date,
        reporters: [reporterName],
        thrCreatorID: _thrCreatorID!,
        thrCreatorName: _thrCreatorName!,
        thrID: _threadID!,
        thrTitle: _threadTitle!,
        reportCount: _reportCount,
      );
      firestoreService2.setReport(updateReport, _threadID!);
      notifyListeners();
    }
  }

  addReportFields() async {
    SharedPreferences localPrefs = await SharedPreferences.getInstance();
    String reporterName = localPrefs.getString('localstud-fullname')!;
    var res = await firestoreService2.updateReportFields(
        _threadID!, reporterName, _reason);
    _isClicked = res;
    notifyListeners();
  }

  //change thread properties
  bool _isClicked = false;

  //getters
  bool get isClicked => _isClicked;
  //setter
  set changeIsClicked(bool isClicked) {
    _isClicked = isClicked;
  }

  //functions
  clickNow() async {
    SharedPreferences localPrefs = await SharedPreferences.getInstance();
    String curEmail = localPrefs.getString('localstud-email')!;
    var res =
        await firestoreService2.updateThrReportClicked(_threadID!, curEmail);
    _isClicked = res;
    notifyListeners();
  }
}
