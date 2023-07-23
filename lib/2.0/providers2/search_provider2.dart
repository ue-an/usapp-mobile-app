import 'package:flutter/cupertino.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';
import 'package:usapp_mobile/models/thread.dart';

class SearchProvider2 with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();
  String _thrSearchText = '';
  String _studentSearchText = '';
  List<Thread> _threadList = [];
  TextEditingController _searchText = TextEditingController();

  //setter
  set changeThrSearchText(String thrSearchText) {
    _thrSearchText = thrSearchText;
    notifyListeners();
  }

  set changeStudSearchText(String studSearchText) {
    _studentSearchText = studSearchText;
    notifyListeners();
  }

  set changeThreadList(List<Thread> threadList) {
    _threadList = threadList;
    // notifyListeners();
  }

  //getter
  // Stream<List<Thread>> get searchResThread =>
  //     firestoreService2.fetchSearchedThreads(_thrSearchText);
  String get thrSearchText => _thrSearchText;
  // Stream<List<StudentNumber>> get searchResStudent =>
  //     firestoreService2.fetchSearchedMembers(_studentSearchText);
  String get studentSearchText => _studentSearchText;
  // List<Thread> get threadList => _threadList;
  //functions
  // Future<List<Thread>> getSearchedResult() async {
  //   return firestoreService2.getSearchedThreads(_thrSearchText);
  // }
  // Future<List<StudentNumber>> getSearchedStudResult() async {
  //   return firestoreService2.getSearchedStudents(_studentSearchText);
  // }
}
