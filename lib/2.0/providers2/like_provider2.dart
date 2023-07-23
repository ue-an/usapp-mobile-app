import 'package:flutter/cupertino.dart';
import 'package:usapp_mobile/2.0/utils2/firestore_service2.dart';

class LikeProvider with ChangeNotifier {
  FirestoreService2 firestoreService2 = FirestoreService2();
  String? _threadID;

  String? get threadID => _threadID;

  set changeThreadID(String threadID) {
    _threadID = threadID;
    notifyListeners();
  }

  saveLike() async {}
}
