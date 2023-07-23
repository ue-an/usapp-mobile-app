import 'package:flutter/cupertino.dart';

class PostNotifProvider with ChangeNotifier {
  List _collegeMatesTokens = [];

  List get collegeMatesTokens => _collegeMatesTokens;
}
