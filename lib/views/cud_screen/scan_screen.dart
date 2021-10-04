import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrquick/models/app_model.dart';
import 'package:qrquick/models/scan_model.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                setState(() {
                  this.controller = controller;
                });
                controller.scannedDataStream.listen((scanData) {
                  controller.pauseCamera();
                  print(scanData.code);
                  Provider.of<ScanModel>(context, listen: false)
                      .updateReceive(scanData)
                      .then((value) {
                    Navigator.pop(context);
                  });
                });
              },
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea,
              ),
              onPermissionSet: (ctrl, p) {
                if (!p) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('no Permission')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
