import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanModel extends ChangeNotifier {
  Barcode? _receivedBarcode;
  Barcode? get receivedBarcode => _receivedBarcode;

  Future<void> updateReceive(value) async {
    _receivedBarcode = value;
    notifyListeners();
  }
}
