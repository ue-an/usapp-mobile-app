import 'package:flutter/cupertino.dart';

class SortProvider with ChangeNotifier {
  String _sortType = 'mostpopular';

  String get sortType => _sortType;

  set changeSortType(String sortType) {
    _sortType = sortType;
    notifyListeners();
  }
}
