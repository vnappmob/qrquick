import 'package:flutter/foundation.dart';

class ScanModel extends ChangeNotifier {
  String _scanContent = '';
  String get scanContent => _scanContent;

  Future<void> updateScanContent(value) async {
    _scanContent = value;
    notifyListeners();
  }
}
