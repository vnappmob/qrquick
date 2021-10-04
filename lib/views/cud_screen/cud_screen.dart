import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrquick/views/cud_screen/scan_screen.dart';

import '../../globals.dart' as globals;
import '../../models/app_model.dart';
import '../../views/all_widgets/card_view.dart';

class CUDScreen extends StatefulWidget {
  @override
  _CUDScreenState createState() => _CUDScreenState();
}

class _CUDScreenState extends State<CUDScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _contentController;
  String qrContent = "";

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          child: Center(
            child: ListView(
              children: [
                CardView(
                  headTitle: Text('QR Code content'),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    children: [
                      TextFormField(
                        key: Key('name'),
                        cursorColor: textColor,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: textColor),
                          hintText: 'Name',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        onSaved: (String? value) {},
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      TextFormField(
                        key: Key('content'),
                        maxLines: 3,
                        controller: _contentController,
                        cursorColor: textColor,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: textColor),
                          hintText: 'QR Code content',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        onSaved: (String? value) {},
                        onChanged: (String text) {
                          setState(() {
                            qrContent = text;
                          });
                        },
                      ),
                      CupertinoButton(
                        child: Text("pick image"),
                        onPressed: () async {
                          final pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile == null) {
                            return;
                          }
                          final _qrContent = await FlutterQrReader.imgScan(
                            pickedFile.path,
                          );
                          _contentController.text = _qrContent;
                          setState(() {
                            qrContent = _contentController.text;
                          });
                        },
                      ),
                      CupertinoButton(
                        child: Text('Scan from camera'),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return ScanScreen();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                CardView(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Center(
                    child: QrImage(
                      data: qrContent,
                      version: QrVersions.auto,
                      size: 300.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
