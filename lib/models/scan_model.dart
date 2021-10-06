import 'package:flutter/foundation.dart';

class ScanModel extends ChangeNotifier {
  String _content = '';
  String get content => _content;

  Future<void> updateContent(value) async {
    _content = value;
    notifyListeners();
  }
}
