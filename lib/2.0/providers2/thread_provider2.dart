import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/models/thread.dart';
import 'package:uuid/uuid.dart';

class ThreadProvider2 with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var uuid = Uuid();

  String? _threadTitle;
  late String _threadCollege = '';
  late String _threadID = '';
  late String _thrCreatorName = '';
  late String _thrCreatorSection = '';
  late String _description = '';

  //getter
  String? get threadTitle => _threadTitle;
  String? get thrCollege => _threadCollege;
  String? get thrID => _threadID;
  String? get thrCreatorName => _thrCreatorName;
  String? get thrCreatorSection => _thrCreatorSection;
  String? get description => _description;

  Stream<List<Thread>> get threads => firestoreService2.fetchThreads();
  Stream<List<Thread>> get threadss =>
      firestoreService2.fetchThreadss(_threadCollege);
  bool _isReported = false;
  //-------

  //setter
  set changeThreadTitle(String threadTitle) {
    _threadTitle = threadTitle;
    notifyListeners();
  }

  set changeThrCollege(String thrcollege) {
    _threadCollege = thrcollege;
  }

  set changeThrID(String thrID) {
    _threadID = thrID;
    notifyListeners();
  }

  set changeThrCreatorName(String thrCreatorName) {
    _thrCreatorName = thrCreatorName;
    notifyListeners();
  }

  set changeThrCreatorSection(String thrCreatorSection) {
    _thrCreatorSection = thrCreatorSection;
    notifyListeners();
  }

  set changeDescription(String description) {
    _description = description;
    notifyListeners();
  }

  //functions
  saveThread() async {
    if (_threadTitle != null && _threadTitle != '') {
      DateTime now = DateTime.now();
      var date = Timestamp.fromDate(now);
      SharedPreferences localPrefs = await SharedPreferences.getInstance();
      //localstud-<info needed>
      String studID = localPrefs.getString('localstud-studentNum')!;
      String college = localPrefs.getString('localstud-college')!;
      String creatorName = localPrefs.getString('localstud-fullname')!;
      String course = localPrefs.getString('localstud-course')!;
      int yearlevel = localPrefs.getInt('localstud-yearlevel')!;
      int section = localPrefs.getInt('localstud-section')!;
      int completionYear = localPrefs.getInt('completion-year')!;
      String curEmail = localPrefs.getString('localstud-email')!;
      String myToken = localPrefs.getString('device-token')!;
      //set thread title to localpref
      // await localPrefs.setString('localstud-threadtitle', _threadTitle!);
      var updateThread = Thread(
        id: _firebaseAuth.currentUser!.email! + uuid.v4(),
        title: _threadTitle!,
        msgSent: 0,
        studID: studID,
        college: college,
        creatorName: creatorName,
        creatorSection: yearlevel > completionYear
            ? 'Alumnus'
            : course + ' ' + yearlevel.toString() + '-' + section.toString(),
        tSdate: date,
        isReported: _isReported,
        reportersEmail: [],
        likers: [],
        description: _description,
        isDeletedByOwner: false,
        likersTokens: [],
        authorToken: myToken,
        likersIDs: [],
      );
      firestoreService2.setThread(updateThread);
      _threadTitle = threadTitle;
      notifyListeners();
    }
  }

  saveLike(String thrID, String likerEmail) async {
    firestoreService2.setLike(thrID, likerEmail);
    notifyListeners();
  }

  unLike(String thrID, String likerEmail) async {
    firestoreService2.removeLike(thrID, likerEmail);
    notifyListeners();
  }

  deleteThread(String thrID, bool isDeleted) {
    firestoreService2.removeThread(thrID, isDeleted);
    notifyListeners();
  }

  saveLikerToken(String thrID, String likerToken) async {
    firestoreService2.setLikerToken(thrID, likerToken);
    notifyListeners();
  }

  removeUnlikerToken(String thrID, String likerToken) async {
    firestoreService2.removeLikerToken(thrID, likerToken);
    notifyListeners();
  }

  saveLikerID(String thrID, String likerID) async {
    firestoreService2.updateLikerID(thrID, likerID);
    notifyListeners();
  }

  removeLikerID(String thrID, String likerID) async {
    firestoreService2.removeLikerID(thrID, likerID);
    notifyListeners();
  }

  //----------
  List<Thread> get threadList => _threadList;

  List<Thread> _threadList = [];
  Future<List<Thread>> fetchData() async {
    // _threadList = await firestoreService2.waitThreads(_threadCollege);
    // notifyListeners();
    return firestoreService2.filteredThreads(_threadCollege);
  }
}
